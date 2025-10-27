// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title BlockVerseDAO
 * @dev A decentralized autonomous organization for managing blockchain projects and proposals
 */
contract Project {
    // Structs
    struct Proposal {
        uint256 id;
        string title;
        string description;
        address proposer;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
        bool exists;
    }

    struct Member {
        address memberAddress;
        uint256 votingPower;
        uint256 joinedAt;
        bool isActive;
    }

    // State variables
    address public owner;
    uint256 public proposalCount;
    uint256 public memberCount;
    uint256 public constant VOTING_PERIOD = 7 days;
    uint256 public constant MIN_VOTING_POWER = 1;

    // Mappings
    mapping(uint256 => Proposal) public proposals;
    mapping(address => Member) public members;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    mapping(address => bool) public isMember;

    // Events
    event MemberAdded(address indexed member, uint256 votingPower);
    event ProposalCreated(uint256 indexed proposalId, string title, address indexed proposer);
    event VoteCasted(uint256 indexed proposalId, address indexed voter, bool support);
    event ProposalExecuted(uint256 indexed proposalId, bool passed);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyMember() {
        require(isMember[msg.sender], "Only members can call this function");
        _;
    }

    modifier proposalExists(uint256 _proposalId) {
        require(proposals[_proposalId].exists, "Proposal does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
        // Add owner as first member
        members[msg.sender] = Member({
            memberAddress: msg.sender,
            votingPower: 100,
            joinedAt: block.timestamp,
            isActive: true
        });
        isMember[msg.sender] = true;
        memberCount = 1;
    }

    /**
     * @dev Add a new member to the DAO
     * @param _member Address of the new member
     * @param _votingPower Voting power assigned to the member
     */
    function addMember(address _member, uint256 _votingPower) external onlyOwner {
        require(!isMember[_member], "Address is already a member");
        require(_votingPower >= MIN_VOTING_POWER, "Voting power too low");
        require(_member != address(0), "Invalid address");

        members[_member] = Member({
            memberAddress: _member,
            votingPower: _votingPower,
            joinedAt: block.timestamp,
            isActive: true
        });

        isMember[_member] = true;
        memberCount++;

        emit MemberAdded(_member, _votingPower);
    }

    /**
     * @dev Create a new proposal
     * @param _title Title of the proposal
     * @param _description Detailed description of the proposal
     */
    function createProposal(string memory _title, string memory _description) external onlyMember {
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");

        proposalCount++;
        uint256 proposalId = proposalCount;

        proposals[proposalId] = Proposal({
            id: proposalId,
            title: _title,
            description: _description,
            proposer: msg.sender,
            votesFor: 0,
            votesAgainst: 0,
            deadline: block.timestamp + VOTING_PERIOD,
            executed: false,
            exists: true
        });

        emit ProposalCreated(proposalId, _title, msg.sender);
    }

    /**
     * @dev Cast a vote on a proposal
     * @param _proposalId ID of the proposal to vote on
     * @param _support True for yes, false for no
     */
    function vote(uint256 _proposalId, bool _support) external onlyMember proposalExists(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        
        require(block.timestamp < proposal.deadline, "Voting period has ended");
        require(!proposal.executed, "Proposal already executed");
        require(!hasVoted[_proposalId][msg.sender], "Already voted on this proposal");
        require(members[msg.sender].isActive, "Member is not active");

        hasVoted[_proposalId][msg.sender] = true;
        uint256 votingPower = members[msg.sender].votingPower;

        if (_support) {
            proposal.votesFor += votingPower;
        } else {
            proposal.votesAgainst += votingPower;
        }

        emit VoteCasted(_proposalId, msg.sender, _support);
    }

    /**
     * @dev Execute a proposal after voting period ends
     * @param _proposalId ID of the proposal to execute
     */
    function executeProposal(uint256 _proposalId) external proposalExists(_proposalId) {
        Proposal storage proposal = proposals[_proposalId];
        
        require(block.timestamp >= proposal.deadline, "Voting period not ended");
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;
        bool passed = proposal.votesFor > proposal.votesAgainst;

        emit ProposalExecuted(_proposalId, passed);
    }

    // View functions
    function getProposal(uint256 _proposalId) external view proposalExists(_proposalId) returns (
        uint256 id,
        string memory title,
        string memory description,
        address proposer,
        uint256 votesFor,
        uint256 votesAgainst,
        uint256 deadline,
        bool executed
    ) {
        Proposal memory proposal = proposals[_proposalId];
        return (
            proposal.id,
            proposal.title,
            proposal.description,
            proposal.proposer,
            proposal.votesFor,
            proposal.votesAgainst,
            proposal.deadline,
            proposal.executed
        );
    }

    function getMember(address _member) external view returns (
        address memberAddress,
        uint256 votingPower,
        uint256 joinedAt,
        bool isActive
    ) {
        require(isMember[_member], "Not a member");
        Member memory member = members[_member];
        return (
            member.memberAddress,
            member.votingPower,
            member.joinedAt,
            member.isActive
        );
    }

    function hasVotedOnProposal(uint256 _proposalId, address _voter) external view returns (bool) {
        return hasVoted[_proposalId][_voter];
    }
}