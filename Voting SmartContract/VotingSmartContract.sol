// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract VotingSmartContract{
    
    struct Voter {
        string name;
        uint age;
        uint voterId;
        string gender;
        uint voteCandidateId;   //candidate id to whom voter has voted
        address voterAddress;
    }

    struct Candidate {
        string name;
        string party;
        uint age;
        string gender;
        uint candidateId;
        address candidateAddress;
        uint votes; //number of votes to a candidate
    }

    address electionCommission;
    address public winner;

    uint nextVoterId = 1;   // Voter ID for voters
    uint nextCandidateId = 1;   // Candidate Id for candidates

    uint startTime; //start time of election
    uint endTime;   //end time of election

    mapping(uint => Voter) voterDetails; //details of voters
    mapping(uint => Candidate) candidateDetails; //details of candidates

    bool stopVoting; //This is for an emergency situation to stop voting

    constructor() {
        electionCommission = msg.sender;
    }

    modifier isVotingOver() {
        require(endTime > block.timestamp && stopVoting != true, "Voting is over");
        _;
    }

    modifier onlyCommisioner() {
        require(msg.sender == electionCommission, "You are not from election commision");
        _;
    }

    //registering a candidate
    function candidateRegister(string calldata _name, string calldata _party, uint _age, string calldata _gender) external{
        //age check
        require(_age>=18 , "Age is under 18");
        require(candidateVerification(msg.sender), "You have already registered");
        require(nextCandidateId <=2 , "Candidate registration full");
        candidateDetails[nextCandidateId] = Candidate({
            name: _name,
            party: _party,
            age: _age,
            gender: _gender,
            candidateId: nextCandidateId,
            candidateAddress: msg.sender,
            votes:0
        });
        nextCandidateId++;
    }

    //candidate verfication function
    function candidateVerification(address _person) internal view returns(bool) {
        for (uint i = 1 ; i<nextCandidateId; i++) {
            if(candidateDetails[i].candidateAddress == _person ) {
                return false;
            }
        }
        return true;
    }

    function candidateList() public view returns(Candidate[] memory) {
        Candidate[] memory candidateArray = new Candidate[](nextCandidateId-1);
        for (uint i = 1 ; i<nextCandidateId; i++) {
            candidateArray[i-1] = candidateDetails[i]; // transferring data from mapping to array
        }
        return candidateArray;
    }

    function voterRegister(string calldata _name, uint _age, string calldata _gender) external {
        //age check for voter as well
        require(_age>=18, "Voter is below 18");
        require(voterVerification(msg.sender), "Voter already registered");

        voterDetails[nextVoterId] = Voter ({
            name: _name,
            age:  _age,
            voterId: nextVoterId,
            gender: _gender,
            voteCandidateId: 0,
            voterAddress: msg.sender
        });
        nextVoterId++;
    }

    function voterVerification(address _person) internal view returns(bool){
        for (uint i = 1 ; i<nextVoterId; i++) {
            if(voterDetails[i].voterAddress == _person ) {
                return false;
            }
        }
        return true;
    }

    function voterList() public view returns(Voter[] memory){
        Voter[] memory voterArray = new Voter[](nextVoterId-1);
        for (uint i = 1 ; i<nextVoterId; i++) {
            voterArray[i-1] = voterDetails[i]; // transferring data from mapping to array
        }
        return voterArray;
    }
    
    function vote(uint _voterId, uint _candidateId) external isVotingOver() {
        require(voterDetails[_voterId].voterAddress == msg.sender, "You have not registered");
        require(_candidateId > 0 && _candidateId < 3, "Candidate id is not valid");
        require(startTime != 0, "Voting has not started yet");
        require(nextCandidateId == 3, "Candidates have not registered" );
        require(voterDetails[_voterId].voteCandidateId == 0, "Voter has already voted");
        voterDetails[_voterId].voteCandidateId = _candidateId;
        candidateDetails[_candidateId].votes++;
    }

    function voteTime(uint _startTime, uint duration) external onlyCommisioner() {
        startTime = _startTime;
        endTime = _startTime+duration;
    }

    function votingStatus() public view returns(string memory){
        if (startTime == 0){
            return "Voting has not started yet";
        }else if ( (endTime>block.timestamp) && (stopVoting != true) ) {
            return "Voitng is in progress";
        }else {
            return "Voting period has ended";
        }
    }

    function result() external onlyCommisioner() {
        uint max = 0;

        for(uint i=1 ; i<nextCandidateId; i++) {
            if(candidateDetails[i].votes > max) {
                max = candidateDetails[i].votes;
                winner = candidateDetails[i].candidateAddress;
            }
        }
    }

    function emergency() public onlyCommisioner() {
        stopVoting = true;
    }
}