// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {IKodylEvent} from "./interfaces/IKodylEvent.sol";
import {IKodylFactory} from "./interfaces/IKodylFactory.sol";

/// @title KodylEvent
/// @notice Single event contract with skin-in-the-game incentives
/// @dev Deployed by KodylFactory, one instance per event
/// @author Kodyl Protocol
contract KodylEvent is IKodylEvent {
    // ============ Constants ============

    /// @notice Maximum number of attendees per batch check-in
    uint256 public constant MAX_BATCH_SIZE = 100;

    /// @notice Timeout period for dust claims after settlement (30 days)
    uint256 public constant DUST_CLAIM_TIMEOUT = 30 days;

    // ============ Immutable Parameters ============

    /// @notice Factory contract address
    address public immutable factory;

    /// @notice Event organizer address
    address public immutable organizer;

    /// @notice Required deposit amount in wei
    uint256 public immutable depositAmount;

    /// @notice Cancellation deadline timestamp
    uint256 public immutable cancellationDeadline;

    /// @notice Event start timestamp
    uint256 public immutable eventStart;

    /// @notice Event end timestamp
    uint256 public immutable eventEnd;

    /// @notice Dispute period duration in seconds
    uint256 public immutable disputePeriod;

    /// @notice Maximum capacity (0 = unlimited)
    uint256 public immutable maxAttendees;

    // ============ Mutable State ============

    /// @notice IPFS hash or URL for event metadata
    string public metadataURI;

    /// @notice Whether event has been cancelled
    bool public cancelled;

    /// @notice Attendee status mapping
    mapping(address => AttendeeStatus) public attendees;

    /// @notice Current number of registered attendees (excludes cancelled)
    uint256 public registeredCount;

    /// @notice Number of checked-in attendees
    uint256 public checkedInCount;

    /// @notice Number of attendees who have claimed
    uint256 public claimedCount;

    // ============ Modifiers ============

    modifier onlyOrganizer() {
        _checkOrganizer();
        _;
    }

    // ============ Constructor ============

    constructor(
        address _factory,
        address _organizer,
        uint256 _depositAmount,
        uint256 _cancellationDeadline,
        uint256 _eventStart,
        uint256 _eventEnd,
        uint256 _disputePeriod,
        uint256 _maxAttendees,
        string memory _metadataUri
    ) {
        factory = _factory;
        organizer = _organizer;
        depositAmount = _depositAmount;
        cancellationDeadline = _cancellationDeadline;
        eventStart = _eventStart;
        eventEnd = _eventEnd;
        disputePeriod = _disputePeriod;
        maxAttendees = _maxAttendees;
        metadataURI = _metadataUri;
    }

    // ============ View Functions ============

    /// @inheritdoc IKodylEvent
    function getState() public view returns (State) {
        if (cancelled) return State.Cancelled;
        if (block.timestamp < eventStart) return State.Registration;
        if (block.timestamp <= eventEnd) return State.Active;
        if (block.timestamp <= eventEnd + disputePeriod) return State.Dispute;
        return State.Settled;
    }

    /// @inheritdoc IKodylEvent
    function rewardPerAttendee() external view returns (uint256) {
        if (checkedInCount == 0) return 0;

        uint256 noShowCount = registeredCount - checkedInCount;
        uint256 totalForfeited = noShowCount * depositAmount;
        return totalForfeited / checkedInCount;
    }

    // ============ Attendee Functions ============

    /// @inheritdoc IKodylEvent
    function register() external payable {
        // ===== Function Requirements (F) =====
        if (getState() != State.Registration) revert RegistrationClosed();
        if (attendees[msg.sender] == AttendeeStatus.Registered) revert AlreadyRegistered();
        if (attendees[msg.sender] == AttendeeStatus.Claimed) {
            revert InvalidAttendeeStatus(AttendeeStatus.Claimed, AttendeeStatus.None);
        }
        if (msg.value != depositAmount) revert IncorrectDeposit(depositAmount, msg.value);

        // Check capacity if maxAttendees > 0
        if (maxAttendees > 0 && registeredCount >= maxAttendees) {
            revert EventFull();
        }

        // ===== Effects (E) =====
        attendees[msg.sender] = AttendeeStatus.Registered;
        unchecked {
            ++registeredCount;
        }

        // ===== Protocol Invariants (PI) =====
        // Deposit accounting invariant
        assert(address(this).balance == registeredCount * depositAmount);

        emit Registered(msg.sender);
    }

    /// @inheritdoc IKodylEvent
    function cancel() external {
        // ===== Function Requirements (F) =====
        if (block.timestamp > cancellationDeadline) revert CancellationDeadlinePassed();
        if (attendees[msg.sender] != AttendeeStatus.Registered) {
            revert InvalidAttendeeStatus(attendees[msg.sender], AttendeeStatus.Registered);
        }

        // ===== Effects (E) =====
        attendees[msg.sender] = AttendeeStatus.Cancelled;
        unchecked {
            --registeredCount;
        }

        // ===== Interactions (I) =====
        // Refund the deposit
        (bool success,) = payable(msg.sender).call{value: depositAmount}("");
        if (!success) revert TransferFailed();

        // ===== Protocol Invariants (PI) =====
        assert(address(this).balance == registeredCount * depositAmount);

        emit RegistrationCancelled(msg.sender);
    }

    /// @inheritdoc IKodylEvent
    function claim() external {
        // ===== Function Requirements (F) =====
        if (getState() != State.Settled) revert NotSettled();
        if (attendees[msg.sender] != AttendeeStatus.CheckedIn) {
            revert InvalidAttendeeStatus(attendees[msg.sender], AttendeeStatus.CheckedIn);
        }

        // ===== Effects (E) =====
        attendees[msg.sender] = AttendeeStatus.Claimed;
        unchecked {
            ++claimedCount;
        }

        // Calculate payout: deposit + pro-rata share of forfeited deposits
        uint256 reward = _calculateReward();
        uint256 payout = depositAmount + reward;

        // ===== Interactions (I) =====
        (bool success,) = payable(msg.sender).call{value: payout}("");
        if (!success) revert TransferFailed();

        // ===== Protocol Invariants (PI) =====
        // Note: Balance decreases by payout, but we can't check exact equality
        // due to dust. Invariant will be verified in claimDust().

        emit Claimed(msg.sender, payout);
    }

    // ============ Organizer Functions ============

    /// @inheritdoc IKodylEvent
    function checkIn(address attendee) external onlyOrganizer {
        _checkIn(attendee);
    }

    /// @inheritdoc IKodylEvent
    function checkInBatch(address[] calldata attendeesToCheckIn) external onlyOrganizer {
        if (attendeesToCheckIn.length > MAX_BATCH_SIZE) {
            revert BatchTooLarge(attendeesToCheckIn.length, MAX_BATCH_SIZE);
        }

        for (uint256 i = 0; i < attendeesToCheckIn.length; ++i) {
            _checkIn(attendeesToCheckIn[i]);
        }
    }

    /// @inheritdoc IKodylEvent
    function cancelEvent() external onlyOrganizer {
        // ===== Function Requirements (F) =====
        if (getState() != State.Registration) revert EventAlreadyStarted();
        if (cancelled) revert InvalidAttendeeStatus(AttendeeStatus.Cancelled, AttendeeStatus.None);

        // ===== Effects (E) =====
        cancelled = true;

        emit EventCancelled();
    }

    /// @inheritdoc IKodylEvent
    function setMetadataURI(string calldata newUri) external onlyOrganizer {
        metadataURI = newUri;
        emit MetadataUpdated(newUri);
    }

    // ============ Public Functions ============

    /// @inheritdoc IKodylEvent
    function claimDust() external {
        // ===== Function Requirements (F) =====
        if (getState() != State.Settled) revert NotSettled();
        if (cancelled) revert NotSettled(); // Can't claim dust from cancelled events

        // Must either have all checked-in attendees claimed OR timeout has passed
        bool allClaimed = claimedCount == checkedInCount;
        bool timeoutPassed = block.timestamp > eventEnd + disputePeriod + DUST_CLAIM_TIMEOUT;

        if (!allClaimed && !timeoutPassed) revert DustNotClaimable();

        // ===== Effects (E) =====
        uint256 dust = address(this).balance;
        if (dust == 0) revert DustNotClaimable();

        address maintainer = IKodylFactory(factory).maintainer();

        // ===== Interactions (I) =====
        (bool success,) = payable(maintainer).call{value: dust}("");
        if (!success) revert TransferFailed();

        emit DustClaimed(maintainer, dust);

        // ===== Protocol Invariants (PI) =====
        // After dust claim, balance should be 0
        assert(address(this).balance == 0);
    }

    // ============ Receive Function ============

    /// @notice Rejects unexpected ETH transfers
    /// @dev Keeps deposit accounting clean - prevents direct ETH sends
    receive() external payable {
        revert TransferFailed();
    }

    // ============ Internal Functions ============

    /// @dev Checks if caller is the organizer
    function _checkOrganizer() internal view {
        if (msg.sender != organizer) revert NotOrganizer();
    }

    /// @dev Internal check-in logic
    /// @param attendee Address to check in
    function _checkIn(address attendee) internal {
        // ===== Function Requirements (F) =====
        // Check-ins allowed from event start through dispute period end
        uint256 currentTime = block.timestamp;
        if (currentTime < eventStart || currentTime > eventEnd + disputePeriod) {
            revert CheckInWindowClosed();
        }

        AttendeeStatus status = attendees[attendee];

        // Skip if not registered or already checked in
        if (status != AttendeeStatus.Registered) {
            return;
        }

        // ===== Effects (E) =====
        attendees[attendee] = AttendeeStatus.CheckedIn;
        unchecked {
            ++checkedInCount;
        }

        emit CheckedIn(attendee);
    }

    /// @dev Calculates reward per attendee from no-show deposits
    /// @return reward Amount each checked-in attendee receives from forfeited deposits
    function _calculateReward() internal view returns (uint256 reward) {
        if (checkedInCount == 0) return 0;

        uint256 noShowCount = registeredCount - checkedInCount;
        uint256 totalForfeited = noShowCount * depositAmount;
        reward = totalForfeited / checkedInCount;
    }
}
