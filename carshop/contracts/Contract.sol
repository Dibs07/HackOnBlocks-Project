// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CarEstate {

    struct Car {
        uint256 carid;
        string name;
        string model;
        string color;
        uint256 price;
        uint256 year;
        string image;
        address owner;
        address[] reviewers;
        string[] reviews;
    }

    mapping(uint256 => Car) private cars;
    uint256 public carIndex;

    event CarListed(uint256 indexed carid, uint256 price, address indexed owner);
    event CarSold(uint256 indexed carid, uint256 price, address indexed oldowner, address indexed newowner);
    event CarReSold(uint256 indexed carid, uint256 price, address indexed oldowner, address indexed newowner);

    struct Review {
        uint256 reviewid;
        uint256 carid;
        string review;
        address reviewer;
        uint256 likes;
    }

    function listCar() external returns (uint256) {}

    function updateCar() external returns (uint256) {}

    function buyCar() external payable{}

    function getAllCars() public view returns(Car[] memory) {}

    function getCar() external view returns() {}

    function getUserCars() external view returns(Car[] memory) {}

    function addreview() external {}

    function getCarReviews() external view returns(Review[] memory) {}

    function getUserReviews() external view returns(Review[] memory) {}

    function likeReview() external {}

    function getHighestRatedCar() external view returns(uint256) {}


}

