// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Store.sol";

contract ProductFactory is Ownable {
	address[] public deployedProducts;

	function createProduct(
		uint256 _pricePerOne,
		uint256 _totalAvailableStoke,
		string memory _productName,
		string memory _storeName,
		string memory _productImageUrl
	) external {
		address newProduct = address(
			new Product(
				_pricePerOne,
				_totalAvailableStoke,
				_productName,
				_storeName,
				_productImageUrl
			)
		);
		deployedProducts.push(newProduct);
	}

	function getDeployedProducts() external view returns (address[] memory) {
		return deployedProducts;
	}
}