// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC721Base.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract OnChainThirdweb is ERC721Base {

      constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    )
        ERC721Base(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps
        )
    {}

    string[] private blockchains = ['Ethereum', 'Solana', 'Arbitrum', 'Fantom', 'Polygon', 'Bitcoin'];
    string[] private dapps = ['Aave', 'Orca', 'Uniswap', 'MakerDAO', 'Magic Eden'];
    string[] private tokens = ["$ETH", "$SOL", "$BTC", "$AVAX"];
    
    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory){
        uint256 rand = random(string(abi.encodePacked(keyPrefix, toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory){
        string[8] memory parts;

        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="#f904ab" /><text x="10" y="20" class="base">';

        parts[1] = getBlockchain(tokenId);

        parts[2] = '</text><text x="10" y="40" class="base">';

        parts[3] = getDapp(tokenId);

        parts[4] = '</text><text x="10" y="60" class="base">';

        parts[6] = getToken(tokenId);

        parts[7] = '</text></svg>';

        string memory output = 
            string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4], parts[5], parts[6], parts[7]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Web3 Card: ', toString(tokenId), '", "description": "OnChain NFTs created with Thirdweb!", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));
        
        return output;
    }

    function toString(uint256 value) internal pure returns (string memory) {
    // Inspired by OraclizeAPI's implementation - MIT license
    // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
    
    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
    
    function getBlockchain(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Blockchains", blockchains);
    }

    function getDapp(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Dapps", dapps);
    }

    function getToken(uint256 tokenId) public view returns (string memory){
        return pluck(tokenId, "Tokens", tokens);
    }

    function claim(uint256 _amount) public {
        require(_amount > 0 && _amount < 6);
        _safeMint(msg.sender, _amount);
    }
}