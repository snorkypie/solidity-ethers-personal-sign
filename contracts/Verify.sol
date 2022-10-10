// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Verify {
    constructor() {}

    function verify(string memory message, bytes memory sig)
        public
        pure
        returns (address)
    {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";

        bytes32 prefixedHashMessage = keccak256(
            abi.encodePacked(prefix, keccak256(abi.encodePacked(message)))
        );

        (bytes32 r, bytes32 s, uint8 v) = splitSignature(sig);

        return ecrecover(prefixedHashMessage, v, r, s);
    }

    function splitSignature(bytes memory sig)
        internal
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65);

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
