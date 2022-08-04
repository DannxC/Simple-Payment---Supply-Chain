//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ItemManager{

    enum SupplyChainState{Created, Paid, Delivered}     //Created == 0 -> Paid == 1 -> Delivered == 2

    struct S_Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping(uint => S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step);

    function createItem(string memory _identifier, uint _itemPrice) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state));
        itemIndex++;
    }

    function triggerPayment(uint _itemIndex) public payable {
        require(items[_itemIndex]._itemPrice == msg.value, "Not fully paid");
        require(items[_itemIndex]._state == SupplyChainState.Created, "Item is further in the supply chain");
        emit SupplyChainStep(_itemIndex, uint(items[itemIndex]._state));
        items[_itemIndex]._state = SupplyChainState.Paid;
    }

    function triggerDelivery(uint _itemIndex) public {
        require(items[_itemIndex]._state == SupplyChainState.Paid, "Item is further in the supply chain");
        emit SupplyChainStep(_itemIndex, uint(items[itemIndex]._state));
        items[_itemIndex]._state = SupplyChainState.Delivered;
    }

}