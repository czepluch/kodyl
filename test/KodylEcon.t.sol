// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {Test} from "forge-std/Test.sol";
import {CoreDeploy} from "./CoreDeploy.sol";
import {KodylAbi} from "./KodylAbi.sol";

/// @notice The executable payoff matrix behind ECONOMICS.md: every adversarial
///         strategy from spec.md's Trust Assumptions run against the real
///         bytecode, asserting each actor's exact ETH delta plus the on-chain
///         footprint counters an indexer would see. Actors are funded with
///         exactly the deposit at registration, so a final balance reads
///         directly as deposit + net outcome. Every number cited in
///         ECONOMICS.md resolves to an assertion here.
contract KodylEconTest is Test {
    uint256 internal constant START_TS = 1_700_000_000;
    uint256 internal constant DEPOSIT = 1 ether;

    address internal maintainer = makeAddr("maintainer");
    address internal organizer = makeAddr("organizer");

    KodylAbi internal k;
    uint256 internal eventStart;
    uint256 internal eventEnd;
    uint256 internal disputePeriod = 1 days;

    function setUp() public {
        vm.warp(START_TS);
        k = KodylAbi(payable(CoreDeploy.deploy("Kodyl", abi.encode(maintainer))));
        eventStart = START_TS + 30 days;
        eventEnd = eventStart + 1 days;
    }

    function _createAs(address org, uint256 dep, uint256 cap) internal returns (uint256) {
        vm.prank(org);
        return k.createEvent(dep, eventStart - 7 days, eventStart, eventEnd, disputePeriod, cap, "ipfs://meta");
    }

    function _create(uint256 dep) internal returns (uint256) {
        return _createAs(organizer, dep, 0);
    }

    // Fund with exactly the deposit and register: the actor's final balance is
    // deposit + net, so payoff assertions read off balances directly.
    function _reg(uint256 eid, address who, uint256 dep) internal {
        vm.deal(who, dep);
        vm.prank(who);
        k.register{value: dep}(eid);
    }

    function _actors(string memory salt, uint256 n) internal returns (address[] memory who) {
        who = new address[](n);
        for (uint256 i = 0; i < n; ++i) {
            who[i] = makeAddr(string.concat(salt, vm.toString(i)));
        }
    }

    function _settle() internal {
        vm.warp(eventEnd + disputePeriod + 1);
    }

    // ==================================================================
    // EIP-712 (scenario 7 signs real proofs; mirrors Kodyl.t.sol's helpers)
    // ==================================================================

    bytes32 internal constant DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 internal constant TICKET_TYPEHASH = keccak256("Ticket(uint256 eventId)");
    bytes32 internal constant PRESENCE_TYPEHASH = keccak256("Presence(uint256 eventId,address attendee)");

    function _digest712(bytes32 structHash) internal view returns (bytes32) {
        bytes32 dom = keccak256(
            abi.encode(DOMAIN_TYPEHASH, keccak256("Kodyl"), keccak256("1"), block.chainid, address(k))
        );
        return keccak256(abi.encodePacked(hex"1901", dom, structHash));
    }

    function _signTicket(uint256 pk, uint256 eid) internal view returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, _digest712(keccak256(abi.encode(TICKET_TYPEHASH, eid))));
        return abi.encodePacked(r, s, v);
    }

    function _signPresence(uint256 pk, uint256 eid, address attendee) internal view returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(pk, _digest712(keccak256(abi.encode(PRESENCE_TYPEHASH, eid, attendee))));
        return abi.encodePacked(r, s, v);
    }

    // ==================================================================
    // 1. Honest baseline: the reference row every attack compares against.
    // ==================================================================

    function test_econ_honestBaseline() public {
        uint256 eid = _create(DEPOSIT);
        address[] memory att = _actors("attendee", 3);
        address[] memory ns = _actors("noshow", 2);
        for (uint256 i = 0; i < 3; ++i) _reg(eid, att[i], DEPOSIT);
        for (uint256 i = 0; i < 2; ++i) _reg(eid, ns[i], DEPOSIT);

        vm.warp(eventStart);
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(organizer);
            k.checkIn(eid, att[i]);
        }

        _settle();
        uint256 reward = (2 * DEPOSIT) / 3; // floor(2e18/3) = 666666666666666666 wei
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(att[i]);
            k.claim(eid);
            // Deposit round-trips; the no-shows' forfeitures are the bonus.
            assertEq(att[i].balance, DEPOSIT + reward, "attendee payout");
        }
        for (uint256 i = 0; i < 2; ++i) {
            assertEq(ns[i].balance, 0, "no-show forfeits the whole deposit");
        }

        // Rounding dust (2e18 - 3*reward = 2 wei) is the maintainer's, nothing more.
        k.claimDust(eid);
        assertEq(maintainer.balance, 2 wei, "dust");
        assertEq(organizer.balance, 0, "organizer earns nothing via the protocol");
        assertEq(address(k).balance, 0, "pot fully distributed");
    }

    // ==================================================================
    // 2. Sybil capture, bounded by the reward cap: the fake-event scam.
    // Exclude everyone honest, check in one sock puppet - the cap holds the
    // sybil to ONE deposit of profit however many victims registered, and
    // the excess rebates to the victims.
    // ==================================================================

    function test_econ_sybilCaptureBoundedToOneDeposit() public {
        uint256 eid = _create(DEPOSIT);
        address[] memory honest = _actors("honest", 10);
        address sybil = makeAddr("sybil");
        for (uint256 i = 0; i < 10; ++i) _reg(eid, honest[i], DEPOSIT);
        _reg(eid, sybil, DEPOSIT);

        vm.warp(eventStart);
        vm.prank(organizer);
        k.checkIn(eid, sybil); // and nobody else

        _settle();
        vm.prank(sybil);
        k.claim(eid);

        // The cap: deposit back plus at most one deposit of reward. Profit is
        // one deposit total, for ten victims - the scam does not scale.
        assertEq(sybil.balance, 2 * DEPOSIT, "capture is capped at one deposit of profit");

        // The capped-off excess rebates to the victims: 9d across 10 no-shows.
        uint256 rebate = (9 * DEPOSIT) / 10;
        assertEq(k.noShowRebate(eid), rebate);
        for (uint256 i = 0; i < 10; ++i) {
            vm.prank(honest[i]);
            k.claimNoShowRebate(eid);
            assertEq(honest[i].balance, rebate, "victim recovers 90 percent");
        }
        // Aggregate victim loss equals the attacker's profit exactly.
        assertEq(10 * (DEPOSIT - rebate), DEPOSIT, "total victim loss == capped profit");
        assertEq(organizer.balance, 0, "profit routes through the sybil, not the organizer account");
        assertEq(address(k).balance, 0, "pot fully distributed");

        // The on-chain footprint an indexer sees: 11 registered, 1 checked in
        // - the loud red-flag ratio - now with ten RebateClaimed logs too.
        assertEq(k.registeredCount(eid), 11);
        assertEq(k.checkedInCount(eid), 1);
        assertEq(k.claimedCount(eid), 1);
    }

    // ==================================================================
    // 3. Sybil skim: check in the honest attendees AND s sybils. Everyone who
    // attended still gets paid, just less - the subtle, hard-to-notice theft.
    // ==================================================================

    function test_econ_sybilSkimsForfeitures() public {
        // Event A: 4 honest checked in, 3 no-shows, 2 sybils checked in.
        // Event B: the s=0 counterfactual with identical honest turnout.
        uint256 a = _createAs(organizer, DEPOSIT, 0);
        uint256 b = _createAs(makeAddr("cleanOrg"), DEPOSIT, 0);

        address[] memory hA = _actors("hA", 4);
        address[] memory nsA = _actors("nsA", 3);
        address[] memory syb = _actors("syb", 2);
        address[] memory hB = _actors("hB", 4);
        address[] memory nsB = _actors("nsB", 3);
        for (uint256 i = 0; i < 4; ++i) _reg(a, hA[i], DEPOSIT);
        for (uint256 i = 0; i < 3; ++i) _reg(a, nsA[i], DEPOSIT);
        for (uint256 i = 0; i < 2; ++i) _reg(a, syb[i], DEPOSIT);
        for (uint256 i = 0; i < 4; ++i) _reg(b, hB[i], DEPOSIT);
        for (uint256 i = 0; i < 3; ++i) _reg(b, nsB[i], DEPOSIT);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        for (uint256 i = 0; i < 4; ++i) k.checkIn(a, hA[i]);
        for (uint256 i = 0; i < 2; ++i) k.checkIn(a, syb[i]);
        vm.stopPrank();
        vm.startPrank(makeAddr("cleanOrg"));
        for (uint256 i = 0; i < 4; ++i) k.checkIn(b, hB[i]);
        vm.stopPrank();

        _settle();
        for (uint256 i = 0; i < 4; ++i) {
            vm.prank(hA[i]);
            k.claim(a);
            vm.prank(hB[i]);
            k.claim(b);
        }
        for (uint256 i = 0; i < 2; ++i) {
            vm.prank(syb[i]);
            k.claim(a);
        }

        uint256 skimmed = (3 * DEPOSIT) / 6; // floor(m*d/(c+s)) = 0.5 ether
        uint256 fair = (3 * DEPOSIT) / 4; // floor(m*d/c)     = 0.75 ether
        for (uint256 i = 0; i < 2; ++i) {
            assertEq(syb[i].balance, DEPOSIT + skimmed, "each sybil skims a claimant share");
        }
        for (uint256 i = 0; i < 4; ++i) {
            assertEq(hA[i].balance, DEPOSIT + skimmed, "diluted honest reward");
            assertEq(hB[i].balance, DEPOSIT + fair, "counterfactual fair reward");
            // The theft, measured on-chain: what each honest attendee lost to
            // the sybil block.
            assertEq(hB[i].balance - hA[i].balance, fair - skimmed, "dilution per honest attendee");
        }
        // The sybil block's total take equals the honest attendees' losses
        // (up to floor-division dust).
        assertEq(2 * skimmed, 1 ether, "sybil block extracts 2 * 0.5 ether");
    }

    // ==================================================================
    // 4. Exclusion griefing: refusing to check in one attendee costs the
    // organizer nothing and pays them nothing - the harm needs no motive.
    // ==================================================================

    function test_econ_exclusionGriefingIsFree() public {
        uint256 eid = _create(DEPOSIT);
        address victim = makeAddr("victim");
        address[] memory att = _actors("present", 2);
        _reg(eid, victim, DEPOSIT);
        for (uint256 i = 0; i < 2; ++i) _reg(eid, att[i], DEPOSIT);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        for (uint256 i = 0; i < 2; ++i) k.checkIn(eid, att[i]);
        vm.stopPrank(); // the victim, though present, is never checked in

        _settle();
        uint256 reward = DEPOSIT / 2;
        for (uint256 i = 0; i < 2; ++i) {
            vm.prank(att[i]);
            k.claim(eid);
            assertEq(att[i].balance, DEPOSIT + reward, "other claimants absorb the forfeiture");
        }
        assertEq(victim.balance, 0, "the excluded attendee loses the whole deposit");
        assertEq(organizer.balance, 0, "griefing is free: the organizer moves no ETH");
        // The victim has no on-chain recourse: claim needs CheckedIn status.
        vm.prank(victim);
        vm.expectRevert(abi.encodeWithSelector(KodylAbi.InvalidAttendeeStatus.selector, 1, 3));
        k.claim(eid);
    }

    // ==================================================================
    // 5. Abandonment: check in nobody and the event settles as abandoned -
    // refunds open for everyone, nobody profits, nothing sweeps.
    // ==================================================================

    function test_econ_abandonmentRefundsEveryone() public {
        uint256 eid = _create(DEPOSIT);
        address[] memory att = _actors("abandoned", 4);
        for (uint256 i = 0; i < 4; ++i) _reg(eid, att[i], DEPOSIT);

        // The organizer does nothing at all.
        _settle();
        assertEq(k.checkedInCount(eid), 0);

        // No sweep, ever: the pot belongs to refunds.
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);
        vm.warp(eventEnd + disputePeriod + 30 days + 1);
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);

        for (uint256 i = 0; i < 4; ++i) {
            vm.prank(att[i]);
            k.claimRefund(eid);
            assertEq(att[i].balance, DEPOSIT, "abandonment costs the attendee nothing");
        }
        assertEq(maintainer.balance, 0, "the maintainer no longer profits from failed events");
        assertEq(organizer.balance, 0);
        assertEq(address(k).balance, 0, "pot fully refunded");
    }

    // ==================================================================
    // 6. The 30-day sweep takes a sleeping claimant's payout - reward
    // included - not just rounding dust.
    // ==================================================================

    function test_econ_sweepTakesUnclaimedPayouts() public {
        uint256 eid = _create(DEPOSIT);
        address awake = makeAddr("awake");
        address sleeper = makeAddr("sleeper");
        address noshow = makeAddr("ns");
        _reg(eid, awake, DEPOSIT);
        _reg(eid, sleeper, DEPOSIT);
        _reg(eid, noshow, DEPOSIT);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        k.checkIn(eid, awake);
        k.checkIn(eid, sleeper);
        vm.stopPrank();

        _settle();
        uint256 payout = DEPOSIT + DEPOSIT / 2;
        vm.prank(awake);
        k.claim(eid);
        assertEq(awake.balance, payout);

        // The sleeper misses the 30-day window; the sweep takes their full
        // payout (deposit + earned reward), not merely dust.
        vm.warp(eventEnd + disputePeriod + 30 days + 1);
        k.claimDust(eid);
        assertEq(maintainer.balance, payout, "maintainer takes the sleeper's payout");
        vm.prank(sleeper);
        vm.expectRevert(KodylAbi.PayoutSwept.selector);
        k.claim(eid);
        assertEq(sleeper.balance, 0, "sleeping past the sweep forfeits everything");
    }

    // ==================================================================
    // 7. Operator collusion: an operator-signed Presence reproduces the
    // sybil capture exactly - appointing an operator shares the custody.
    // ==================================================================

    function test_econ_operatorCollusionEqualsOrganizer() public {
        uint256 eid = _create(DEPOSIT);
        address[] memory honest = _actors("honestOp", 3);
        (address sybil, uint256 sybilPk) = makeAddrAndKey("sybilSigner");
        (address operator, uint256 operatorPk) = makeAddrAndKey("colludingOp");
        for (uint256 i = 0; i < 3; ++i) _reg(eid, honest[i], DEPOSIT);
        _reg(eid, sybil, DEPOSIT);

        vm.prank(organizer);
        k.setOperator(eid, operator, true);

        // The operator attests the sybil's presence; any relayer submits.
        vm.warp(eventStart);
        k.checkInWithProof(eid, sybil, _signTicket(sybilPk, eid), _signPresence(operatorPk, eid, sybil));

        _settle();
        vm.prank(sybil);
        k.claim(eid);

        // Identical payoff shape to the organizer's own capture: capped at
        // one deposit of profit, the excess rebating to the victims.
        assertEq(sybil.balance, 2 * DEPOSIT, "operator-attested capture capped like the organizer's");
        uint256 rebate = (2 * DEPOSIT) / 3;
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(honest[i]);
            k.claimNoShowRebate(eid);
            assertEq(honest[i].balance, rebate);
        }
        // Neither authority figure moves ETH on-chain; the split is off-chain.
        assertEq(operator.balance, 0);
        assertEq(organizer.balance, 0);
        assertEq(k.registeredCount(eid), 4);
        assertEq(k.checkedInCount(eid), 1);
    }

    // ==================================================================
    // 8. Maintainer-as-organizer self-capture is DEAD: abandoning an own
    // event routes nothing anywhere - the pot refunds.
    // ==================================================================

    function test_econ_maintainerSelfCaptureDefeated() public {
        uint256 eid = _createAs(maintainer, DEPOSIT, 0);
        address[] memory att = _actors("trusting", 3);
        for (uint256 i = 0; i < 3; ++i) _reg(eid, att[i], DEPOSIT);

        // Abandon: check in nobody, then try to sweep as maintainer.
        _settle();
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);
        vm.warp(eventEnd + disputePeriod + 30 days + 1);
        vm.expectRevert(KodylAbi.DustNotClaimable.selector);
        k.claimDust(eid);

        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(att[i]);
            k.claimRefund(eid);
            assertEq(att[i].balance, DEPOSIT);
        }
        assertEq(maintainer.balance, 0, "self-capture nets exactly nothing");
        // The rational scammer's remaining move is a sybil (attack 1), which
        // costs a check-in transaction and leaves the loud 1-of-n footprint.
    }

    // ==================================================================
    // 9. Capacity griefing: fill the cap, cancel at the deadline. Costs
    // only capital lockup + gas; denies slots for the whole pre-deadline
    // window.
    // ==================================================================

    function test_econ_capacityGriefingCostsOnlyLockup() public {
        uint256 eid = _createAs(organizer, DEPOSIT, 3);
        address[] memory grief = _actors("grief", 3);
        for (uint256 i = 0; i < 3; ++i) _reg(eid, grief[i], DEPOSIT);

        // Capacity denied: an honest attendee cannot register while filled.
        address honest = makeAddr("lockedOut");
        vm.deal(honest, DEPOSIT);
        vm.prank(honest);
        vm.expectRevert(KodylAbi.EventFull.selector);
        k.register{value: DEPOSIT}(eid);

        // At the deadline (inclusive) the griefer exits with full refunds.
        vm.warp(eventStart - 7 days);
        for (uint256 i = 0; i < 3; ++i) {
            vm.prank(grief[i]);
            k.cancel(eid);
            assertEq(grief[i].balance, DEPOSIT, "griefer's exit is a full refund");
        }
        assertEq(k.registeredCount(eid), 0, "slots freed only at the deadline");

        // The freed slot is only registrable in the no-self-service-exit
        // window: whoever takes it now cannot cancel.
        vm.warp(eventStart - 7 days + 1);
        vm.prank(honest);
        k.register{value: DEPOSIT}(eid);
        vm.prank(honest);
        vm.expectRevert(KodylAbi.CancellationDeadlinePassed.selector);
        k.cancel(eid);
    }

    // ==================================================================
    // Fuzzed payoff formulas.
    // ==================================================================

    /// Sybil capture profit is capped at exactly one deposit for ANY number
    /// of victims and any deposit size; each victim's rebate recovers all but
    /// their pro-rata share of that one deposit.
    function testFuzz_econ_sybilProfitCappedAtOneDeposit(uint256 nHonest, uint256 dep) public {
        nHonest = bound(nHonest, 1, 20);
        dep = bound(dep, 1 wei, 100 ether);

        uint256 eid = _create(dep);
        address[] memory honest = _actors("fh", nHonest);
        address sybil = makeAddr("fsybil");
        for (uint256 i = 0; i < nHonest; ++i) _reg(eid, honest[i], dep);
        _reg(eid, sybil, dep);

        vm.warp(eventStart);
        vm.prank(organizer);
        k.checkIn(eid, sybil);

        _settle();
        vm.prank(sybil);
        k.claim(eid);
        assertEq(sybil.balance, 2 * dep, "profit capped at one deposit, victims notwithstanding");
        assertGe(sybil.balance, dep, "the sybil's own deposit was never at risk");

        // Every victim recovers floor((nHonest-1)*d/nHonest); at nHonest == 1
        // the excess is zero and the rebate path reports NothingToRebate.
        uint256 rebate = ((nHonest - 1) * dep) / nHonest;
        for (uint256 i = 0; i < nHonest; ++i) {
            if (rebate > 0) {
                vm.prank(honest[i]);
                k.claimNoShowRebate(eid);
            } else {
                vm.prank(honest[i]);
                vm.expectRevert(KodylAbi.NothingToRebate.selector);
                k.claimNoShowRebate(eid);
            }
            assertEq(honest[i].balance, rebate, "victim rebate exact");
        }
    }

    /// Skim arithmetic under the cap: c honest + s sybils checked in, m
    /// no-shows. Every claimant gets min(floor(m*d/(c+s)), d); when the cap
    /// binds (m > c+s) the excess rebates to the no-shows and only the
    /// remainder is dust (post-timeout).
    function testFuzz_econ_skimShareExact(uint256 c, uint256 s, uint256 m, uint256 dep) public {
        c = bound(c, 1, 6);
        s = bound(s, 1, 6);
        m = bound(m, 0, 6);
        dep = bound(dep, 1 wei, 100 ether);

        uint256 eid = _create(dep);
        address[] memory hon = _actors("sc", c);
        address[] memory syb = _actors("ss", s);
        address[] memory ns = _actors("sm", m);
        for (uint256 i = 0; i < c; ++i) _reg(eid, hon[i], dep);
        for (uint256 i = 0; i < s; ++i) _reg(eid, syb[i], dep);
        for (uint256 i = 0; i < m; ++i) _reg(eid, ns[i], dep);

        vm.warp(eventStart);
        vm.startPrank(organizer);
        for (uint256 i = 0; i < c; ++i) k.checkIn(eid, hon[i]);
        for (uint256 i = 0; i < s; ++i) k.checkIn(eid, syb[i]);
        vm.stopPrank();

        _settle();
        // With cap multiple 1 the cap binds exactly when no-shows outnumber
        // claimants (m > c+s), and then the reward is exactly one deposit.
        bool capped = m > c + s;
        uint256 share = capped ? dep : (m * dep) / (c + s);
        for (uint256 i = 0; i < c; ++i) {
            vm.prank(hon[i]);
            k.claim(eid);
            assertEq(hon[i].balance, dep + share, "honest claimant share");
        }
        uint256 sybilTotal;
        for (uint256 i = 0; i < s; ++i) {
            vm.prank(syb[i]);
            k.claim(eid);
            assertEq(syb[i].balance, dep + share, "sybil claimant share");
            sybilTotal += syb[i].balance - dep;
        }
        assertEq(sybilTotal, s * share, "sybil block extraction");

        // Rebate leg and dust, all three regimes exact: uncapped; capped with
        // a claimable per-no-show rebate; capped with the excess too small to
        // split (floor 0: NothingToRebate on-chain, the excess stays dust and
        // the early all-claimed sweep door stays open).
        uint256 rebatePer = capped ? ((m - (c + s)) * dep) / m : 0;
        for (uint256 i = 0; i < m && rebatePer > 0; ++i) {
            vm.prank(ns[i]);
            k.claimNoShowRebate(eid);
            assertEq(ns[i].balance, rebatePer, "no-show rebate share");
        }
        uint256 remainder = capped ? (m - (c + s)) * dep - m * rebatePer : (m * dep) % (c + s);
        if (remainder > 0) {
            if (rebatePer > 0) vm.warp(eventEnd + disputePeriod + 30 days + 1);
            k.claimDust(eid);
        }
        assertEq(maintainer.balance, remainder, "dust = division remainder");
        assertEq(address(k).balance, 0, "every wei accounted");
    }
}
