// Copyright 2022 Cartesi Pte. Ltd.

// SPDX-License-Identifier: Apache-2.0
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use
// this file except in compliance with the License. You may obtain a copy of the
// License at http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

/// @title Generic ERC721 Portal facet
pragma solidity ^0.8.0;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC721Receiver} from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

import {IERC721Portal} from "../interfaces/IERC721Portal.sol";

import {LibInput} from "../libraries/LibInput.sol";

contract ERC721PortalFacet is IERC721Portal, IERC721Receiver {
    using LibInput for LibInput.DiamondStorage;

    bytes32 constant INPUT_HEADER = keccak256("ERC721_Transfer");

    /// @notice deposit an ERC721 token in the portal and create a token in L2
    /// @param _ERC721 address of the ERC721 contract
    /// @param _tokenId index of token for the provided ERC721 contract
    /// @param _data information to be interpreted by L2
    /// @return hash of input generated by deposit
    function erc721Deposit(
        address _ERC721,
        uint256 _tokenId,
        bytes calldata _data
    ) public override returns (bytes32) {
        LibInput.DiamondStorage storage inputDS = LibInput.diamondStorage();
        IERC721 token = IERC721(_ERC721);

        // transfer reverts on failure
        token.safeTransferFrom(msg.sender, address(this), _tokenId);

        bytes memory input = abi.encode(
            INPUT_HEADER,
            msg.sender,
            _ERC721,
            _tokenId,
            _data
        );

        emit ERC721Deposited(_ERC721, msg.sender, _tokenId, _data);
        return inputDS.addInputFromSender(input, address(this));
    }

    /// @notice withdraw an ERC721 token from the portal
    /// @param _data data with withdrawal information
    /// @dev can only be called by the Rollups contract
    function erc721Withdrawal(bytes calldata _data)
        public
        override
        returns (bool)
    {
        // Delegate calls preserve msg.sender, msg.value and address(this)
        require(msg.sender == address(this), "only itself");

        (address tokenAddr, address payable receiver, uint256 tokenId) = abi
            .decode(_data, (address, address, uint256));

        IERC721 token = IERC721(tokenAddr);

        // transfer reverts on failure
        token.safeTransferFrom(address(this), receiver, tokenId);

        emit ERC721Withdrawn(tokenAddr, receiver, tokenId);
        return true;
    }

    /// @notice Handle the receipt of an NFT
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public pure override returns (bytes4) {
        // always accept NFT transfers to this contract
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
