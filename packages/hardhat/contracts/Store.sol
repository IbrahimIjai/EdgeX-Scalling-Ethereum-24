// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import { ShoppingStatus, VotesType, PurchaseDetails } from "./utils.sol";

contract Product {
	uint256 public totalAvailableStoke;
	string public productName;
	uint256 pricePerOne;
	uint256 discount;

	uint256 upVotes;
	uint256 downVotes;

	uint256 totalPurchases;

	//customer can only place a single order at a time

	mapping(address customer => mapping(uint256 trxIndex => PurchaseDetails)) customerHistory;

	mapping(address customer => ShoppingStatus) customerCurShoppingStatus;

	//keep customer vote type
	mapping(address customer => VotesType) customerVote;

	constructor() {}
// https://github.com/IbrahimIjai/EdgeX-Scalling-Ethereum-24
// EdgeX-Scalling-Ethereum-24
	function buy(uint64 quantity) {
        require()
		//require shopping status to not be awaiting delivery
		//calc price
		//collect deposit
		//set customer history
		//Increase index by 1.
		// set that index to the curresponding quantity
		//admin attestation that bought is successful
		//emit event
	}

	function deliver() {
		//Admin now make an attestation of having actually bought and recieved
		//attestation- current time, total value of goods, history index
	}

	function comment(string commentUrl) {
		//check if a msgsender has buy history
		// check if attestation exist for actually bought and delivered
		// We now make an attestation of having actually met IRL
		//collect deposit
		//set attestation
		//emit event
	}

	function vote(VotesType typeOFVote) {
		// check attestation for actually bought and actually delivered
		//if user has vote up vote and votetype is up vote, revert and vice versa
		//if upvote, upvote + 1 and if downvote is not 0 downvote -1
		//if downvote, downvote + 1 and if upvote is not 0, upvote -1
	}

	//PROXY ADMIN FUNCTION

	function confirmDelivery() {
		//continually monitors for a delivery attestation
		// set customer deliver status
	}

	//GETTERS FUNCTION

	function getCustomerDetails() {}
}
