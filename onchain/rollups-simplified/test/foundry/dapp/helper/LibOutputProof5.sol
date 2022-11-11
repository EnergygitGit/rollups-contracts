// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

// THIS FILE WAS AUTOMATICALLY GENERATED BY `genProofLibraries.ts`.

import {OutputValidityProof} from "contracts/library/LibOutputValidation.sol";

library LibOutputProof5 {
    function getOutputProof() internal pure returns (OutputValidityProof memory) {
        uint256[16] memory array1 = [0xae39ce8537aca75e2eff3e38c98011dfe934e700a0967732fc07b430dd656a23,0x3fc9a15f5b4869c872f81087bb6104b7d63e6f9ab47f2c43f3535eae7172aa7f,0x17d2dd614cddaa4d879276b11e0672c9560033d3e8453a1d045339d34ba601b9,0xc37b8b13ca95166fb7af16988a70fcc90f38bf9126fd833da710a47fb37a55e6,0x8e7a427fa943d9966b389f4f257173676090c6e95f43e2cb6d65f8758111e309,0x30b0b9deb73e155c59740bacf14a6ff04b64bb8e201a506409c3fe381ca4ea90,0xcd5deac729d0fdaccc441d09d7325f41586ba13c801b7eccae0f95d8f3933efe,0xd8b96e5b7f6f459e9cb6a2f41bf276c7b85c10cd4662c04cbbb365434726c0a0,0xc9695393027fb106a8153109ac516288a88b28a93817899460d6310b71cf1e61,0x63e8806fa0d4b197a259e8c3ac28864268159d0ac85f8581ca28fa7d2c0c03eb,0x91e3eee5ca7a3da2b3053c9770db73599fb149f620e3facef95e947c0ee860b7,0x2122e31e4bbd2b7c783d79cc30f60c6238651da7f0726f767d22747264fdb046,0xf7549f26cc70ed5e18baeb6c81bb0625cb95bb4019aeecd40774ee87ae29ec51,0x7a71f6ee264c5d761379b3d7d617ca83677374b49d10aec50505ac087408ca89,0x2b573c267a712a52e1d06421fe276a03efb1889f337201110fdc32a81f8e1524,0x99af665835aabfdc6740c7e2c3791a31c3cdc9f5ab962f681b12fc092816a62f];
        uint256[32] memory array2 = [0xcda89c5a86d8f10480bb70816ef258556a6a8e34e726dde963f7d3d0c5ef4a97,0x1bd963fe9e890d189f7e712fccab77340ac2a92606eda2a373d19059e55a1328,0x1a15d9ebaef9c9bc1e0ad0da6abb3562852f39caf76d60f0dff08e67b2d83047,0x3b8ec09e026fdc305365dfc94e189a81b38c7597b3d941c279f042e8206e0bd8,0xecd50eee38e386bd62be9bedb990706951b65fe053bd9d8a521af753d139e2da,0xdefff6d330bb5403f63b14f33b578274160de3a50df4efecf0e0db73bcdd3da5,0x617bdd11f7c0a11f49db22f629387a12da7596f9d1704d7465177c63d88ec7d7,0x292c23a9aa1d8bea7e2435e555a4a60e379a5a35f3f452bae60121073fb6eead,0xe1cea92ed99acdcb045a6726b2f87107e8a61620a232cf4d7d5b5766b3952e10,0x7ad66c0a68c72cb89e4fb4303841966e4062a76ab97451e3b9fb526a5ceb7f82,0xe026cc5a4aed3c22a58cbd3d2ac754c9352c5436f638042dca99034e83636516,0x3d04cffd8b46a874edf5cfae63077de85f849a660426697b06a829c70dd1409c,0xad676aa337a485e4728a0b240d92b3ef7b3c372d06d189322bfd5f61f1e7203e,0xa2fca4a49658f9fab7aa63289c91b7c7b6c832a6d0e69334ff5b0a3483d09dab,0x4ebfd9cd7bca2505f7bef59cc1c12ecc708fff26ae4af19abe852afe9e20c862,0x2def10d13dd169f550f578bda343d9717a138562e0093b380a1120789d53cf10,0x776a31db34a1a0a7caaf862cffdfff1789297ffadc380bd3d39281d340abd3ad,0xe2e7610b87a5fdf3a72ebe271287d923ab990eefac64b6e59d79f8b7e08c46e3,0x504364a5c6858bf98fff714ab5be9de19ed31a976860efbd0e772a2efe23e2e0,0x4f05f4acb83f5b65168d9fef89d56d4d77b8944015e6b1eed81b0238e2d0dba3,0x44a6d974c75b07423e1d6d33f481916fdd45830aea11b6347e700cd8b9f0767c,0xedf260291f734ddac396a956127dde4c34c0cfb8d8052f88ac139658ccf2d507,0x6075c657a105351e7f0fce53bc320113324a522e8fd52dc878c762551e01a46e,0x6ca6a3f763a9395f7da16014725ca7ee17e4815c0ff8119bf33f273dee11833b,0x1c25ef10ffeb3c7d08aa707d17286e0b0d3cbcb50f1bd3b6523b63ba3b52dd0f,0xfffc43bd08273ccf135fd3cacbeef055418e09eb728d727c4d5d5c556cdea7e3,0xc5ab8111456b1f28f3c7a0a604b4553ce905cb019c463ee159137af83c350b22,0x0ff273fcbf4ae0f2bd88d6cf319ff4004f8d7dca70d4ced4e74d2c74139739e6,0x7fa06ba11241ddd5efdc65d4e39c9f6991b74fd4b81b62230808216c876f827c,0x7e275adf313a996c7e2950cac67caba02a5ff925ebf9906b58949f3e77aec5b9,0x8f6162fa308d2b3a15dc33cffac85f13ab349173121645aedf00f471663108be,0x78ccaaab73373552f207a63599de54d7d8d0c1805f86ce7da15818d09f4cff62];
        bytes32[] memory keccakInHashesSiblings = new bytes32[](16);
        bytes32[] memory outputHashesInEpochSiblings = new bytes32[](32);
        for (uint256 i; i < 16; ++i) { keccakInHashesSiblings[i] = bytes32(array1[i]); }
        for (uint256 i; i < 32; ++i) { outputHashesInEpochSiblings[i] = bytes32(array2[i]); }
        return OutputValidityProof({
            outputIndex: 0,
            outputHashesRootHash: 0xf18d1c6013069d7bf91e3c5d73790480963c763e8c90ba01c11694a2d1df2def,
            outputsEpochRootHash: 0x2a125354b0804c67d8df3ecb4983381681890b3de568f158cc33b1c7373a5cce,
            machineStateHash: 0x06a466db7d69b4d7a7cc90855257fc6faf58394b9e46b80abb37492012dcbd40,
            keccakInHashesSiblings: keccakInHashesSiblings,
            outputHashesInEpochSiblings: outputHashesInEpochSiblings
        });
    }
}