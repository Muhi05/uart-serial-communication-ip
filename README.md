# UART – Serial Communication IP

## Description
A Universal Asynchronous Receiver Transmitter (UART) IP core
designed in Verilog HDL for use in SoCs and embedded systems.

## Project Info
- **Difficulty:** Intermediate
- **Tech Used:** Verilog HDL
- **Tools:** JDoodle Online Verilog Compiler
- **Baud Rate:** 9600 | **Clock:** 50 MHz

## Modules
| Module | Description |
|--------|-------------|
| `baud_rate_gen.v` | Generates baud tick at 9600 baud |
| `uart_tx.v` | UART Transmitter (FSM-based) |
| `uart_rx.v` | UART Receiver (FSM-based) |
| `uart_top.v` | Top-level integration module |
| `tb_uart_loopback.v` | Loopback testbench |

## FSM States
IDLE → START → DATA (8 bits) → STOP → IDLE

## Simulation Results
All 5 loopback tests passed ✅
- 'H' (0x48) ✅
- 'i' (0x69) ✅
- 0xFF ✅
- 0x00 ✅
- 'A' (0x41) ✅

## Learning Outcomes
- UART protocol understanding
- FSM-based RTL design
- Timing analysis and debug
