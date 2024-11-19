
# Dark Forest zkVM Implementation

A minimal implementation of the Dark Forest game (zkga.me) designed to run on zkVMs like RISC Zero.

## Overview

This project provides a simplified version of the Dark Forest game mechanics implemented to work with zero-knowledge virtual machines. It focuses on the core game mechanics while maintaining privacy and verifiability of player actions. This is to allow builders to experiment with the game mechanics and create their own implementations.

### Features

- Minimal Dark Forest game mechanics
- Compatible with RISC Zero zkVM
- Zero-knowledge proofs for game moves (state updates)
- Minimal implementation for easy understanding and extension

### Game Mechanics (WIP)

The implementation includes:
- Planet generation and discovery
- Resource management
- Movement and conquest mechanics
- Basic scoring system

### Zero-Knowledge Components (WIP)

- Planet discovery proofs
- Move validity verification
- Resource calculation proofs
- Territory control verification

## Requirements

- Rust toolchain
- RISC Zero toolkit or Bonsai API key.

## Getting Started

1. Clone the repository
2. Install dependencies

cargo install --path .

3. Run the zkVM implementation

cargo run


## Contributing

Contributions are welcome! Please feel free to submit pull requests.

## License

MIT License

## Acknowledgments

- Original Dark Forest game (zkga.me)
- RISC Zero team
- Zero-knowledge cryptography community

## Security Considerations

This is an experimental implementation. Use at your own risk and review the code before deploying in production environments.
