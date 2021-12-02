import React, { useState, useEffect, useRef } from "react";

import getWeb3 from "./getWeb3";
import ItemManagerContract from './contracts/ItemManager.json';
import Item from "./contracts/Item.json";

import "./App.css";

const App = () => {
  const [cost, setCost] = useState(0);
  const [itemName, setItemName] = useState("");
  const [isLoading, setIsLoading] = useState(true);

  // Get network provider and web3 instance.
  let web3 = useRef(undefined);

  // Use web3 to get the user's accounts.
  let accounts = useRef(undefined);;
  let itemManager = useRef(undefined);;
  let item = useRef(undefined);;

  useEffect(async () => {
    web3.current = await getWeb3();
    accounts.current = await web3.current.eth.getAccounts();

    // Get the contract instance.
    const networkId = await web3.current.eth.net.getId();

    itemManager.current = new web3.current.eth.Contract(
      ItemManagerContract.abi,
      ItemManagerContract.networks[networkId] && ItemManagerContract.networks[networkId].address,
    );

    item.current = new web3.current.eth.Contract(
      Item.abi,
      Item.networks[networkId] && Item.networks[networkId].address,
    );

    listenToPaymentEvent();
    setIsLoading(false);

  }, []);

  const handleSubmit = async () => {
    console.log(itemName, cost, itemManager);

    const result = await itemManager.current.methods.createItem(itemName, cost).send({ from: accounts.current[0] });

    console.log(result);
    alert("Send " + cost + " Wei to " + result.events.SupplyChainStep.returnValues._itemAddress);
  }

  const listenToPaymentEvent = () => {
    itemManager.current.events.SupplyChainStep().on("data", async event => {
      console.log('PAYMENT EVENT!', event);
    })
  }

  return (
    isLoading
      ? <div>Loading Web3, accounts, and contract...</div>
      :
      <div className="App">
        <h1>Simply Payment/Supply Chain Example!</h1>
        <h2>Items</h2>

        <h2>Add Element</h2>
        Cost: <input type="text" name="cost" value={cost} onChange={e => setCost(e.target.value)} />
        Item Name: <input type="text" name="itemName" value={itemName} onChange={e => setItemName(e.target.value)} />
        <button type="button" onClick={handleSubmit}>Create new Item</button>
      </div>
  );
}

export default App;
