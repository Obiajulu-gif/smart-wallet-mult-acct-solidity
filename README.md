````markdown
# 🦊 Smart Wallet & Consumer Contracts

This Solidity project demonstrates how to build a **Smart Wallet** system with **ownership control**, **allowances**, and **guardian recovery features** — along with a simple `Consumer` contract for testing deposits and balance checking.

---

## 📜 Overview

The project contains two contracts:

1. **Consumer**
   - A simple contract that can **receive Ether** and **display its balance**.

2. **SmartWallet**
   - A smart wallet that supports:
     - Ownership management
     - Guardian-based recovery
     - Allowances for specific addresses
     - Secure Ether transfers
     - Receiving Ether safely

---

## ⚙️ Contracts Explained

### **1. Consumer Contract**

```solidity
contract Consumer {
    function getBalance() public view returns (uint);
    function deposit() public payable {}
}
````

#### 🔹 Features

* **Deposit Ether:** Allows anyone to send Ether using the `deposit()` function.
* **Check Balance:** Returns the current Ether balance of the contract with `getBalance()`.

---

### **2. SmartWallet Contract**

#### 🔹 Purpose

A secure wallet that can:

* Store Ether
* Allow delegated spending by trusted addresses
* Be recovered by guardians in case the owner loses access

#### 🔹 Key Variables

| Variable                             | Type                       | Description                                   |
| ------------------------------------ | -------------------------- | --------------------------------------------- |
| `owner`                              | `address payable`          | The main controller of the wallet             |
| `guardians`                          | `mapping(address => bool)` | Trusted users who can help recover ownership  |
| `allowance`                          | `mapping(address => uint)` | Spending limits for specific addresses        |
| `isAllowedToSend`                    | `mapping(address => bool)` | Whether an address can send funds             |
| `nextOwner`                          | `address payable`          | The proposed new owner (for recovery)         |
| `confirmationsFromGuardiansForReset` | `uint constant`            | Number of guardian confirmations required (3) |

---

## 🧩 Functions Breakdown

### **Constructor**

```solidity
constructor()
```

* Sets the deployer of the contract as the wallet **owner**.

---

### **setGuardian**

```solidity
function setGuardian(address _guardian, bool _isGuardian) public
```

* Only the **owner** can call this.
* Adds or removes a guardian.
* `_isGuardian = true` → add guardian
  `_isGuardian = false` → remove guardian.

---

### **proposeNewOwner**

```solidity
function proposeNewOwner(address payable _newOwner) public
```

* Allows **guardians** to propose and vote for a **new owner**.
* Each guardian can vote once per proposed owner.
* If a different new owner is proposed, previous votes reset.

---

### **setAllowance**

```solidity
function setAllowance(address _sender, uint _amount) public
```

* Only the **owner** can call this.
* Sets how much Ether a certain address can spend.
* If `_amount > 0`, that address is allowed to send funds.

---

### **transfer**

```solidity
function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory)
```

* Handles Ether transfers and contract interactions.
* If called by someone other than the owner:

  * Must be allowed (`isAllowedToSend`)
  * Must have enough allowance
* Uses low-level `.call{value: _amount}(_payload)` for execution.

---

### **receive**

```solidity
receive() external payable
```

* Special fallback function that allows the wallet to **receive Ether** directly.

---

## 💰 Example Usage

### **Deploying the Smart Wallet**

1. Deploy `SmartWallet`.
2. The deployer becomes the **owner**.

### **Depositing Ether**

* Anyone can send Ether directly to the wallet address, or via the `deposit()` function in `Consumer`.

### **Setting a Guardian**

```solidity
setGuardian(0xABC..., true);
```

### **Setting an Allowance**

```solidity
setAllowance(0xDEF..., 2 ether);
```

### **Making a Transfer**

```solidity
transfer(payable(0x123...), 1 ether, "");
```

---

## 🔐 Security Features

✅ **Ownership Control** — Only the owner can set guardians and allowances.
✅ **Allowance Checks** — Prevents unauthorized spending.
✅ **Guardian Voting** — Multi-signature recovery ensures wallet safety.
✅ **Revert on Failure** — Transactions revert if calls fail.

---

## 🧠 Real-World Analogy

* **Owner:** You (main wallet holder)
* **Guardians:** Trusted friends who can recover your wallet
* **Allowance:** Spending limits for assistants or apps
* **Transfer:** Sending money or interacting with other contracts
* **Receive:** Accepting incoming payments

---

## 🧪 Testing (Optional)

You can test this in [Remix IDE](https://remix.ethereum.org):

1. Copy the contract code.
2. Select Solidity compiler version `0.8.30`.
3. Deploy `SmartWallet` and `Consumer`.
4. Use the `deposit`, `transfer`, and `setAllowance` functions.
5. Observe balances using `getBalance()` and transaction logs.

---

## 🧾 License

This project is licensed under the **MIT License**.

---

### 👨‍💻 Author

**Okoye [Your Name]**
Smart Contract Developer | Solidity Learner 🚀

```

---

Would you like me to include **inline examples with Remix IDE screenshots and deployment steps** (so you can use this README for a GitHub repository)?
```
