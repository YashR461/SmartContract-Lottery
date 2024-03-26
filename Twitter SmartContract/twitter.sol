// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract twitterContract{

    //structure of tweet
    struct Tweet {
        uint id;
        address author;
        string content;
        uint createdAt;
    }

    //structure of message
    struct Message {
        uint id;
        string content;
        address from;
        address to;
        uint createdAt;
    }

    mapping(uint => Tweet) public tweets;
    mapping(address => uint[]) public tweetsOf;
    mapping(address=>Message[]) public conversations;
    mapping(address => mapping(address => bool)) public operators;
    mapping(address => address[]) public following;

    uint nextId;
    uint nextMessageId;

    function _tweet(address _from, string memory _content) public {
        //checking is done in order to prevent unauthorised account from tweeting
        require(_from == msg.sender || operators[_from][msg.sender] == true , "You don't have access");
        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);
        tweetsOf[_from].push(nextId);
        nextId++;
    }

    function _sendMessage(address _from, address _to, string memory _content) public {
        //checking is done in order to prevent unauthorised account from tweeting
        require(_from == msg.sender || operators[_from][msg.sender] == true , "You don't have access");
        conversations[_from].push(Message(nextMessageId, _content, _from , _to, block.timestamp));
        nextMessageId++;
    }

    //created this function for owner of the contract to tweet from his/her account/address
    function tweet(string memory _content) public {
        _tweet(msg.sender, _content);
    }

    //created this function for other address (except owner) who wants to tweet
    function tweet(address _from, string memory _content) public {
        _tweet(_from, _content);
    }

    //created this function for owner of the contract to send the message
    function sendMessage(string memory _content, address _to) public {
        _sendMessage(msg.sender, _to, _content);
    }

    //created this function for other address (except owner) to send the message
    function sendMessage(address _from, address _to, string memory _content) public {
        _sendMessage(_from, _to, _content);
    }

    //used in order to add address of the person we want to follow to our followList
    function follow(address _followed) public {
        following[msg.sender].push(_followed);
    }

    //allow access => allows access for someone to access owners account
    function allow(address _operator) public {
        operators[msg.sender][_operator] = true;
    }

    //disallow access => disallows access for someone to access owners account
    function disallow(address _operator) public {
        operators[msg.sender][_operator] = false;
    }

    //created this function in order to get the latest tweets or top most tweets
    function getLatestTweets(uint count) public view returns( Tweet[] memory ){
        require(count>0 && count<= nextId, "Invalid Count");
        //created an array
        Tweet[] memory _tweets = new Tweet[](count); //array length - count
        uint j;
        //fetching the values from map and putting them into the array
        for(uint i = nextId-count ; i<nextId ; i++) { // count = 5 , nextId = 7;
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
            j++;
        }
        return _tweets;
    }
    
    //fetches the latest of tweet of a particular user or address
    function getLatestofUser(address _user, uint count) public view returns(Tweet[] memory){
        Tweet[] memory _tweets = new Tweet[](count); // memory array whose length is equal to count
        uint[] memory ids = tweetsOf[_user];

        require(count>0 && count<= ids.length, "Invalid Count");
        uint j;
        for(uint i= ids.length-count ; i<ids.length ; i++) {
            Tweet storage _structure = tweets[ids[i]];
            _tweets[j] = Tweet(_structure.id, _structure.author, _structure.content, _structure.createdAt);
            j++;
        }
        return _tweets;
    }

}