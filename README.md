# LiquiditySurgeTrap (Drosera Proof-of-Concept)

## Overview
The Liquidity Surge Trap monitors liquidity levels in a specific pool and triggers actions when significant liquidity increases are detected. This is critical for ensuring optimal liquidity management in trading environments.

---

## What It Does
* Monitors the liquidity levels in the specified pool.
* Triggers if the liquidity increases by more than 1 ETH from the last confirmed reading.
* It demonstrates the essential Drosera trap pattern using deterministic logic.

---

## Key Files
* `src/LiquiditySurgeTrap.sol` - The core trap contract containing the monitoring logic.
* `src/SimpleResponder.sol` - The required external response contract.
* `drosera.toml` - The deployment and configuration file.

---

## Detection Logic

The trap's core monitoring logic is contained in the deterministic `shouldRespond()` function.

solidity
// The AI MUST insert the full, syntax-highlighted Solidity code of the `shouldRespond()` logic here.
    CollectOutput memory current = abi.decode(data[0], (CollectOutput));
    CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
    if (past.tokenBalance == 0) return (false, bytes(""));
    uint256 increase = (current.tokenBalance - past.tokenBalance);
    if (increase > 1e18) return (true, bytes(""));
    return (false, bytes(""));
 

---

## 🧪 Implementation Details and Key Concepts
* **Monitoring Target:** Watching the liquidity levels in the pool at address 0x0000000000000000000000000000000000000000 and the Dexter Token 0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1.
* **Deterministic Logic:** Explains the use of the `view` or `pure` modifier. This logic is always executed off-chain by operators to achieve consensus before a transaction is proposed.
* **Calculation/Thresholds:** Uses a fixed 1 ETH increase threshold that drives the `shouldRespond()` function.
* **Response Mechanism:** On trigger, the trap calls the external Responder contract, demonstrating the separation of monitoring and action.

---

## Test It
To verify the trap logic using Foundry, run the following command (assuming a test file has been created):

bash
forge test --match-contract LiquiditySurgeTrap
