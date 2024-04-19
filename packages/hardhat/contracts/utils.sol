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
    };

     struct PurchaseDetails {
        uint256 timeOfPurchase;
        uint256 quantity;
    };