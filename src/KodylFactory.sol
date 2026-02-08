// SPDX-License-Identifier: MIT
pragma solidity ^0.8.33;

import {IKodylFactory} from "./interfaces/IKodylFactory.sol";
import {KodylEvent} from "./KodylEvent.sol";

/// @title KodylFactory
/// @notice Factory contract for creating and tracking KodylEvent instances
/// @dev Uses CREATE2 for deterministic event contract addresses
/// @author Kodyl Protocol
contract KodylFactory is IKodylFactory {
    // ============ Constants ============

    /// @notice Minimum cancellation deadline buffer (2 hours)
    uint256 public constant MIN_CANCELLATION_BUFFER = 2 hours;

    /// @notice Protocol version
    string public constant VERSION = "1.0.0";

    // ============ State Variables ============

    /// @notice Project maintainer address (receives dust from events)
    address public maintainer;

    /// @notice Total number of events created
    uint256 public eventCount;

    /// @notice Array of all event contract addresses
    address[] public events;

    /// @notice Mapping to verify if address is a Kodyl event
    mapping(address => bool) public isKodylEvent;

    // ============ Modifiers ============

    /// @notice Restricts function to maintainer only
    modifier onlyMaintainer() {
        if (msg.sender != maintainer) revert NotAuthorized();
        _;
    }

    // ============ Constructor ============

    /// @notice Initialize factory with maintainer address
    /// @param _maintainer Address of the project maintainer
    constructor(address _maintainer) {
        if (_maintainer == address(0)) revert InvalidEventParameters("Zero address");
        maintainer = _maintainer;
    }

    // ============ External Functions ============

    /// @inheritdoc IKodylFactory
    function createEvent(
        uint256 depositAmount,
        uint256 cancellationDeadline,
        uint256 eventStart,
        uint256 eventEnd,
        uint256 disputePeriod,
        uint256 maxAttendees,
        string calldata metadataURI
    ) external override returns (address eventContract) {
        // ===== Function Requirements (F) =====
        _validateEventParameters(depositAmount, cancellationDeadline, eventStart, eventEnd, disputePeriod);

        // ===== Effects (E) =====
        // Generate salt from event parameters + block data for uniqueness
        bytes32 salt = keccak256(abi.encodePacked(msg.sender, eventStart, block.timestamp, eventCount));

        // ===== Interactions (I) =====
        // Deploy new KodylEvent using CREATE2
        eventContract = address(
            new KodylEvent{salt: salt}(
                address(this),
                msg.sender,
                depositAmount,
                cancellationDeadline,
                eventStart,
                eventEnd,
                disputePeriod,
                maxAttendees,
                metadataURI
            )
        );

        // ===== Effects (E) - State updates =====
        events.push(eventContract);
        isKodylEvent[eventContract] = true;
        unchecked {
            ++eventCount;
        }

        // ===== Protocol Invariants (PI) =====
        // Verify the event was created and tracked correctly
        assert(eventCount == events.length);
        assert(isKodylEvent[eventContract]);

        emit EventCreated(eventContract, msg.sender, depositAmount, eventStart, eventEnd);

        return eventContract;
    }

    /// @inheritdoc IKodylFactory
    function setMaintainer(address newMaintainer) external override onlyMaintainer {
        // ===== Function Requirements (F) =====
        if (newMaintainer == address(0)) revert InvalidEventParameters("Zero address");
        if (newMaintainer == maintainer) revert InvalidEventParameters("Same maintainer");

        // ===== Effects (E) =====
        address oldMaintainer = maintainer;
        maintainer = newMaintainer;

        // ===== Protocol Invariants (PI) =====
        // Verify maintainer was updated
        assert(maintainer == newMaintainer);

        emit MaintainerUpdated(oldMaintainer, newMaintainer);
    }

    // ============ View Functions ============

    /// @notice Get all event addresses
    /// @return Array of all deployed KodylEvent contract addresses
    function getAllEvents() external view returns (address[] memory) {
        return events;
    }

    // ============ Internal Functions ============

    /// @dev Validates all event parameters according to protocol rules
    /// @param depositAmount Required deposit in wei
    /// @param cancellationDeadline Timestamp for cancellation deadline
    /// @param eventStart Event start timestamp
    /// @param eventEnd Event end timestamp
    /// @param disputePeriod Duration after event end for disputes
    function _validateEventParameters(
        uint256 depositAmount,
        uint256 cancellationDeadline,
        uint256 eventStart,
        uint256 eventEnd,
        uint256 disputePeriod
    ) internal view {
        // Deposit must be positive
        if (depositAmount == 0) {
            revert InvalidEventParameters("Deposit must be > 0");
        }

        // Event must start in the future
        if (eventStart <= block.timestamp) {
            revert InvalidEventParameters("Event must start in future");
        }

        // Event end must be after start
        if (eventEnd <= eventStart) {
            revert InvalidEventParameters("Event end must be after start");
        }

        // Cancellation deadline must be at least 2 hours before event
        if (cancellationDeadline < eventStart - MIN_CANCELLATION_BUFFER) {
            revert InvalidEventParameters("Cancellation deadline too late");
        }

        // Cancellation deadline must not be in the past
        if (cancellationDeadline <= block.timestamp) {
            revert InvalidEventParameters("Cancellation deadline must be in future");
        }

        // Dispute period must be reasonable (at least 1 hour, max 30 days)
        if (disputePeriod < 1 hours) {
            revert InvalidEventParameters("Dispute period too short");
        }
        if (disputePeriod > 30 days) {
            revert InvalidEventParameters("Dispute period too long");
        }
    }
}
