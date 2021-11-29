pragma solidity ^0.8.0;


/**
 * The first thing we need is a "Management" Smart Contract, where we can add items
 */
contract ItemManager {
    //******** DATA STRUCTS ********
    enum SupplyChainState{ Created, Paid, Delivered }

    struct Item {
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    //******** STORAGE VARIABLES ********
    mapping( uint => Item ) public items;

    uint itemIndex;

    //******** EVENTS ********
    event SupplyChainStep( uint _itemIndex, uint _step );

    //******** MODIFIERS ********


    //******** FUNCTIONS ********
    function createItem( string memory _identifier, uint _itemPrice ) public {
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = SupplyChainState.Created;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state) );

        itemIndex++;
    }

    function triggerPayment( uint _itemIndex ) public payable {
        require( items[_itemIndex]._itemPrice == msg.value, "Fully payments only, fool!" );
        require( items[_itemIndex]._state == SupplyChainState.Created, "It is further down in the chain, try again" );
        
        items[_itemIndex]._state = SupplyChainState.Paid;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state) );
    }

    function triggerDelivery( uint _itemIndex ) public {
        require( items[_itemIndex]._state == SupplyChainState.Paid, "It is further down in the chain, try again" );

        items[_itemIndex]._state = SupplyChainState.Delivered;

        emit SupplyChainStep( itemIndex, uint(items[itemIndex]._state) );
    }
}