# UART Communication Project (SystemVerilog)

## 📌 Overview

This project implements a **UART (Universal Asynchronous Receiver Transmitter)** communication system using **SystemVerilog**, with complete **RTL design, simulation, debugging, and synthesis**.

The design includes:

- **UART Transmitter (TX)**
- **UART Receiver (RX)** with **16× oversampling**
- **Loopback configuration** for self-test
- **ModelSim** for RTL simulation
- **Quartus Prime** for synthesis

## 🗂 Project Structure

```
UART_Comm_VLSI/
|
│── uart_if.sv              # UART interface definition
│── Uart_Transmitter.sv     # UART TX RTL
│── Uart_Receiver.sv        # UART RX RTL (16× oversampling)
│── Uart_Interface.sv       # Top module with loopback
│
│── tb_uart_comm.sv         # Common UART testbench
│
│—— snapshots folder
└── README.md
```

## UART Parameters

| **Parameter** | **Value** |
| --- | --- |
| Clock Frequency | 50 MHz |
| Baud Rate | 115200 |
| Oversampling | 16× |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |

## UART (Universal Asynchronous Receiver Transmitter)

UART is a **serial communication protocol** used for asynchronous data transfer between digital systems.

It does **not use a shared clock**; instead, both transmitter and receiver operate at a **pre-agreed baud rate**.

### UART Frame Format

A standard UART frame consists of:

- **Start bit** (logic 0)
- **Data bits** (typically 8, LSB first)
- **Optional parity bit**
- **Stop bit(s)** (logic 1)

The receiver detects the start bit, samples the data bits at precise time intervals, and reconstructs the transmitted byte.

UART is widely used due to its **simplicity, low hardware cost, and reliability** in short-distance communication.

## Loopback in UART

Loopback is a **self-test mechanism** where the UART transmitter output **(TX)** is directly connected to the receiver input **(RX)**.

### Purpose of Loopback

- Verifies **TX and RX functionality together**
- Allows **internal testing without external hardware**
- Commonly used during **RTL validation and bring-up**

Loopback does not represent real communication but is a **standard verification technique** in UART design.

## Oversampling in UART

Oversampling is a technique where the UART receiver samples the incoming serial data **multiple times per bit period**, commonly **16× the baud rate**.

### Why Oversampling Is Used

- Improves **sampling accuracy**
- Compensates for **clock mismatch** between TX and RX
- Reduces sensitivity to **noise and jitter**

The receiver typically samples at the **middle of the bit period**, where the signal is most stable.

---

## Step-by-Step Project Flow (Quartus → ModelSim)

### 1. Create Project in Quartus Prime

1. Open **Quartus Prime**
2. Click **File → New Project Wizard**
3. Click **Next**

**Project Details**

- **Working directory:** `UART_Comm_VLSI`
- **Project name:** `uart_comm`
- **Top-level entity:** `Uart_Interface`
- Click **Next**

### 2. Add Design Files (RTL Only)

Add only synthesizable RTL files:

```
uart_if.sv
uart_transmitter.sv
uart_receiver.sv
uart_top.sv
```

> ⚠️ **Do NOT add testbench files here**
> 

Click **Next**

### 3. Select Device

- Choose appropriate FPGA family (e.g., Cyclone IV / Cyclone V)
- Select any available device if no board is used
- Click **Next → Next → Finish**

### 4. Set HDL Language

1. Go to **Assignments → Settings**
2. Select **Analysis & Synthesis**
3. Set **HDL language = SystemVerilog**
4. Click **OK**

### 5. Compile RTL (Synthesis)

- Click **Start Compilation**
- Ensure **no errors**
- Successful compilation confirms synthesizable RTL

### 6. Configure ModelSim Tool

1. Go to **Tools → Options → EDA Tool Options**
2. Set **ModelSim path** (example):

```
C:\intelFPGA\20.1\modelsim_ase\win32aloem
```

1. Click **OK**

### 7. Add Testbench for Simulation

1. Go to **Assignments → Settings → Simulation**
2. Click **Test Benches…**
3. Click **New**

**Testbench Settings**

- **Test bench name:** `tb_uart_comm`
- **Top-level module:** `tb_uart_comm`

**Add Testbench File**

Add: `tb_uart_[comm.sv](http://comm.sv)`

Click **OK → OK**

### 8. Launch ModelSim from Quartus

- Go to **Tools → Run Simulation Tool → RTL Simulation**
- ModelSim opens automatically

### 9. Compile Files in ModelSim

In ModelSim **Transcript window**:

```
vlib work
vlog uart_if.sv
vlog uart_transmitter.sv
vlog uart_receiver.sv
vlog uart_top.sv
vlog tb_uart_comm.sv
```

### 10. Run Simulation with Automatic Waves

```
add wave uart.clk
add wave uart.transmit
add wave uart.busy
add wave uart.TxD
add wave uart.RxD
add wave uart.valid_rx
add wave uart.TxData
add wave uart.RxData

run -all
```

This will:

- Add all required wave signals
- Run the simulation automatically
- Stop at `$finish`

### 11. Expected Simulation Output

```
[TX] Sending=A
[TB] Sent=A  Received=A
[TX] Sending=I
[TB] Sent=I  Received=I
...
=== TEST COMPLETED ===
```

This confirms:

- UART TX operation
- UART RX with 16× oversampling
- Correct loopback communication

### 12. Waveform Verification

Verify the following signals in ModelSim waveform window:

- `uart.clk`
- `uart.transmit`
- `uart.busy`
- `uart.TxD`
- `uart.RxD`
- `uart.valid_rx`
- `uart.TxData`
- `uart.RxData`

Waveforms should show:

- Start bit ( `0` )
- 8 data bits (LSB first)
- Stop bit ( `1` )
- Correct mid-bit sampling in RX

### 13. End of Simulation

Simulation ends automatically using:

```
$finish;
```

No manual termination required.

---

## 📸 Project Snapshots

The `snapshots/` directory contains waveform captures, Quartus compilation reports, and synthesized netlist representations for verification and reference.

---

## 👤 Author

**Aishwarya Suryawanshi**

LinkedIn: [Aishwarya Suryawanshi | LinkedIn](https://www.linkedin.com/in/aishwarya-suryawanshi-aa20ba27a/)
