// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SocialMedia {
    //**Custom Errors */
    error SocialMedia__UserAuthorisationFailed();
    error SocialMedia__UserAlreadyExists();
    error SocialMedia__PostIdDoesNotExist();
    error SocialMedia__NotEnoughETHToSend();

    enum PostType {
        POST,
        COMMENT
    }

    //**State Variables */
    uint256 private s_userId;
    uint256 private s_postId;

    struct UserDetails {
        string userName;
        address userAddress;
        uint256 joinedOn;
    }

    struct PostData {
        uint256 postId;
        string postData;
        uint256 likes;
        uint256 disLikes;
        address postAuthorAddress;
        uint256 createdOn;
        PostType postType;
    }

    mapping(address user => UserDetails userData) private s_users;
    mapping(uint256 postId => PostData posts) private s_posts;
    mapping(address user => PostData[] posts) private s_userPosts;
    mapping(uint256 postId => PostData[] comments) private s_comments;

    //**Events */
    event UserCreated(address indexed user);
    event PostCreated(address indexed user, uint256 indexed postId);
    event PostLiked(uint256 indexed postId, address indexed user);
    event PostDisliked(uint256 indexed postId, address indexed user);
    event CommentCreated(uint256 indexed postId, uint256 indexed commentId, address indexed user);

    modifier isRegisteredUser() {
        if (s_users[msg.sender].userAddress == address(0)) {
            revert SocialMedia__UserAuthorisationFailed();
        }
        _;
    }

    modifier isPostExists(uint256 postId) {
        if (s_posts[postId].postId != postId) {
            revert SocialMedia__PostIdDoesNotExist();
        }
        _;
    }

    modifier isUserExist() {
        if (s_users[msg.sender].userAddress != address(0)) {
            revert SocialMedia__UserAlreadyExists();
        }
        _;
    }

    function registerUser(string memory userName) external isUserExist {
        UserDetails memory newUser = UserDetails(userName, msg.sender, block.timestamp);
        s_users[msg.sender] = newUser;

        emit UserCreated(msg.sender);
    }

    function createPost(string memory postData) external isRegisteredUser {
        /**
         *
         * @param commentData This function expects postData to be in a base64 encoded string format.
         */
        PostData memory newPost = PostData(s_postId, postData, 0, 0, msg.sender, block.timestamp, PostType.POST);

        s_posts[s_postId] = newPost;
        s_userPosts[msg.sender].push(newPost);
        s_postId++;

        emit PostCreated(msg.sender, s_postId);
    }

    function createComment(uint256 postId, string memory commentData) external isRegisteredUser isPostExists(postId) {
        /**
         *
         * @param postId This function expects commentData to be in a base64 encoded string format.
         */
        PostData memory newPost = PostData(s_postId, commentData, 0, 0, msg.sender, block.timestamp, PostType.COMMENT);

        s_posts[s_postId] = newPost;
        s_comments[postId].push(newPost);
        s_userPosts[msg.sender].push(newPost);
        s_postId++;

        emit CommentCreated(postId, s_postId, msg.sender);
    }

    function likePost(uint256 postId) external isRegisteredUser isPostExists(postId) {
        s_posts[postId].likes++;

        emit PostLiked(postId, msg.sender);
    }

    function dislikePost(uint256 postId) external isRegisteredUser isPostExists(postId) {
        s_posts[postId].disLikes++;

        emit PostDisliked(postId, msg.sender);
    }

    //**Getter Functions */

    function getPost(uint256 postId) external view returns (PostData memory retrivedPost) {
        retrivedPost = s_posts[postId];
    }

    function getPostAndComments(uint256 postId)
        external
        view
        returns (PostData memory retrivedPost, PostData[] memory retrivedComments)
    {
        retrivedPost = s_posts[postId];
        retrivedComments = s_comments[postId];
    }

    function getUser(address userAddress) external view returns (UserDetails memory retrivedUserDetails) {
        retrivedUserDetails = s_users[userAddress];
    }

    function getPostsFromUser() external view isRegisteredUser returns (PostData[] memory retrivedUserPosts) {
        retrivedUserPosts = s_userPosts[msg.sender];
    }

    function getComments(uint256 postId) external view returns (PostData[] memory comments) {
        comments = s_comments[postId];
    }

    function getPostCount() external view returns (uint256 count) {
        count = s_postId;
    }
}
