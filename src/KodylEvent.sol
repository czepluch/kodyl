// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {IKodylEvent} from "./interfaces/IKodylEvent.sol";

/// @title KodylEvent
/// @notice Single event contract with skin-in-the-game incentives
/// @dev Deployed by KodylFactory, one instance per event
/// @author Kodyl Protocol
contract KodylEvent is IKodylEvent {
    // ============ Constants ============

    /// @notice Maximum number of attendees per batch check-in
    uint256 public constant MAX_BATCH_SIZE = 100;

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
        if (msg.sender != organizer) revert NotOrganizer();
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
        string memory _metadataURI
    ) {
        factory = _factory;
        organizer = _organizer;
        depositAmount = _depositAmount;
        cancellationDeadline = _cancellationDeadline;
        eventStart = _eventStart;
        eventEnd = _eventEnd;
        disputePeriod = _disputePeriod;
        maxAttendees = _maxAttendees;
        metadataURI = _metadataURI;
    }

    // ============ View Functions ============

    /// @inheritdoc IKodylEvent
    function getState() external view returns (State) {
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
        revert("Not implemented");
    }

    /// @inheritdoc IKodylEvent
    function cancel() external {
        revert("Not implemented");
    }

    /// @inheritdoc IKodylEvent
    function claim() external {
        revert("Not implemented");
    }

    // ============ Organizer Functions ============

    /// @inheritdoc IKodylEvent
    function checkIn(address attendee) external onlyOrganizer {
        revert("Not implemented");
    }

    /// @inheritdoc IKodylEvent
    function checkInBatch(address[] calldata attendeesToCheckIn) external onlyOrganizer {
        revert("Not implemented");
    }

    /// @inheritdoc IKodylEvent
    function cancelEvent() external onlyOrganizer {
        revert("Not implemented");
    }

    /// @inheritdoc IKodylEvent
    function setMetadataURI(string calldata newURI) external onlyOrganizer {
        revert("Not implemented");
    }

    // ============ Public Functions ============

    /// @inheritdoc IKodylEvent
    function claimDust() external {
        revert("Not implemented");
    }

    // ============ Receive Function ============

    /// @notice Rejects unexpected ETH transfers
    /// @dev Keeps deposit accounting clean
    receive() external payable {
        revert("Direct ETH transfers not allowed");
    }
}
