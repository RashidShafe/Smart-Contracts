//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor()
    {
        manager=msg.sender;
    }

    receive() external payable
    {
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }

    function winnerNo() public view returns(uint)
    {
        //we have to make sure that each node of the chain must give the same random number
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
    function winnerSelect() public /*view returns(address)*/
    {
        require(msg.sender==manager);
        require(participants.length>=3);

        uint index = uint(winnerNo()) % (participants.length+1);
        /*uint x=winnerNo();
        uint index=x % participants.length;*/
        address payable winner;
        winner=participants[index];
        winner.transfer(getBalance());
        participants=new address payable[](0);
        //return winner;
    }
}
