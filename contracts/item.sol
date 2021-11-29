pragma solidity ^0.8.1;

import './itemmanager.sol';

// Responsible for taking the payment and handing the transaction off to the Item Manager
contract Item {
    //******** DATA STRUCTS ********

    //******** STORAGE VARIABLES ********
    uint public priceInWei;
    uint public paidWei;
    uint public index;

    ItemManager parentContract;

    //******** EVENTS ********

    //******** MODIFIERS ********

    //******** FUNCTIONS ********
    constructor( ItemManager _parentContract, uint _priceInWei, uint _index ) {
        parentContract = _parentContract;   
        priceInWei = _priceInWei;
        index = _index;
    }

    receive() external payable {
        require( msg.value == priceInWei, "No partial payments" );
        require( paidWei == 0, "Item is already paid!" );

        paidWei += msg.value;

        ( bool success, ) = address( parentContract ).call{ value: msg.value }( abi.encodeWithSignature("triggerPayment(uint256)", index) );
        require( success, "Shit is broken! It did not deliver, correctly" );
    }
}