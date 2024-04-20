// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {DeploySocialMedia} from "../../script/DeploySocialMedia.s.sol";
import {SocialMedia} from "../../src/SocialMedia.sol";
import {RegisterUser, MakePost, MakeComment, LikePost, DislikePost} from "../../script/Interactions.s.sol";

contract SocialMediaTests is Test {
    SocialMedia socialMedia;
    address USER1 = makeAddr("USER1");
    address USER2 = makeAddr("USER2");

    function setUp() public {
        DeploySocialMedia deployer = new DeploySocialMedia();
        socialMedia = deployer.run();
    }

    function testUserCanRegisterAndCreatePost() public {
        RegisterUser registerUser = new RegisterUser();
        registerUser.registerUser(address(socialMedia));

        MakePost makePost = new MakePost();
        makePost.createPost(address(socialMedia));
    }

    function testUserCanCommentOnPosts() public {
        testUserCanRegisterAndCreatePost();

        MakeComment createComment = new MakeComment();
        createComment.createComment(address(socialMedia));
    }

    function testUserCanLikeAndDislikePost() public {
        testUserCanRegisterAndCreatePost();

        LikePost likePost = new LikePost();
        likePost.likePost(address(socialMedia));

        DislikePost dislikePost = new DislikePost();
        dislikePost.dislikePost(address(socialMedia));
    }
}
