pragma solidity ^0.4.23;

import "@thetta/core/contracts/DaoBase.sol";
import "@thetta/core/contracts/DaoStorage.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";

/*
1 - Клиент (Token Holder)
Чтобы стать Клиент нужно купить токены компании (то есть быть token holder’ом).
Никто другой не может совершать заказы.
Клиент может стать Повар.


2 - Админ
Админ на всю схему только один. 
Получает fee от каждого заказа.
Сменить его можно голосованием Клиент’ов.
У Админа есть репутация, но формальные правила отсутствуют (то есть репутация здесь только неформально служит показателем качества админа).
Чтобы стать Админ, необходимо обладать определенным количеством репутации.


3 - Повар
Готовит еду.
Получает за это деньги.

*/

contract RobonomicaCore is DaoBase {
	address admin;
	address[] chiefs;
	StdDaoToken roboToken;
	StdDaoToken repToken;
	mapping (uint => (uint =>Order[])) public orders; // Day number => order number => order
	mapping (uint => uint) public orderCount; // Day number => order count
 	Dish[] dishes;
	mapping (uint => (string => DishState)) public dishStates; // Day number => 

	uint startDate;

	struct Order {
		OrderState state;
		Dish[] dishes;
		address customer;

	}

	struct Dish {
		string name;
		uint price;
		address cooker;
	}

	enum DishState {
		NotExist,
		Gotten,
		Cooking,
		Ready,
		Canceled
	}

	enum OrderState {
		NotCreated,
		Canceled,
		Created,
	//	Cooking, -- computes in getOrderStatus
	//	Delivering, computes in getOrderStatus
		Received,
		Finished
	}


	modifier adminOnly(){
		require(msg.sender==admin); 
		_; 
	}

	constructor(DaoStorage _daoStorage) public DaoBase(_daoStorage){
		admin = msg.sender;
		roboToken = _daoStorage.getTokenAtIndex(0);
		repToken = _daoStorage.getTokenAtIndex(1);
		startDate = now;
		DaoBaseLib.issueTokens(_daoStorage, repToken, admin, 1000);
	}

	function getDayNumber() public returns(uint) {
		return (now - startDate)/(24*3600*1000);
	}

// ------------ CUSTOMER CONTROLS ------------
	function createOrder(string[] _dishNames) public {
		Dishes[] orderedDishes;
		for(uint i=0; i<_dishNames.length; i++){
			orderedDishes.push(getDishByName(_dishNames[i]));
		}
		
		uint thisDay = getDayNumber();
		orders[thisDay].push(Order(OrderState.Gotten, orderedDishes, msg.sender));
	}

	function getDishByName(string _name) public returns(Dish) {
		Dish returnedDish;
		for(uint i=0; i<dishes.length; i++){
			if(Dish[i].name==_name){
				return Dish;
			}
		}
		revert(); // of not found
	}

	function getAllDishes() public returns(Dish[]){
		return dishes;
	}

	function getOrderStatus() public {

	}

	function getMyOrderStatus() public {}
	function cancelOrder() public {}
	function rateDishQuality() public {}
	function voteForHireChief() public {} // if 30% votes => hire, exist permanenlty
	function voteForFireChief() public {}// if 30% votes => fire, exist permanenlty
	function voteForChangeAdmin() public {} // if 30% votes => hire, exist permanenlty
	function createVotingForNewDish() public {} // if 30% votes => add
	function voteForNewDish() public {} // if 30% votes => add
	function refund() public {} // if not cooking/canceled by chief
	function getMyOrder() public {} // fro smartLock

	function voteForAdditionalFundsRequest() public {}

// ------------ CHIEF CONTROLS ------------
	function getAllOrders() public {}
	function setThatDishIsCooking() public {}
	function setThatAllDishesAreDelivering() public {}
	function setThatDishIsCanceled() public {}


// ------------ ADMIN CONTROLS ------------
	function requestAdditionalFunds() public {}

// ------------ DISHES MANAGEMENT ------------
	function addNewDish(string _name, uint _price) public {
		// require msg.sender is chief;
		// require _name is unique
		dishes.push(Dish(_name, _price, msg.sender));
	}

	function removeDish(string _name, uint _price) public {
		// require msg.sender is chief;
		// removeDishFromArray(_name);
	}	

	function changeDishPrice(string _name, uint _price) public {
		// require msg.sender is chief;
	}


// ------------ DIRECT MANAGEMENT ------------
	function setChief(address _chief) public {
		chiefs.push(_chief);
	}

	function fireChief(address _chief) public {
		UtilsLib.removeAddressFromArray(chiefs, _chief);
	}	

	function changeAdmin(address _admin) public {
		admin = _admin;
	}
}