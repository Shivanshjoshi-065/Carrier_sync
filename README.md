# QPSK Carrier Synchronizer in Verilog HDL
# Overview
This project implements a QPSK Carrier Synchronizer in Verilog HDL for FPGA-based digital communication systems.
The receiver is designed to recover the carrier of a QPSK-modulated signal using a Costas Loop and Numerically Controlled Oscillator (NCO). The implementation operates with a 64 MHz sampling clock and an 8 MHz carrier frequency. 

The transmitter generates a QPSK signal using:
•	PRBS Generator 
QPSK Symbol Mapper
•	Numerically Controlled Oscillator (NCO)
•	I/Q Modulator

The receiver consists of:
•	Automatic Gain Control (AGC)
•	Carrier Synchronizer (Costas Loop)
•	Low-Pass Filters
•	NCO for carrier recovery 

The AGC stabilizes the received signal amplitude using:
•	Power Estimation
•	Gain Error Calculation
•	Gain Accumulator
•	Gain Scaling 

The carrier synchronizer recovers the carrier phase and generates oversampled baseband I and Q signals.

# Tools Used
•	Verilog HDL 
• Xilinx ISE 13.x 
• Microchip Libero SoC 
• ModelSim / QuestaSim

# Simulation
The repository includes simulation waveforms demonstrating:
•	QPSK modulation
•	NCO sine and cosine generation
•	Mixer outputs
•	Low-pass filter outputs
•	AGC operation
•	Carrier recovery
•	Recovered baseband I/Q signals

