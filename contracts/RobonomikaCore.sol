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
	address[] cookers;
	StdDaoToken roboToken;
	StdDaoToken repToken;
	mapping (uint => Order) public orders; // order number => order
	uint public ordersCount;

	// mapping (uint => Cooker) public cookers; // cooker number => cooker
	uint public cookersCount;

	// mapping (uint => Lunch) public potentialCookers;
	// uint public potentialCookersCount;

	mapping (uint => Lunch) public lunches; // lunch number => lunch
	mapping (uint => OrderState) public lunchStates;
	uint public lunchesCount;

	// mapping (uint => Lunch) public potentialLunches;
	// uint public potentialLunchesCount;

	uint startDate;

	struct Order {
		OrderState state;
		Lunch lunch;
		address customer;
	}

	struct Lunch {
		string name;
		uint id;
		uint price;
		address cooker;
	}

	enum OrderState {
		NotCreated,
		Canceled,
		Created,
		Cooking, // computes in geOrderStatus
		Delivering, // computes in getOrderStatus
		WaitingForReceive,
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
	}

// ------------ CUSTOMER CONTROLS ------------
	function createOrder(uint _lunchId) public payable returns(uint){
		Lunch lunch = lunches[_lunchId];
		require(msg.value==lunch.price);
		orders[ordersCount] = Order(OrderState.Created, lunch, msg.sender);
		ordersCount++;
	}

	function getOrderStatus(uint _orderId) public returns(OrderState) {
		uint lunchId = orders[_orderId].lunch.id;
		if(lunchStates[lunchId]!=OrderState.NotCreated){
			return lunchStates[lunchId];
		}
		return orders[_orderId].state;
	}

	function cancelOrder(uint _orderId) public {
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.Created);
		order.state == OrderState.Canceled;
		msg.sender.transfer(order.lunch.price);
	}

	function rateLunch(uint _orderId, uint _rate) public {
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.Received);
		address cooker = order.lunch.cooker;
		DaoBaseLib.issueTokens(daoStorage, repToken, cooker, _rate); // TODO: change _rate to rateCooker(_rate)
		order.state==OrderState.Finished;
	}

	function addNewLunch(string _name, uint _price, uint _cookerId) public { // if 30% votes => add
		address cooker = cookers[_cookerId];
		lunches[lunchesCount] = Lunch(_name, lunchesCount, _price, cooker);
		lunchesCount++;
	}

	function refund(uint _orderId) public { // if not cooking/canceled by cooker
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.Cooking);
		// TODO: require > 8 hours in cooking state
		order.state = OrderState.Canceled;
		order.customer.transfer(order.lunch.price);
		DaoBaseLib.burnTokens(daoStorage, repToken, order.lunch.cooker, 1000);
	}

	function getMyOrder(uint _orderId) public { // for smartLock
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.WaitingForReceive);
		order.state==OrderState.Received;
	}

// ------------ CHIEF CONTROLS ------------
	function getAllOpenedOrders() public returns(uint[]) {
		uint[] openedOrders;
		for(uint i=0; i<ordersCount; i++){
			if(orders[i].state==OrderState.Created){
				openedOrders.push(i);
			}
		}
		return openedOrders;
	}

	function setThatLunchIsCooking(uint _lunchId) public {
		lunchStates[_lunchId]==OrderState.Cooking;
	}

	function setThatLunchIsDelivering(uint _lunchId) public {
		lunchStates[_lunchId]==OrderState.Delivering;
	}

	function setThatLunchIsWaitingForReceive(uint _lunchId) public {
		lunchStates[_lunchId]==OrderState.WaitingForReceive;
	}

	function setThatLunchIsCanceled(uint _lunchId) public {
		lunchStates[_lunchId]==OrderState.Canceled;
	}

// ------------ ADMIN CONTROLS ------------
	// function requestAdditionalFunds() public {}

// ------------ DIRECT MANAGEMENT ------------
	function setChief(address _cooker) public {
		cookers.push(_cooker);
	}

	function fireChief(address _cooker) public {
		UtilsLib.removeAddressFromArray(cookers, _cooker);
	}	

	function changeAdmin(address _admin) public {
		admin = _admin;
	}
}