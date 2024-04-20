// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

enum ShoppingStatus {
	AWAITINGDELIVERY,
	DELIVERED,
	NO_ORDER
}

enum VotesType {
	UPVOTE,
	DOWNVOTE
}

struct PurchaseDetails {
	uint256 timeOfPurchase;
	uint64 attestationId;
	uint256 quantity;
	uint256 price;
}

struct CommentDetails {
	uint64 attestationId;
	bool hasCommented;
}



	event BuyEvent(
		address indexed buyer,
		uint256 price,
		uint256 quantity,
		uint256 indexed index
	);
	event DeliveredEvent(address indexed buyer, uint64 indexed attestionId);
	event CommentEvent(address indexed buyer, uint64 attestationId);
	event VoteEvent(address buyer, VotesType typeOFVote);