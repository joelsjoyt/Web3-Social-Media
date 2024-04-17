// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {SocialMedia} from "../src/SocialMedia.sol";

contract DeploySocialMedia is Script {
    SocialMedia public socialMedia;

    function run() public returns (SocialMedia) {
        vm.startBroadcast();
        socialMedia = new SocialMedia();
        vm.stopBroadcast();

        return socialMedia;
    }
}
