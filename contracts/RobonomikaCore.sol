pragma solidity ^0.4.23;

import "@thetta/core/contracts/DaoBase.sol";
import "@thetta/core/contracts/DaoStorage.sol";
import "@thetta/core/contracts/IDaoBase.sol";
import "@thetta/core/contracts/DaoClient.sol";
import "@thetta/core/contracts/tokens/StdDaoToken.sol";
import "@thetta/core/contracts/utils/UtilsLib.sol";

contract RobonomikaCore is DaoClient {
	address admin;
	address[] cookers;
	StdDaoToken roboToken;
	StdDaoToken repToken;
	
	uint feePercent = 10;

	uint public ordersCount;
	uint public lunchesCount;
	uint public cookersCount;

	mapping (uint => Order) public orders; // order number => order
	mapping (uint => Lunch) public lunches; // lunch number => lunch
	mapping (address => uint) public cookerRegisrty; // cooker->date
	mapping (address => bool) public approvedCookers; // for admin
	
	uint startDate;

	event OrderIsDelivered(uint _orderId);

	struct Order {
		OrderState state;
		Lunch lunch;
		address customer;
		uint createdAt;
		uint finishedAt;
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
		Cooking,
		Delivered,
		Open,
		Finished
	}

	modifier isApprovedByAdmin(address _cooker){
		require(approvedCookers[_cooker] == true);
		_;
	}

	constructor(IDaoBase _dao, StdDaoToken _roboToken, StdDaoToken _repToken) public DaoClient(_dao) {
		admin = msg.sender;
		roboToken = _roboToken;
		repToken = _repToken;
		startDate = now;
	}

// ------------ CUSTOMER CONTROLS ------------
	function createOrder(uint _lunchId) public payable returns(uint) {
		Lunch lunch = lunches[_lunchId];
		require(msg.value==getLunchPriceWithFee(lunch.price));
		require(roboToken.balanceOf(msg.sender)>0);
		orders[ordersCount] = Order(OrderState.Cooking, lunch, msg.sender, now, 0);
		ordersCount++;
	}

	function getLunchPriceWithFee(uint _price) public returns(uint) {
		return (_price*(100+feePercent))/100;
	}

	function getLunchFee(uint _price) public returns(uint) {
		return (_price*(feePercent))/100;
	}

	function getOrderStatus(uint _orderId) public returns(OrderState) {
		uint lunchId = orders[_orderId].lunch.id;
		return orders[_orderId].state;
	}

	function cancelOrder(uint _orderId) public {
		Order order = orders[_orderId];
		require(order.customer==msg.sender||order.lunch.cooker==msg.sender);
		require(order.state==OrderState.Cooking);
		if(order.customer==msg.sender){
			require((order.createdAt-now)>8 hours);
		}

		order.state == OrderState.Canceled;
		_rateCooker(0, _orderId);
		_rateAdmin(0, _orderId);
		order.customer.transfer(getLunchPriceWithFee(order.lunch.price));
	}

	function rateLunch(uint _orderId, uint _rate) public {
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.Open);
		require(_rate==0||_rate==1||_rate==2);
		address cooker = order.lunch.cooker;
		_rateCooker(_rate, _orderId);
		_rateAdmin(_rate, _orderId);
		order.state==OrderState.Finished;
		order.finishedAt = now;
	}

	function _rateCooker(uint _rate, uint _orderId) internal {
		Order order = orders[_orderId];
		if(_rate==0){ // bad rate, burn 100
			if(repToken.balanceOf(order.lunch.cooker)<100){
				fireChief(order.lunch.cooker);
			}else{
				dao.burnTokens(repToken, order.lunch.cooker, 100);
			}
			order.customer.transfer(getLunchPriceWithFee(order.lunch.price));
		}else if(_rate==1){ // middle rate, set 25
			dao.issueTokens(repToken, order.lunch.cooker, 25);
			order.customer.transfer((getLunchFee(order.lunch.price)*50)/100);
			order.lunch.cooker.transfer((getLunchFee(order.lunch.price)*25)/100);
		}else if(_rate==2){ // fine rate, set 100
			dao.issueTokens(repToken, order.lunch.cooker, 100);
			order.lunch.cooker.transfer((getLunchFee(order.lunch.price)*50)/100);
		}
	}

	function _rateAdmin(uint _rate, uint _orderId) internal {
		Order order = orders[_orderId];
		if(_rate==0){ // bad rate, burn 100
			if(repToken.balanceOf(admin)<100){
				// do nothing
			}else{
				dao.burnTokens(repToken, admin, 100);
			}
		}else if(_rate==1){ // middle rate, set 25
			dao.issueTokens(repToken, admin, 25);
			admin.transfer((getLunchFee(order.lunch.price)*25)/100);
		}else if(_rate==2){ // fine rate, set 100
			dao.issueTokens(repToken, admin, 100);
			admin.transfer((getLunchFee(order.lunch.price)*50)/100);
		}
	}

	function addNewLunch(string _name, uint _price, address _cooker) public { // if 30% votes => add
		lunches[lunchesCount] = Lunch(_name, lunchesCount, _price, _cooker);
		dao.issueTokens(repToken, msg.sender, 1000);
		lunchesCount++;
	}

	function getMyOrder(uint _orderId) public { // for smartLock
		Order order = orders[_orderId];
		require(order.customer==msg.sender);
		require(order.state==OrderState.Delivered);
		order.state==OrderState.Open;
	}

	function getLunchInfo(uint _lunchId) public returns(string name, uint price, address cooker) { // for smartLock
		Lunch lunch = lunches[_lunchId];
		name = lunch.name;
		price = getLunchPriceWithFee(lunch.price);
		cooker = lunch.cooker;
	}

	function getLunchesCount(uint _lunchId) public returns(uint) {
		return lunchesCount;
	}

// ------------ CHIEF CONTROLS ------------
	function getAllOpenedOrders() public returns(uint[]) {
		uint[] openOrders;
		for(uint i=0; i<ordersCount; i++){
			if(orders[i].state==OrderState.Cooking){
				openOrders.push(i);
			}
		}
		return openOrders;
	}

	function setThatOrderIsDelivered(uint _orderId) public {
		require(msg.sender==orders[_orderId].lunch.cooker);
		orders[_orderId].state = OrderState.Delivered;
		emit OrderIsDelivered(_orderId);
	}

// ------------ ADMIN CONTROLS ------------
	function approveCooker(address _cooker) public {
		require(msg.sender==admin);
		require(cookerRegisrty[_cooker]-now<10 days);
		approvedCookers[_cooker] = true;
		hireChief(_cooker);
	}


// ------------ DIRECT MANAGEMENT ------------
	function IwantToBeChief() public {
		require(repToken.balanceOf(msg.sender)>=100);
		cookerRegisrty[msg.sender] = now;
	}

	function hireChief(address _cooker) public isApprovedByAdmin(_cooker){
		cookers.push(_cooker);
	}

	function fireChief(address _cooker) public {
		UtilsLib.removeAddressFromArray(cookers, _cooker);
	}

	function hireAdmin(address _admin) public {
		admin = _admin;
	}
}