// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

/// @notice Complete external interface of the Core Solidity `Kodyl` contract:
///         functions, events, and errors. The `sol-core` compiler emits an ABI
///         for the functions only (events and errors are hand-rolled logs and
///         selectors it cannot see), so this hand-authored interface is the
///         source for a complete ABI - run `forge inspect` on it. The behavior
///         of every signature here is verified by the test suites; this is the
///         ABI mirror of that tested surface.
interface KodylAbi {
    // ---- events (hand-rolled via log opcodes in Kodyl.solc) ----
    event EventCreated(
        uint256 indexed eventId, address indexed organizer, uint256 depositAmount, uint256 eventStart, uint256 eventEnd
    );
    event Registered(uint256 indexed eventId, address indexed attendee);
    event RegistrationCancelled(uint256 indexed eventId, address indexed attendee);
    event CheckedIn(uint256 indexed eventId, address indexed attendee);
    event Claimed(uint256 indexed eventId, address indexed attendee, uint256 amount);
    event RefundClaimed(uint256 indexed eventId, address indexed attendee, uint256 amount);
    event EventCancelled(uint256 indexed eventId);
    event MetadataUpdated(uint256 indexed eventId, string newURI);
    event DustClaimed(uint256 indexed eventId, address indexed recipient, uint256 amount);
    event MaintainerUpdated(address indexed oldMaintainer, address indexed newMaintainer);

    // ---- errors (hand-rolled selectors via keccakLit in Kodyl.solc) ----
    error EventNotFound();
    error RegistrationClosed();
    error AlreadyRegistered();
    error IncorrectDeposit(uint256 expected, uint256 received);
    error EventFull();
    error CancellationDeadlinePassed();
    error InvalidAttendeeStatus(uint8 current, uint8 expected);
    error CheckInWindowClosed();
    error NotSettled();
    error EventAlreadyStarted();
    error BatchTooLarge(uint256 size, uint256 max);
    error TransferFailed();
    error EventNotCancelled();
    error NotOrganizer();
    error NotAuthorized();
    error DustNotClaimable();
    error PayoutSwept();
    error InvalidEventParameters(string reason);

    // ---- errors (std dispatcher / decoder, not declared in Kodyl.solc) ----
    /// @dev Value sent to a non-payable public function. Originates in the std
    ///      dispatcher's non-payable callvalue check; the name is chosen so its
    ///      canonical selector keccak("NonPayableReceivedValue()") equals the
    ///      std's 0xb5988ea3, making the revert decodable from this ABI.
    error NonPayableReceivedValue();
    /// @dev An address parameter word with nonzero upper 96 bits. Raised by the
    ///      std's strict ABI decoding of address parameters on every typed
    ///      path, and the hand-decoded checkInBatch enforces the same check.
    ///      Selector 0x7cc04fa7.
    error DirtyHigherBitsForAddress();

    // ---- write functions ----
    /// @return eventId the sequential id assigned to the new event
    function createEvent(
        uint256 depositAmount,
        uint256 cancellationDeadline,
        uint256 eventStart,
        uint256 eventEnd,
        uint256 disputePeriod,
        uint256 maxAttendees,
        string calldata metadataURI
    ) external returns (uint256 eventId);
    function register(uint256 eid) external payable;
    function cancel(uint256 eid) external;
    function claimRefund(uint256 eid) external;
    function claim(uint256 eid) external;
    function checkIn(uint256 eid, address attendee) external;
    /// @dev Fallback-dispatched in the contract, but a standard call from a client.
    function checkInBatch(uint256 eid, address[] calldata attendees) external;
    function cancelEvent(uint256 eid) external;
    function setMetadataURI(uint256 eid, string calldata uri) external;
    function claimDust(uint256 eid) external;
    function setMaintainer(address newMaintainer) external;

    // ---- read functions ----
    function maintainer() external view returns (address);
    function eventCount() external view returns (uint256);
    function totalHeld() external view returns (uint256);
    /// @return organizer, depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod, maxAttendees
    function getEvent(uint256 eid)
        external
        view
        returns (address, uint256, uint256, uint256, uint256, uint256, uint256);
    function organizer(uint256 eid) external view returns (address);
    /// @return state ordinal: 0 Registration, 1 Active, 2 Dispute, 3 Settled, 4 Cancelled
    function getState(uint256 eid) external view returns (uint256);
    /// @return status ordinal: 0 None, 1 Registered, 2 Cancelled, 3 CheckedIn, 4 Claimed
    function attendees(uint256 eid, address attendee) external view returns (uint256);
    function metadataURI(uint256 eid) external view returns (string memory);
    function cancelled(uint256 eid) external view returns (bool);
    function registeredCount(uint256 eid) external view returns (uint256);
    function checkedInCount(uint256 eid) external view returns (uint256);
    function claimedCount(uint256 eid) external view returns (uint256);
    function held(uint256 eid) external view returns (uint256);
    function rewardPerAttendee(uint256 eid) external view returns (uint256);
    function MAX_BATCH_SIZE() external view returns (uint256);
    function DUST_CLAIM_TIMEOUT() external view returns (uint256);
    function MIN_CANCELLATION_BUFFER() external view returns (uint256);
}
