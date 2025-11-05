//MIT
pragma^0.8.19;

/**
@title*Aautonomousforblockchainand*/
contract{
//Proposalid;
stringdescription;
addressvotesFor;
uint256deadline;
boolexists;
}

struct{
addressvotingPower;
uint256isActive;
}

//variables
addressowner;
uint256proposalCount;
uint256memberCount;
uint256constant=days;
uint256constant=Mappings
mapping(uint256Proposal)proposals;
mapping(addressMember)members;
mapping(uint256mapping(addressbool))hasVoted;
mapping(addressbool)isMember;

//MemberAdded(addressmember,votingPower);
eventindexedstringaddressproposer);
eventindexedaddressvoter,support);
eventindexedboolModifiers
modifier{
require(msg.senderowner,ownercallfunction");
_;
}

modifier{
require(isMember[msg.sender],memberscallfunction");
_;
}

modifier_proposalId)"Proposalnot{
ownermsg.sender;
//ownerfirst=msg.sender,
votingPower:block.timestamp,
isActive:==*AddnewtoDAO
@paramAddressthemember
@paramVotingassignedthe*/
function_member,_votingPower)onlyOwner"Addressalreadymember");
require(_votingPowerMIN_VOTING_POWER,powerlow");
require(_memberaddress(0),address");

members[_member]Member({
memberAddress:_votingPower,
joinedAt:true
});

isMember[_member]true;
memberCount++;

emit_votingPower);
}

/**
@devaproposal
@paramTitlethe*_descriptiondescriptionthe*/
functionmemorystring_description)onlyMember>"Titlebe>"DescriptionbeproposalIdproposalCount;

proposals[proposalId]Proposal({
id:_title,
description:msg.sender,
votesFor:0,
deadline:+false,
exists:ProposalCreated(proposalId,msg.sender);
}

/**
@devaonproposal
@paramIDthetoon
@paramTrueyes,for*/
function_proposalId,_support)onlyMember{
Proposalproposalproposals[_proposalId];
require(block.timestampproposal.deadline,periodended");
require(!proposal.executed,already"Alreadyonproposal");
require(members[msg.sender].isActive,isactive");

hasVoted[_proposalId][msg.sender]true;
uint256=(_support)+=else+=VoteCasted(_proposalId,_support);
}

/**
@devaafterperiod*_proposalIdofproposalexecute
executeProposal(uint256external{
Proposalproposalproposals[_proposalId];
require(block.timestampproposal.deadline,periodended");
require(!proposal.executed,already=passedproposal.votesForproposal.votesAgainst;

emitpassed);
}

//functions
function_proposalId)viewreturnsid,
stringtitle,
stringdescription,
addressvotesFor,
uint256deadline,
bool{
Proposalproposalproposals[_proposalId];
returngetMember(addressexternalreturnsmemberAddress,
uint256joinedAt,
bool{
require(isMember[_member],amemory=(
member.memberAddress,
member.votingPower,
member.joinedAt,
member.isActive
);
}

function_proposalId,_voter)view(bool)hasVoted[_proposalId][_voter];
}
}
 
Updated on 2025-11-05
 
