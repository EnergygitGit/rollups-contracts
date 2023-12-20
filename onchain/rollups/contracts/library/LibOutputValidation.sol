// (c) Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

pragma solidity ^0.8.8;

import {CanonicalMachine} from "../common/CanonicalMachine.sol";
import {MerkleV2} from "@cartesi/util/contracts/MerkleV2.sol";
import {OutputEncoding} from "../common/OutputEncoding.sol";
import {OutputValidityProof} from "../common/OutputValidityProof.sol";

/// @title Output Validation Library
library LibOutputValidation {
    using CanonicalMachine for CanonicalMachine.Log2Size;

    /// @notice Raised when some `OutputValidityProof` variables does not match
    ///         the presented finalized epoch.
    error IncorrectEpochHash();

    /// @notice Raised when `OutputValidityProof` metadata memory range is NOT
    ///         contained in epoch's output memory range.
    error IncorrectOutputsEpochRootHash();

    /// @notice Raised when Merkle root of output hash is NOT contained
    ///         in the output metadata array memory range.
    error IncorrectOutputHashesRootHash();

    /// @notice Raised when epoch input index is NOT compatible with the
    ///         provided input index range.
    error InputIndexOutOfClaimBounds();

    /// @notice Make sure the output proof is valid, otherwise revert.
    /// @param v The output validity proof
    /// @param encodedOutput The encoded output
    /// @param epochHash The hash of the epoch in which the output was generated
    /// @param outputsEpochRootHash Either `v.vouchersEpochRootHash` (for vouchers)
    ///                             or `v.noticesEpochRootHash` (for notices)
    /// @param outputEpochLog2Size Either `EPOCH_VOUCHER_LOG2_SIZE` (for vouchers)
    ///                            or `EPOCH_NOTICE_LOG2_SIZE` (for notices)
    /// @param outputHashesLog2Size Either `VOUCHER_METADATA_LOG2_SIZE` (for vouchers)
    ///                             or `NOTICE_METADATA_LOG2_SIZE` (for notices)
    function validateEncodedOutput(
        OutputValidityProof calldata v,
        bytes memory encodedOutput,
        bytes32 epochHash,
        bytes32 outputsEpochRootHash,
        uint256 outputEpochLog2Size,
        uint256 outputHashesLog2Size
    ) internal pure {
        // prove that outputs hash is represented in a finalized epoch
        if (
            keccak256(
                abi.encodePacked(
                    v.vouchersEpochRootHash,
                    v.noticesEpochRootHash,
                    v.machineStateHash
                )
            ) != epochHash
        ) {
            revert IncorrectEpochHash();
        }

        // prove that output metadata memory range is contained in epoch's output memory range
        if (
            MerkleV2.getRootAfterReplacementInDrive(
                CanonicalMachine.getIntraMemoryRangePosition(
                    v.inputIndexWithinEpoch,
                    CanonicalMachine.KECCAK_LOG2_SIZE
                ),
                CanonicalMachine.KECCAK_LOG2_SIZE.uint64OfSize(),
                outputEpochLog2Size,
                v.outputHashesRootHash,
                v.outputHashesInEpochSiblings
            ) != outputsEpochRootHash
        ) {
            revert IncorrectOutputsEpochRootHash();
        }

        // The hash of the output is converted to bytes (abi.encode) and
        // treated as data. The metadata output memory range stores that data while
        // being indifferent to its contents. To prove that the received
        // output is contained in the metadata output memory range we need to
        // prove that x, where:
        // x = keccak(
        //          keccak(
        //              keccak(hashOfOutput[0:7]),
        //              keccak(hashOfOutput[8:15])
        //          ),
        //          keccak(
        //              keccak(hashOfOutput[16:23]),
        //              keccak(hashOfOutput[24:31])
        //          )
        //     )
        // is contained in it. We can't simply use hashOfOutput because the
        // log2size of the leaf is three (8 bytes) not  five (32 bytes)
        bytes32 merkleRootOfHashOfOutput = MerkleV2.getMerkleRootFromBytes(
            abi.encodePacked(keccak256(encodedOutput)),
            CanonicalMachine.KECCAK_LOG2_SIZE.uint64OfSize()
        );

        // prove that Merkle root of bytes(hashOfOutput) is contained
        // in the output metadata array memory range
        if (
            MerkleV2.getRootAfterReplacementInDrive(
                CanonicalMachine.getIntraMemoryRangePosition(
                    v.outputIndexWithinInput,
                    CanonicalMachine.KECCAK_LOG2_SIZE
                ),
                CanonicalMachine.KECCAK_LOG2_SIZE.uint64OfSize(),
                outputHashesLog2Size,
                merkleRootOfHashOfOutput,
                v.outputHashInOutputHashesSiblings
            ) != v.outputHashesRootHash
        ) {
            revert IncorrectOutputHashesRootHash();
        }
    }

    /// @notice Make sure the output proof is valid, otherwise revert.
    /// @param v The output validity proof
    /// @param destination The address that will receive the payload through a message call
    /// @param payload The payload, which—in the case of Solidity contracts—encodes a function call
    /// @param epochHash The hash of the epoch in which the output was generated
    function validateVoucher(
        OutputValidityProof calldata v,
        address destination,
        bytes calldata payload,
        bytes32 epochHash
    ) internal pure {
        bytes memory encodedVoucher = OutputEncoding.encodeVoucher(
            destination,
            payload
        );
        validateEncodedOutput(
            v,
            encodedVoucher,
            epochHash,
            v.vouchersEpochRootHash,
            CanonicalMachine.EPOCH_VOUCHER_LOG2_SIZE.uint64OfSize(),
            CanonicalMachine.VOUCHER_METADATA_LOG2_SIZE.uint64OfSize()
        );
    }

    /// @notice Make sure the output proof is valid, otherwise revert.
    /// @param v The output validity proof
    /// @param notice The notice
    /// @param epochHash The hash of the epoch in which the output was generated
    function validateNotice(
        OutputValidityProof calldata v,
        bytes calldata notice,
        bytes32 epochHash
    ) internal pure {
        bytes memory encodedNotice = OutputEncoding.encodeNotice(notice);
        validateEncodedOutput(
            v,
            encodedNotice,
            epochHash,
            v.noticesEpochRootHash,
            CanonicalMachine.EPOCH_NOTICE_LOG2_SIZE.uint64OfSize(),
            CanonicalMachine.NOTICE_METADATA_LOG2_SIZE.uint64OfSize()
        );
    }

    /// @notice Validate input index range and get the input index.
    /// @param v The output validity proof
    /// @param firstInputIndex The index of the first input of the epoch in the input box
    /// @param lastInputIndex The index of the last input of the epoch in the input box
    /// @return The index of the input in the application's input box
    /// @dev Reverts if epoch input index is not compatible with the provided input index range.
    function validateInputIndexRange(
        OutputValidityProof calldata v,
        uint256 firstInputIndex,
        uint256 lastInputIndex
    ) internal pure returns (uint256) {
        uint256 inputIndex = firstInputIndex + v.inputIndexWithinEpoch;

        if (inputIndex > lastInputIndex) {
            revert InputIndexOutOfClaimBounds();
        }

        return inputIndex;
    }
}
