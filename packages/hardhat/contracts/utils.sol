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
