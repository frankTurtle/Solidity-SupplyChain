const ItemManager = artifacts.require('ItemManager.sol');

contract('ItemManager', accounts => {
    it('Should be able to add an Item', async () => {
        const itemManagerInstance = await ItemManager.deployed();
        const itemName = 'test1';
        const itemPrice = 123;

        const result = await itemManagerInstance.createItem(itemName, itemPrice, { from: accounts[0] });
        assert.equal(result.logs[0].args._itemIndex, 0, "NOT THE FIRST");
    })
});