// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

/// @title IKodylEvent
/// @notice Interface for Kodyl event contracts
/// @dev One contract instance per event, deployed via KodylFactory
interface IKodylEvent {
    // ============ Enums ============

    /// @notice Event lifecycle states (derived from timestamps, not stored)
    enum State {
        Registration, // Before event starts - registration and cancellation allowed
        Active, // Event in progress - check-ins allowed
        Dispute, // Post-event window for late check-in approvals
        Settled, // Claims allowed, no further state changes
        Cancelled // Organizer cancelled event - refunds only
    }

    /// @notice Attendee status (stored per address)
    enum AttendeeStatus {
        None, // Never registered
        Registered, // Deposited, not yet checked in
        Cancelled, // Cancelled before deadline, got refund
        CheckedIn, // Verified attendance
        Claimed // Already claimed payout
    }

    // ============ Events ============

    /// @notice Emitted when an attendee registers for the event
    /// @param attendee Address of the registering attendee
    event Registered(address indexed attendee);

    /// @notice Emitted when an attendee cancels their registration
    /// @param attendee Address of the cancelling attendee
    event RegistrationCancelled(address indexed attendee);

    /// @notice Emitted when an attendee is checked in by the organizer
    /// @param attendee Address of the checked-in attendee
    event CheckedIn(address indexed attendee);

    /// @notice Emitted when an attendee claims their payout
    /// @param attendee Address of the claiming attendee
    /// @param amount Total payout amount (deposit + reward)
    event Claimed(address indexed attendee, uint256 amount);

    /// @notice Emitted when the organizer cancels the entire event
    event EventCancelled();

    /// @notice Emitted when event metadata URI is updated
    /// @param newURI The new metadata URI
    event MetadataUpdated(string newURI);

    /// @notice Emitted when dust is claimed by project maintainer
    /// @param recipient Address receiving the dust
    /// @param amount Amount of dust claimed
    event DustClaimed(address indexed recipient, uint256 amount);

    // ============ Errors ============

    /// @notice Thrown when caller is not the organizer
    error NotOrganizer();

    /// @notice Thrown when trying to register but event is not in Registration state
    error RegistrationClosed();

    /// @notice Thrown when event has reached max capacity
    error EventFull();

    /// @notice Thrown when deposit amount is incorrect
    error IncorrectDeposit(uint256 expected, uint256 received);

    /// @notice Thrown when address is already registered
    error AlreadyRegistered();

    /// @notice Thrown when trying to cancel after deadline
    error CancellationDeadlinePassed();

    /// @notice Thrown when address is not in expected status
    error InvalidAttendeeStatus(AttendeeStatus current, AttendeeStatus expected);

    /// @notice Thrown when check-in is attempted outside valid window
    error CheckInWindowClosed();

    /// @notice Thrown when trying to claim before settlement
    error NotSettled();

    /// @notice Thrown when trying to cancel event after it started
    error EventAlreadyStarted();

    /// @notice Thrown when batch size exceeds maximum
    error BatchTooLarge(uint256 size, uint256 max);

    /// @notice Thrown when dust claim conditions not met
    error DustNotClaimable();

    /// @notice Thrown when ETH transfer fails
    error TransferFailed();

    // ============ View Functions ============

    /// @notice Returns the current event state derived from timestamps
    /// @return Current State enum value
    function getState() external view returns (State);

    /// @notice Returns the event organizer address
    function organizer() external view returns (address);

    /// @notice Returns the required deposit amount in wei
    function depositAmount() external view returns (uint256);

    /// @notice Returns the cancellation deadline timestamp
    function cancellationDeadline() external view returns (uint256);

    /// @notice Returns the event start timestamp
    function eventStart() external view returns (uint256);

    /// @notice Returns the event end timestamp
    function eventEnd() external view returns (uint256);

    /// @notice Returns the dispute period duration in seconds
    function disputePeriod() external view returns (uint256);

    /// @notice Returns the maximum number of attendees (0 = unlimited)
    function maxAttendees() external view returns (uint256);

    /// @notice Returns the metadata URI (IPFS hash or URL)
    function metadataURI() external view returns (string memory);

    /// @notice Returns whether the event has been cancelled
    function cancelled() external view returns (bool);

    /// @notice Returns the status of an attendee
    /// @param attendee Address to check
    function attendees(address attendee) external view returns (AttendeeStatus);

    /// @notice Returns current number of registered attendees (excluding cancelled)
    function registeredCount() external view returns (uint256);

    /// @notice Returns number of checked-in attendees
    function checkedInCount() external view returns (uint256);

    /// @notice Returns number of attendees who have claimed
    function claimedCount() external view returns (uint256);

    /// @notice Calculates the reward per checked-in attendee from no-show deposits
    /// @return Reward amount in wei (0 if no check-ins or no no-shows)
    function rewardPerAttendee() external view returns (uint256);

    /// @notice Returns the factory contract address
    function factory() external view returns (address);

    // ============ Attendee Functions ============

    /// @notice Register for the event by depositing the required amount
    /// @dev Reverts if not in Registration state, at capacity, or incorrect deposit
    function register() external payable;

    /// @notice Cancel registration and receive immediate refund
    /// @dev Reverts if past cancellation deadline or not registered
    function cancel() external;

    /// @notice Claim deposit plus reward after settlement
    /// @dev Reverts if not settled or not checked in
    function claim() external;

    // ============ Organizer Functions ============

    /// @notice Check in a single attendee
    /// @param attendee Address to check in
    /// @dev Reverts if not organizer, outside check-in window, or attendee not registered
    function checkIn(address attendee) external;

    /// @notice Check in multiple attendees in one transaction
    /// @param attendeesToCheckIn Array of addresses to check in
    /// @dev Skips invalid attendees without reverting. Max 100 per batch.
    function checkInBatch(address[] calldata attendeesToCheckIn) external;

    /// @notice Cancel the entire event and enable refunds for all
    /// @dev Reverts if not organizer or event already started
    function cancelEvent() external;

    /// @notice Update the metadata URI
    /// @param newURI New IPFS hash or URL
    /// @dev Reverts if not organizer
    function setMetadataURI(string calldata newURI) external;

    // ============ Public Functions ============

    /// @notice Claim remaining dust after all claims or timeout
    /// @dev Sends dust to project maintainer address from factory
    function claimDust() external;
}
