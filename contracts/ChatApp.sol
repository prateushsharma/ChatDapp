// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract ChatApp {
    struct Friend {
        address pubkey;
        string name;
    }

    struct Message {
        address sender;
        uint256 timestamp;
        string msg;
    }

    struct AllUserStruck {
        string name;
        address accountAddress;
    }

    struct User {
        string name;
        Friend[] friendList;
    }

    AllUserStruck[] public getAllUsers;
    mapping(address => User) public userList;
    mapping(bytes32 => Message[]) public allMessages;

    // CHECK USER
    function checkUserExists(address pubkey) public view returns (bool) {
        return bytes(userList[pubkey].name).length > 0;
    }

    // CREATE ACCOUNT
    function createAccount(string calldata name) external {
        require(!checkUserExists(msg.sender), "User already exists");
        require(bytes(name).length > 0, "Username cannot be empty");

        userList[msg.sender].name = name;
        getAllUsers.push(AllUserStruck(name, msg.sender));
    }

    // GET USERNAME
    function getUsername(address pubkey) external view returns (string memory) {
        require(checkUserExists(pubkey), "User is not registered");
        return userList[pubkey].name;
    }

    // ADD FRIENDS
    function addFriends(address friend_key, string calldata name) external {
        require(checkUserExists(msg.sender), "Create an account first");
        require(checkUserExists(friend_key), "User is not registered");
        require(msg.sender != friend_key, "Users cannot add themselves as friends");
        require(!checkAlreadyFriends(msg.sender, friend_key), "These users are already friends");

        _addFriend(msg.sender, friend_key, name);
        _addFriend(friend_key, msg.sender, userList[msg.sender].name);
    }

    function checkAlreadyFriends(address pubkey1, address pubkey2) internal view returns (bool) {
        if (userList[pubkey1].friendList.length > userList[pubkey2].friendList.length) {
            address tmp = pubkey1;
            pubkey1 = pubkey2;
            pubkey2 = tmp;
        }
        for (uint256 i = 0; i < userList[pubkey1].friendList.length; i++) {
            if (userList[pubkey1].friendList[i].pubkey == pubkey2) return true;
        }
        return false;
    }

    function _addFriend(address me, address friend_key, string memory name) internal {
        Friend memory newFriend = Friend(friend_key, name);
        userList[me].friendList.push(newFriend);
    }

    // GET MY FRIEND
    function getMyFriend() external view returns (Friend[] memory) {
        return userList[msg.sender].friendList;
    }

    // GET CHAT CODE
    function _getChatCode(address pubkey1, address pubkey2) internal pure returns (bytes32) {
        return pubkey1 < pubkey2 ? keccak256(abi.encodePacked(pubkey1, pubkey2)) : keccak256(abi.encodePacked(pubkey2, pubkey1));
    }

    // SEND MESSAGE
    function sendMessage(address friend_key, string calldata _msg) external {
        require(checkUserExists(msg.sender), "Create an account first");
        require(checkUserExists(friend_key), "User is not registered");
        require(checkAlreadyFriends(msg.sender, friend_key), "You are not friends with the given user");
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        Message memory newMsg = Message(msg.sender, block.timestamp, _msg);
        allMessages[chatCode].push(newMsg);
    }

    function readMessage(address friend_key) external view returns (Message[] memory) {
        bytes32 chatCode = _getChatCode(msg.sender, friend_key);
        return allMessages[chatCode];
    }

    function getAllAppUser() public view returns (AllUserStruck[] memory) {
        return getAllUsers;
    }
}
