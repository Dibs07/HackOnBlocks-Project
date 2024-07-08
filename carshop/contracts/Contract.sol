// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CarEstate {
    struct Car {
        uint256 carid;
        string name;
        string model;
        string color;
        uint256 price;
        string image;
        address owner;
        address[] reviewers;
        string[] reviews;
    }

    mapping(uint256 => Car) private cars;
    uint256 public carIndex;

    event CarListed(
        uint256 indexed carid,
        uint256 price,
        address indexed owner
    );
    event CarSold(
        uint256 indexed carid,
        uint256 price,
        address indexed oldowner,
        address indexed newowner
    );
    event CarReSold(
        uint256 indexed carid,
        uint256 price,
        address indexed oldowner,
        address indexed newowner
    );

    struct Review {
        // uint256 reviewid;
        uint256 carid;
        uint256 rating;
        string review;
        address reviewer;
        uint256 likes;
    }

    struct Product {
        uint256 productid;
        uint256 totalRating;
        uint256 totalReviews;
    }

    mapping(uint256 => Review[]) private reviews;
    mapping(address => uint256[]) private userReviews;
    mapping(uint256 => Product) private products;

    uint256 public reviewCounter;

    event ReviewAdded(
        uint256 indexed productid,
        uint256 rating,
        address indexed reviewer,
        string review
    );
    event ReviewLiked(
        uint256 indexed productid,
        uint256 indexed reviewIndex,
        address indexed liker,
        uint256 likes
    );

    function listCar(
        address owner,
        uint256 price,
        string memory _carName,
        string memory _model,
        string memory _color,
        string memory _image
    ) external returns (uint256) {
        require(price > 0, "Price must be greater than 0");
        uint256 carid = carIndex++;
        Car storage car = cars[carid];
        car.carid = carid;
        car.name = _carName;
        car.model = _model;
        car.color = _color;
        car.price = price;
        car.image = _image;
        car.owner = owner;
        emit CarListed(carid, price, owner);
        return carid;
    }

    function updateCar(
        address owner,
        uint256 carid,
        string memory _carName,
        string memory _model,
        string memory _color,
        string memory _image
    ) external returns (uint256) {
        Car storage car = cars[carid];
        require(car.owner == owner, "You are not the owner of this car");
        car.name = _carName;
        car.model = _model;
        car.color = _color;
        car.image = _image;
        return carid;
    }

    function UpdatePrice(
        address owner,
        uint256 carid,
        uint256 price
    ) external returns (string memory) {
        Car storage car = cars[carid];
        require(car.owner == owner, "You are not the owner of this car");
        car.price = price;
        return "Price updated successfully";
    }

    function buyCar(address buyer, uint256 id) external payable {
        uint256 amount = msg.value;
        require(amount >= cars[id].price, "Insufficient funds");
        Car storage car = cars[id];
        (bool sent, ) = payable(car.owner).call{value: amount}("");
        if (sent) {
            car.owner = buyer;
            emit CarSold(id, amount, car.owner, buyer);
        }
    }

    function getAllCars() public view returns (Car[] memory) {
        uint256 length = carIndex;
        uint256 currentIndex = 0;
        Car[] memory _cars = new Car[](length);
        for (uint256 i = 0; i < length; i++) {
            uint256 currentId = i + 1;
            Car storage car = cars[currentId];
            _cars[currentIndex] = car;
            currentIndex++;
        }
        return _cars;
    }

    function getCar(uint256 id) external view returns (
            uint256,
            address,
            string memory,
            string memory,
            string memory,
            uint256,
            string memory
        )
    {
        Car memory car = cars[id];
        return (
            car.carid,
            car.owner,
            car.name,
            car.model,
            car.color,
            car.price,
            car.image
        );
    }

    function getUserCars(address owner) external view returns (Car[] memory) {
        uint256 length = carIndex;
        uint256 count=0;
        uint256 currentIndex = 0;
        
        for (uint256 i = 0; i < length; i++) {
            if(cars[i+1].owner == owner){
                count++;
            }
        }
        Car[] memory _cars = new Car[](count);
        for (uint256 i = 0; i < length; i++) {
            if(cars[i+1].owner == owner){
                uint256 currentId = i + 1;
                Car storage car = cars[currentId];
                _cars[currentIndex] = car;
                currentIndex++;
            }
        }
       return _cars;
    }

    function addreview(uint256 id,uint256 rating,string calldata review,address user) external {
        require(rating > 0 && rating <= 5, "Rating must be between 1 and 5");
        Car storage _cars = cars[id];
        _cars.reviewers.push(user);
        _cars.reviews.push(review);

        reviews[id].push(Review(id, rating, review, user, 0));
        userReviews[user].push(id);
        products[id].totalRating += rating;
        products[id].totalReviews += 1;
        emit ReviewAdded(id, rating, user, review);
        reviewCounter++;
    }

    function getCarReviews(uint256 id) external view returns (Review[] memory) {
        return reviews[id];
    }

    function getUserReviews(address user) external view returns (Review[] memory) {
        uint256 totalreview = userReviews[user].length;
        Review[] memory _reviews = new Review[](totalreview);
        for (uint256 i = 0; i < totalreview; i++) {
            uint256 id = userReviews[user][i];
            Review[] storage _review = reviews[id];
            for(uint256 j = 0; j < _review.length; j++){
               if(_review[j].reviewer == user){
                   _reviews[i] = _review[j];
               }
            }
        }
        return _reviews;
    }

    function likeReview(uint256 id,uint256 reviewindex, address user) external {
        Review storage review = reviews[id][reviewindex];
        review.likes += 1;
        emit ReviewLiked(id, reviewindex, user, review.likes);
    }

    function getHighestRatedCar() external view returns (uint256) {}
}
