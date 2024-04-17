// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test} from "forge-std/Test.sol";
import {DeploySocialMedia} from "../../script/DeploySocialMedia.s.sol";
import {SocialMedia} from "../../src/SocialMedia.sol";

contract DeploySocialMediaTest is Test {
    DeploySocialMedia public deployer;
    SocialMedia public socialMedia;

    address public USER1 = makeAddr("USER_1");
    address public USER2 = makeAddr("USER_2");

    function setUp() public {
        deployer = new DeploySocialMedia();
        socialMedia = deployer.run();
    }

    function testUserCanRegister() public {
        vm.prank(USER1);
    }

    function testDoubleRegistrationNotPossible() public {}

    function testCreatePost() public {}

    function testOnllyRegisteredUserCanCreatePost() public {}

    function testCreateComment() public {}

    function testCommentCannotBeCreatedWithoutRegistering() public {}

    function testCommentCannotBeCreatedWithoutAnExistingPost() public {}

    function testLikePost() public {}

    function testPostCannotBeLikedWithoutRegistering() public {}

    function testPostCannotBeLikedWithoutAnExistingPost() public {}

    function testDislikePost() public {}

    function testPostCannotBeDislikedWithoutRegistering() public {}

    function testPostCannotBeDislikedWithoutAnExistingPost() public {}

    function testPostCanBeRetrived() public {}

    function testCommentCanBeRetrived() public {}

    function testPostAndItsCommentsCanBeRetrived() public {}

    function testCanRetrivePostFromAUser() public {}

    //function testPostCannotBeRetrivedFromAUser Change this in core contract
    //Create a function so other users can retrive posts from another user

    function testUserDetailsCanBeRetrived() public {}
}
