# UART Controller with 16x Oversampling 

A high-reliability UART (Universal Asynchronous Receiver-Transmitter) implementation in Verilog. This project features a modular architecture designed for FPGA deployment, utilizing an oversampling receiver to ensure robust data recovery and noise immunity.

##  Architecture Overview
The controller is divided into four distinct modules to ensure high maintainability and testability:

* **`baud_generator.v`**: A parameterized clock divider that generates the precise timing pulses for transmission and reception.
* **`uart_tx.v`**: A Finite State Machine (FSM) that serializes 8-bit parallel data into a standard UART frame (1 Start bit, 8 Data bits, 1 Stop bit).
* **`uart_rx.v`**: A sophisticated receiver FSM that uses **16x oversampling**. It identifies the start bit and samples the data at the 8th tick (the precise center of the bit) to maximize reliability.
* **`uart_top.v`**: The top-level structural wrapper that interconnects the sub-modules and manages the dual-clock domain (1x baud tick for TX, 16x for RX).

## 🛠️ Technical Specifications
| Parameter | Value |
|-----------|-------|
| **Clock Frequency** | 50 MHz (Default) |
| **Baud Rate** | 9600 bps (Parameterized) |
| **Oversampling** | 16x (Receiver side) |
| **Data Format** | 8-N-1 (8 Data, No parity, 1 Stop) |
| **HDL** | Verilog-2001 |

##  Verification & Simulation
The design has been verified via **Serial Loopback Testing** in **IcarusVerilog*. In this test, the `tx_serial` output is directly tied to the `rx_serial` input within the testbench.

**Simulation Results:**
1.  Transmitted Data: `0xA5` (Binary: `10100101`).
2.  The Receiver successfully detected the start bit, waited 8 ticks to hit the center, and sampled the subsequent bits correctly.
3.  `rx_done` flag asserted upon successful reception of the Stop bit, updating the `rx_data` output.
4.  **Result:** Data Match Confirmed.

<img width="1649" height="495" alt="Screenshot 2026-03-12 234944" src="https://github.com/user-attachments/assets/7be4bbfc-4323-4062-ae12-b9ba8dbc1dd1" />

<img width="1652" height="490" alt="Screenshot 2026-03-12 235010" src="https://github.com/user-attachments/assets/edbe787c-7838-4a27-b75d-c25d2017b3ab" />


