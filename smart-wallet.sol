// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Consumer {
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function deposit() public payable {}
}

contract SmartWallet {
    address payable public  owner;
    mapping(address => uint) public allowance;
    mapping(address => bool) public isAllowedToSend;
    mapping(address => bool) public guardians;
    address payable nextOwner;
    mapping(address => mapping(address => bool)) nextOwnerGuardianVotedBool;
    uint guardiansResetCount;
    uint public constant confirmationsFromGuardiansForReset = 3;

    constructor() {
        owner = payable (msg.sender);
    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You are not the owner");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public  {
        require(guardians[msg.sender], "You are not guardian of this wallet");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You already voted for this new owner");
        if(_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardiansResetCount = 0;
        }
    }

    function setAllowance(address _sender, uint _amount) public {
        require(msg.sender == owner, "You are not the owner");
        allowance[_sender] = _amount;

        if(_amount > 0) {
            isAllowedToSend[_sender] = true;
        } else {
            isAllowedToSend[_sender] = false;
        }
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        // require(msg.sender == owner, "You are not the owner");
        if (msg.sender != owner) {
            require(isAllowedToSend[msg.sender], "You are not allowed to send anythin from this sart contract aborting");
            require(allowance[msg.sender] >= _amount, "Insufficient allowance");
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, call was not successful");
        return returnData;
    }

    receive() external payable { }
}