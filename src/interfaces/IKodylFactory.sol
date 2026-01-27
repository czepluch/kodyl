// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

/// @title IKodylFactory
/// @notice Interface for the Kodyl factory contract
/// @dev Deploys and tracks KodylEvent instances
interface IKodylFactory {
    // ============ Events ============

    /// @notice Emitted when a new event is created
    /// @param eventContract Address of the deployed KodylEvent contract
    /// @param organizer Address of the event organizer
    /// @param depositAmount Required deposit in wei
    /// @param eventStart Event start timestamp
    /// @param eventEnd Event end timestamp
    event EventCreated(
        address indexed eventContract,
        address indexed organizer,
        uint256 depositAmount,
        uint256 eventStart,
        uint256 eventEnd
    );

    /// @notice Emitted when the project maintainer address is updated
    /// @param oldMaintainer Previous maintainer address
    /// @param newMaintainer New maintainer address
    event MaintainerUpdated(address indexed oldMaintainer, address indexed newMaintainer);

    // ============ Errors ============

    /// @notice Thrown when event parameters are invalid
    error InvalidEventParameters(string reason);

    /// @notice Thrown when caller is not authorized
    error NotAuthorized();

    // ============ View Functions ============

    /// @notice Returns the project maintainer address (receives dust from events)
    function maintainer() external view returns (address);

    /// @notice Returns the total number of events created
    function eventCount() external view returns (uint256);

    /// @notice Returns the event contract address at the given index
    /// @param index Index in the events array
    function events(uint256 index) external view returns (address);

    /// @notice Checks if an address is a Kodyl event contract
    /// @param eventContract Address to check
    function isKodylEvent(address eventContract) external view returns (bool);

    // ============ Functions ============

    /// @notice Create a new event
    /// @param depositAmount Required deposit in wei
    /// @param cancellationDeadline Timestamp before which cancellation is allowed
    /// @param eventStart Event start timestamp
    /// @param eventEnd Event end timestamp
    /// @param disputePeriod Duration after event end for late check-ins (in seconds)
    /// @param maxAttendees Maximum capacity (0 = unlimited)
    /// @param metadataURI IPFS hash or URL for event details
    /// @return eventContract Address of the deployed KodylEvent contract
    /// @dev Validates parameters:
    ///      - cancellationDeadline >= 2 hours before eventStart
    ///      - eventStart < eventEnd
    ///      - eventStart > block.timestamp
    ///      - depositAmount > 0
    function createEvent(
        uint256 depositAmount,
        uint256 cancellationDeadline,
        uint256 eventStart,
        uint256 eventEnd,
        uint256 disputePeriod,
        uint256 maxAttendees,
        string calldata metadataURI
    ) external returns (address eventContract);

    /// @notice Update the project maintainer address
    /// @param newMaintainer New maintainer address
    /// @dev Only callable by current maintainer
    function setMaintainer(address newMaintainer) external;
}
