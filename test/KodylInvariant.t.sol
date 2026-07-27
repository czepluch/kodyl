// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {IKodyl} from "./Kodyl.t.sol";

/// @notice Fuzzes register / cancel across three concurrent events and five
///         actors during the registration phase, asserting the singleton's
///         ledger invariants: the contract balance equals the global ledger
///         plus any forced ETH, and each event's pot equals its registered
///         count times its deposit.
contract KodylHandler is Test {
    IKodyl internal k;
    uint256[] internal eids;
    uint256[] internal deposits;
    address[] internal actors;

    // Forced ETH pushed past the ledger (selfdestruct / block rewards,
    // modelled with vm.deal); the contract cannot see or reject it.
    uint256 public ghostForced;

    constructor(IKodyl _k, uint256[] memory _eids, uint256[] memory _deposits, address[] memory _actors) {
        k = _k;
        eids = _eids;
        deposits = _deposits;
        actors = _actors;
    }

    function register(uint256 eventSeed, uint256 actorSeed) public {
        uint256 i = eventSeed % eids.length;
        address a = actors[actorSeed % actors.length];
        vm.deal(a, deposits[i]);
        vm.prank(a);
        try k.register{value: deposits[i]}(eids[i]) {} catch {}
    }

    function cancel(uint256 eventSeed, uint256 actorSeed) public {
        uint256 i = eventSeed % eids.length;
        address a = actors[actorSeed % actors.length];
        vm.prank(a);
        try k.cancel(eids[i]) {} catch {}
    }

    function forceEth(uint96 seed) public {
        uint256 amt = bound(uint256(seed), 1, 1 ether);
        vm.deal(address(k), address(k).balance + amt);
        ghostForced += amt;
    }
}

contract KodylInvariantTest is Test {
    uint256 internal constant START_TS = 1_700_000_000;

    IKodyl internal k;
    KodylHandler internal handler;
    uint256[] internal eids;
    uint256[] internal deposits;

    function setUp() public {
        vm.warp(START_TS);
        k = IKodyl(CoreDeploy.deploy("Kodyl", abi.encode(makeAddr("maintainer"))));

        uint256 eventStart = START_TS + 30 days;
        // Three events with different deposits so cross-event ledger mixing
        // would be caught immediately.
        deposits = new uint256[](3);
        deposits[0] = 1 ether;
        deposits[1] = 0.3 ether;
        deposits[2] = 7 wei;
        eids = new uint256[](3);
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(makeAddr(string.concat("organizer", vm.toString(i))));
            eids[i] = k.createEvent(
                deposits[i], eventStart - 7 days, eventStart, eventStart + 1 days, 1 days, 0, "ipfs://meta"
            );
        }

        address[] memory actors = new address[](5);
        for (uint256 i = 0; i < 5; ++i) {
            actors[i] = makeAddr(string.concat("actor", vm.toString(i)));
        }

        handler = new KodylHandler(k, eids, deposits, actors);
        targetContract(address(handler));
    }

    function invariant_ledgersConsistent() public view {
        uint256 total;
        for (uint256 i = 0; i < eids.length; ++i) {
            uint256 held = k.held(eids[i]);
            assertEq(held, k.registeredCount(eids[i]) * deposits[i], "per-event pot drift");
            total += held;
        }
        assertEq(k.totalHeld(), total, "global ledger drift");
        // Forced ETH sits outside the ledger by design (the contract asserts
        // balance >= totalHeld, not ==), so the balance side allows exactly it.
        assertEq(address(k).balance, k.totalHeld() + handler.ghostForced(), "balance != ledger + forced");
    }
}
