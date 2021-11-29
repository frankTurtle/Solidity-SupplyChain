pragma solidity ^0.8.1;

import './item.sol';

/**
 * The first thing we need is a "Management" Smart Contract, where we can add items
 */
contract ItemManager {
    //******** DATA STRUCTS ********
    enum SupplyChainState{ Created, Paid, Delivered }

    struct SupplyItem {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    //******** STORAGE VARIABLES ********
    mapping( uint => SupplyItem ) public items;

    uint itemIndex;

    //******** EVENTS ********
    event SupplyChainStep( uint _itemIndex, uint _step, address _itemAddress );

    //******** MODIFIERS ********


    //******** FUNCTIONS ********
    function createItem( string memory _identifier, uint _itemPrice ) public {
        Item item = new Item(this, _itemPrice, itemIndex);

        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state), address(item) );

        itemIndex++;
    }

    function triggerPayment( uint _itemIndex ) public payable {
        require( items[_itemIndex]._itemPrice == msg.value, "Fully payments only, fool!" );
        require( items[_itemIndex]._state == SupplyChainState.Created, "It is further down in the chain, try again" );
        
        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item) );
    }

    function triggerDelivery( uint _itemIndex ) public {
        require( items[_itemIndex]._state == SupplyChainState.Paid, "It is further down in the chain, try again" );

        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item) );
    }
}