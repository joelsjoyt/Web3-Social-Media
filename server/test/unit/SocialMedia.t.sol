// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {DeploySocialMedia} from "../../script/DeploySocialMedia.s.sol";
import {SocialMedia} from "../../src/SocialMedia.sol";

contract SocialMediaTests is Test {
    DeploySocialMedia public deployer;
    SocialMedia public socialMedia;
    SocialMedia.UserDetails public user;

    address USER1 = makeAddr("USER_1");
    address USER2 = makeAddr("USER_2");
    bytes public constant USERNAME = abi.encodePacked("USER_1");
    bytes public constant USERNAME2 = abi.encodePacked("USER_2");
    bytes public constant POST1 = abi.encodePacked("1st Post");
    bytes public constant POST2 = abi.encodePacked("2nd Post");
    bytes public constant COMMENT1 = abi.encodePacked("1st Comment");

    function setUp() public {
        deployer = new DeploySocialMedia();
        socialMedia = deployer.run();
    }

    function testUserCanRegister() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        assertEq(keccak256(abi.encodePacked(socialMedia.getUser(USER1).userName)), keccak256(USERNAME));
    }

    function testDoubleRegistrationNotPossible() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.expectRevert(SocialMedia.SocialMedia__UserAlreadyExists.selector);
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
    }

    function testCreatePost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        assertEq(keccak256(abi.encodePacked(socialMedia.getPost(0).postData)), keccak256(POST1));
    }

    function testOnlyRegisteredUserCanCreatePost() public {
        vm.prank(USER1);
        vm.expectRevert(SocialMedia.SocialMedia__UserAuthorisationFailed.selector);
        socialMedia.createPost(string(POST1));
    }

    function testCreateComment() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.prank(USER1);
        socialMedia.createComment(0, string(COMMENT1));
        assertEq(keccak256(abi.encodePacked(socialMedia.getComments(0)[0].postData)), keccak256(COMMENT1));
    }

    function testCommentCannotBeCreatedWithoutRegistering() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.expectRevert(SocialMedia.SocialMedia__UserAuthorisationFailed.selector);
        vm.prank(USER2);
        socialMedia.createComment(0, string(COMMENT1));
    }

    function testCommentCannotBeCreatedWithoutAnExistingPost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.expectRevert(SocialMedia.SocialMedia__PostIdDoesNotExist.selector);
        vm.prank(USER1);
        socialMedia.createComment(0, string(COMMENT1));
    }

    function testLikePost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.prank(USER1);
        socialMedia.likePost(0);
        assertEq(socialMedia.getPost(0).likes, 1);
    }

    function testPostCannotBeLikedWithoutRegistering() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.expectRevert(SocialMedia.SocialMedia__UserAuthorisationFailed.selector);
        vm.prank(USER2);
        socialMedia.likePost(0);
    }

    function testPostCannotBeLikedWithoutAnExistingPost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.expectRevert(SocialMedia.SocialMedia__PostIdDoesNotExist.selector);
        vm.prank(USER1);
        socialMedia.likePost(0);
    }

    function testDislikePost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.prank(USER1);
        socialMedia.dislikePost(0);
        assertEq(socialMedia.getPost(0).disLikes, 1);
    }

    function testPostCannotBeDislikedWithoutRegistering() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.expectRevert(SocialMedia.SocialMedia__UserAuthorisationFailed.selector);
        vm.prank(USER2);
        socialMedia.dislikePost(0);
    }

    function testPostCannotBeDislikedWithoutAnExistingPost() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.expectRevert(SocialMedia.SocialMedia__PostIdDoesNotExist.selector);
        vm.prank(USER1);
        socialMedia.dislikePost(0);
    }

    function testCanRetriveUserDetails() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.prank(USER1);
        socialMedia.getUserPosts();
        vm.prank(USER1);
        assertEq(keccak256(abi.encodePacked(socialMedia.getUserPosts()[0].postData)), keccak256(POST1));
    }

    function testMoreThanOneUserCanCreatePosts() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));

        vm.prank(USER2);
        socialMedia.registerUser(string(USERNAME2));
        vm.prank(USER2);
        socialMedia.createPost(string(POST2));
        vm.prank(USER2);

        assertEq(keccak256(abi.encodePacked(socialMedia.getPost(1).postData)), keccak256(POST2));
    }

    function testPostCount() public {
        vm.prank(USER1);
        socialMedia.registerUser(string(USERNAME));
        vm.prank(USER1);
        socialMedia.createPost(string(POST1));
        vm.prank(USER1);
        socialMedia.createPost(string(POST2));

        assertEq(socialMedia.getPostCount(), 2);
    }

    // Write tests for events?
}
