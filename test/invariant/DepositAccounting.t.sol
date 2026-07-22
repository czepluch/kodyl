// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {KodylEvent} from "../../src/KodylEvent.sol";

/// @notice Drives random register / cancel / re-register sequences from a
/// bounded set of actors while the event stays in the Registration phase.
/// Reverts are swallowed so the fuzzer explores freely; the invariant is
/// checked by the parent test after each call.
contract RegistrationHandler is Test {
    KodylEvent internal e;
    uint256 internal depositAmount;
    address[] internal actors;

    constructor(KodylEvent _e, uint256 _deposit, address[] memory _actors) {
        e = _e;
        depositAmount = _deposit;
        actors = _actors;
    }

    function _actor(uint256 seed) internal view returns (address) {
        return actors[seed % actors.length];
    }

    function register(uint256 seed) public {
        address a = _actor(seed);
        vm.deal(a, depositAmount);
        vm.prank(a);
        try e.register{value: depositAmount}() {} catch {}
    }

    function cancel(uint256 seed) public {
        address a = _actor(seed);
        vm.prank(a);
        try e.cancel() {} catch {}
    }
}

contract DepositAccountingInvariant is Test {
    KodylEvent internal e;
    RegistrationHandler internal handler;

    uint256 internal constant DEPOSIT = 1 ether;
    uint256 internal constant START_TS = 1_700_000_000;

    function setUp() public {
        vm.warp(START_TS);

        uint256 eventStart = START_TS + 30 days;
        // register/cancel never touch the factory, so a placeholder address is fine.
        e = new KodylEvent(
            address(0xF00),
            makeAddr("organizer"),
            DEPOSIT,
            eventStart - 7 days, // cancellation deadline (well ahead: spec intent)
            eventStart,
            eventStart + 1 days,
            1 days,
            0,
            "ipfs://meta"
        );

        address[] memory actors = new address[](5);
        for (uint256 i = 0; i < 5; ++i) {
            actors[i] = makeAddr(string.concat("actor", vm.toString(i)));
        }

        handler = new RegistrationHandler(e, DEPOSIT, actors);
        targetContract(address(handler));
    }

    /// @notice Invariant #1 (registration phase): the contract holds exactly one
    /// deposit per currently-registered attendee, no more, no less. The fuzzer
    /// never advances time, so the event remains in Registration and no dust
    /// or rewards enter the accounting.
    function invariant_depositAccounting() public view {
        assertEq(address(e).balance, e.registeredCount() * DEPOSIT);
    }
}
