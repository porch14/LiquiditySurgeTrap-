# 🚨 LiquiditySurgeTrap (Drosera Proof of Concept)

## 💡 Overview

This project implements a critical decentralized security monitor, or **"trap,"** built on the Drosera infrastructure. Its core function is to continuously watch a specific Decentralized Exchange (DEX) liquidity pool for **sudden, significant surges in a token's balance**.

This is crucial for identifying activity that might signal **market manipulation**, a major token deposit before a large sale, or other unusual on-chain behavior that requires immediate attention and flagging.

-----

## 🎯 Key Features & Functionality

  * **Real-time Surveillance:** Monitors the reserve balance of the specified token within the target pool on a block-by-block basis.
  * **Surge Detection:** Triggers a flag when the token balance increases beyond a defined threshold within a short time window.
  * **Decentralized Security:** Leverages the Drosera network for secure, decentralized execution, ensuring reliability and auditability.
  * **Separation of Concerns:** Clearly demonstrates the separation of detection logic (the Trap) and the response action (the Responder contract).

-----

## 📂 Project Architecture

  * `src/LiquiditySurgeTrap.sol`: The smart contract containing the core, deterministic logic to analyze pool balances and detect surges.
  * `src/SimpleResponder.sol`: The external contract called by the Drosera operator network to execute a flag or response action when the surge condition is met.
  * `drosera.toml`: The configuration file for the Drosera network, setting parameters like block sampling and operator requirements.

-----

## 🧠 Core Detection Logic: `shouldRespond()`

The `shouldRespond()` function is the heart of the Trap. Its logic is executed **off-chain by multiple decentralized operators** to reach a consensus, meaning it must be **deterministic** (`view` function).

It compares the current token balance in the pool against the last confirmed balance to identify a "surge."

```solidity
// This deterministic function is the consensus mechanism for the trap trigger.
function shouldRespond(bytes[] calldata data) external view returns (bool, bytes memory) {
    // Decode the most recent (data[0]) and the previous (data[data.length - 1]) readings.
    CollectOutput memory current = abi.decode(data[0], (CollectOutput));
    CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));

    // Guardrail: Cannot calculate an increase if the past balance is zero.
    if (past.tokenBalance == 0) return (false, bytes(""));

    // Calculate the absolute increase in the monitored token's balance.
    // This value indicates the size of the liquidity deposit.
    uint256 increase = (current.tokenBalance - past.tokenBalance);

    // CRITICAL THRESHOLD: Flag if the increase is greater than 1 ETH (1e18 Wei).
    if (increase > 1e18) {
        // Condition met: Return true to signal a necessary response action.
        return (true, bytes(""));
    }

    // No significant surge detected.
    return (false, bytes(""));
}
```

-----

## 🧪 Implementation Summary

| Detail | Value/Description |
| :--- | :--- |
| **Monitored Pool** | `0x0000000000000000000000000000000000000000` |
| **Monitored Token** | Dexter Token (`0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1`) |
| **Surge Threshold**| Fixed at $\boldsymbol{1 \text{ ETH (or } 10^{18} \text{ Wei)}}$ increase. |
| **Response** | Calls the `SimpleResponder.sol` contract to log and flag the event. |

-----

## 🔨 Testing and Verification

To ensure the logic operates correctly and deterministically, you can use Foundry's powerful testing tools:

```bash
forge test --match-contract LiquiditySurgeTrap
```

This command runs local tests to verify that the `shouldRespond()` function correctly flags a surge when the threshold is exceeded and remains silent when it is not.
