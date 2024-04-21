// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import { ISP } from "@ethsign/sign-protocol-evm/src/interfaces/ISP.sol";
import { Attestation } from "@ethsign/sign-protocol-evm/src/models/Attestation.sol";
import { DataLocation } from "@ethsign/sign-protocol-evm/src/models/DataLocation.sol";

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ShoppingStatus, VotesType, PurchaseDetails, CommentDetails, BuyEvent, DeliveredEvent, CommentEvent, VoteEvent, UserData } from "./utils.sol";

//SCHEMAS
//32 data":[{"name":"buyerAddress","type":"address"},{"name":"transactionIndex","type":"uint256"}]}
//33 data":[{"name":"comment","type":"string"}]}

contract Product is Ownable {
	ISP public spInstance;
	uint64 public schemaId_Invoice;
	uint64 public schemaId_Comment;

	using SafeMath for uint256;
	using SafeMath for uint64;

	uint256 public totalAvailableStoke;

	uint256 public pricePerOne;
	uint256 public discount;

	uint64 public upVotes;
	uint64 public downVotes;

	uint64 public trxIndex;

	uint256 public totalPurchases;

	string public productName;
	string public StoreName;
	string public productImageUrl;

	//customer can only place a single order at a time

	mapping(address customer => mapping(uint64 trxIndex => PurchaseDetails))
		public customerHistory;

	mapping(uint64 trxIndex => address buyer) public buyerByTransactionIndex;

	mapping(address customer => ShoppingStatus)
		public customerCurShoppingStatus;

	//keep customer vote type
	mapping(address customer => VotesType) public customerVote;
	//keep customer Coment
	mapping(address customer => CommentDetails) public buyerCommented;

	constructor(
		uint256 _pricePerOne,
		uint256 _totalAvailableStoke,
		string memory _productName,
		string memory _storeName,
		string memory _productImageUrl
	) Ownable() {
		pricePerOne = _pricePerOne;
		totalAvailableStoke = _totalAvailableStoke;
		productName = _productName;
		StoreName = _storeName;
		productImageUrl = _productImageUrl;
	}

	function buy(uint64 quantity) public payable {
		require(
			customerCurShoppingStatus[msg.sender] ==
				ShoppingStatus.AWAITINGDELIVERY,
			"You can't place an order while awaiting delivery"
		);
		require(totalAvailableStoke >= quantity, "Insufficient stock!");

		uint256 price = quantity.mul(pricePerOne);

		require(msg.value >= pricePerOne, "Insufficient payment sent!");
		trxIndex++;
		totalAvailableStoke = totalAvailableStoke.sub(quantity);
		customerHistory[msg.sender][trxIndex] = PurchaseDetails(
			block.timestamp,
			0,
			quantity,
			pricePerOne
		);

		buyerByTransactionIndex[trxIndex] = msg.sender;

		customerCurShoppingStatus[msg.sender] = ShoppingStatus.AWAITINGDELIVERY;
		emit BuyEvent(msg.sender, price, quantity, trxIndex);
	}

	function deliveredCompleted(
		uint64 index,
		address buyerAddress
	) public onlyOwner {
		//Get Address by index
		require(index <= trxIndex, "transaction history does not exist");

		address buyer = buyerByTransactionIndex[index];
		require(
			customerCurShoppingStatus[buyer] == ShoppingStatus.AWAITINGDELIVERY,
			"No buy order found"
		);
		UserData memory userData = UserData(buyerAddress, index);
		bytes memory data = abi.encode(userData);

		bytes[] memory recipients = new bytes[](1);
		recipients[0] = abi.encode(buyer);

		customerCurShoppingStatus[buyer] = ShoppingStatus.DELIVERED;

		Attestation memory a = Attestation({
			schemaId: schemaId_Invoice,
			linkedAttestationId: 0,
			attestTimestamp: 0,
			revokeTimestamp: 0,
			attester: address(this),
			validUntil: 0,
			dataLocation: DataLocation.ONCHAIN,
			revoked: false,
			recipients: recipients,
			data: data
		});
		uint64 attestationId = spInstance.attest(a, "", "", "");
		customerHistory[msg.sender][trxIndex].attestationId = attestationId;
		emit DeliveredEvent(buyer, attestationId);
	}

	function comment(string memory comment) public {
		require(
			customerCurShoppingStatus[msg.sender] != ShoppingStatus.DELIVERED,
			"You need to use product before commenting"
		);

		bytes[] memory recipients = new bytes[](1);

		recipients[0] = abi.encode(msg.sender);
		bytes memory data = bytes(comment);

		Attestation memory a = Attestation({
			schemaId: schemaId_Comment,
			linkedAttestationId: 0,
			attestTimestamp: 0,
			revokeTimestamp: 0,
			attester: address(this),
			validUntil: 0,
			dataLocation: DataLocation.ONCHAIN,
			revoked: false,
			recipients: recipients,
			data: data // SignScan assumes this is from `abi.encode(...)`
		});
		uint64 attestationId = spInstance.attest(a, "", "", "");
		buyerCommented[msg.sender] = CommentDetails(attestationId, true);
		emit CommentEvent(msg.sender, attestationId);
	}

	function vote(VotesType typeOFVote) public {
		// check attestation for actually bought and actually delivered
		require(
			customerHistory[msg.sender][trxIndex].attestationId > 0,
			"You can not vote until you product has been delivered"
		);

		if (customerVote[msg.sender] == VotesType.UPVOTE) {
			if (typeOFVote == VotesType.UPVOTE) {
				return;
			} else {
				upVotes.sub(1);
				downVotes.add(1);
			}
		} else if (customerVote[msg.sender] == VotesType.DOWNVOTE) {
			if (typeOFVote == VotesType.UPVOTE) {
				upVotes.add(1);
				downVotes.sub(1);
			} else {
				return;
			}
		} else {
			customerVote[msg.sender] = typeOFVote;
			if (typeOFVote == VotesType.UPVOTE) {
				upVotes.add(1);
				downVotes.sub(1);
			} else {
				downVotes.sub(1);
				upVotes.add(1);
			}
		}

		emit VoteEvent(msg.sender, typeOFVote);
	}

	//GETTERS FUNCTION

	function getCustomerDetails(
		address buyer,
		uint64 index
	) public view returns (PurchaseDetails memory) {
		return customerHistory[buyer][index];
	}

	//ADMIN
	function setSPInstance(address instance) external onlyOwner {
		spInstance = ISP(instance);
	}

	function setCommentSchemaID(uint64 schemaId_) external onlyOwner {
		schemaId_Comment = schemaId_;
	}

	function setInvoicetSchemaID(uint64 schemaId_) external onlyOwner {
		schemaId_Invoice = schemaId_;
	}
}
