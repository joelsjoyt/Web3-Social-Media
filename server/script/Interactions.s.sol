// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {SocialMedia} from "../src/SocialMedia.sol";

contract RegisterUser is Script {
    string public userName = "User1";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SocialMedia", block.chainid);
        registerUser(mostRecentDeployment);
    }

    function registerUser(address _socialMediaContractAddress) public {
        /**
         *
         * @param _socialMediaContractAddress The recent deployed address of SocialMedia contract
         */
        vm.startBroadcast();
        SocialMedia(_socialMediaContractAddress).registerUser(userName);
        vm.stopBroadcast();
    }
}

contract MakePost is Script {
    string public postData = "1st Post";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SocialMedia", block.chainid);
        createPost(mostRecentDeployment);
    }

    function createPost(address _socialMediaContractAddress) public {
        /**
         *
         * @param _socialMediaContractAddress The recent deployed address of SocialMedia contract
         */
        vm.startBroadcast();
        SocialMedia(_socialMediaContractAddress).createPost(postData);
        vm.stopBroadcast();
    }
}

contract MakeComment is Script {
    string public commentData = "1st Comment";

    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SocialMedia", block.chainid);
        createComment(mostRecentDeployment);
    }

    function createComment(address _socialMediaContractAddress) public {
        /**
         *
         * @param _socialMediaContractAddress The recent deployed address of SocialMedia contract
         */
        vm.startBroadcast();
        SocialMedia(_socialMediaContractAddress).createComment(0, commentData);
        vm.stopBroadcast();
    }
}

contract LikePost is Script {
    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SocialMedia", block.chainid);
        likePost(mostRecentDeployment);
    }

    function likePost(address _socialMediaContractAddress) public {
        /**
         *
         * @param _socialMediaContractAddress The recent deployed address of SocialMedia contract
         */
        vm.startBroadcast();
        SocialMedia(_socialMediaContractAddress).likePost(0);
        vm.stopBroadcast();
    }
}

contract DislikePost is Script {
    function run() external {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("SocialMedia", block.chainid);
        dislikePost(mostRecentDeployment);
    }

    function dislikePost(address _socialMediaContractAddress) public {
        /**
         *
         * @param _socialMediaContractAddress The recent deployed address of SocialMedia contract
         */
        vm.startBroadcast();
        SocialMedia(_socialMediaContractAddress).dislikePost(0);
        vm.stopBroadcast();
    }
}
