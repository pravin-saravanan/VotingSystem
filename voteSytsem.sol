pragma solidity ^0.8.0;

contract Voting {

    address public owner;
    uint256 public votingStart;
    uint256 public votingEnd;

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor(uint256 _durationInMinutes) {
        owner = msg.sender;
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    // Only owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner allowed");
        _;
    }

    //  Add candidate (only owner)
    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate(_name, 0));
    }

    // Vote function
    function vote(uint256 _candidateIndex) public {
        require(block.timestamp >= votingStart, "Voting not started");
        require(block.timestamp <= votingEnd, "Voting ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(_candidateIndex < candidates.length, "Invalid candidate");

        candidates[_candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;
    }

    // winner
    function getWinner() public view returns (string memory winnerName) {
        uint256 highestVotes = 0;
        uint256 winnerIndex = 0;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        winnerName = candidates[winnerIndex].name;
    }
}
