
<br />
<div align="center">
  <a href="https://github.com/daniel0ar/DarkForest-VM">
    <img src="images/logo.png" alt="Logo" width="auto" height="120">
  </a>

<h3 align="center">Village Unknown</h3>

  <p align="center">
    A minimal implementation of the Dark Forest game (zkga.me) designed to run on zkVMs like RISC Zero.
    <br />
    <a href="https://github.com/daniel0ar/DarkForest-VM/issues/new?labels=bug">Report Bug</a>
    ·
    <a href="https://github.com/daniel0ar/DarkForest-VM/issues/new?labels=enhancement">Request Feature</a>
  </p>
</div>

# I NEED HELP
I am having a **hard time** trying to understand the flow of an application like this. I am not a zkVM expert and concepts like **seal, journal, Bonsai, or Rust** in general are still a bit confusing. I would love to have people **join me** on building this.

## Overview

This project provides a simplified version of the Dark Forest game mechanics implemented to work with zero-knowledge virtual machines. It focuses on the core game mechanics while maintaining privacy and verifiability of player actions. This is to allow builders to experiment with the game mechanics and create their own implementations.

### Game Design
> TL;DR: It's like a very minimal Clash of Clash but private and verifiable. I designed this with my little understaing of the original Dark Forest game.

The game consists of villages in a deterministically generated medieval world (like Clash of Clans) where the player can conquer contiguous villages and get their resources, keeping the fog of war to just the next nearest neighbours, the strategic factor to gathering their elixir, and the winning condition to be majority of villages conquered.

The world map generates 100 villages and new players (up to 9) spawn in one random village (of type large) in a map of coordinates where villages of all types are placed randomly and no coordinate is left empty.

There are three types of villages: small, medium and large, and depending on the size the village is going to hold more or less elixir and have a base defense. 

A player can chose to do two actions on each turn, conquer or reinforce:

- To conquer a contiguous village the player has to send elixir from one of his villages to the desired one, and if the amount exceeds the defense of the planet it is conquered (even if its owned by another player), and the amount of elixir is deducted from the original village who sent it. 
- Reinforcing a village spends elixir from one of the contiguous villages to the desired one and increments the defense of the desired village by that same amount. 

A player can only conquer a contiguous village (this has to be proven legal on the guest program) and the smart contract cannot reveal where each player is at any time. Village state is also private and is only revealed to a specific player if the village is contiguous to the player (the player will request the info from the next villages from the frontend to the contract, and the contract will respond with this info only after having sent a verification request to the Risc0 ZKVM guest program, and getting a true result).

Only a portion of a village's current energy can be sent at a time to avoid depleting it completely.

### Features

- Minimal Dark Forest game mechanics
- Compatible with RISC Zero zkVM
- Zero-knowledge proofs for game moves (state updates)
- Minimal implementation for easy understanding and extension

### Game Mechanics (WIP)

The implementation includes:
- Village map generation and discovery
- Resource management
- Movement and conquest mechanics
- Basic scoring system

### Zero-Knowledge Components (WIP)

- Village discovery proofs
- Move validity verification
- Resource (elixir) calculation proofs (not ready)
- Territory control verification (not ready)

## Requirements

- Rust toolchain
- RISC Zero toolkit or Bonsai API key.

## Getting Started

1. Clone the repository
2. Install dependencies
```sh
cargo install --path .
```
3. Run the implementation (not working)
```sh
cargo run
```

## Contributing

Contributions are welcome! Please join this project if you like the game and are interested to learn about zkVMs.

## License

MIT License

## Acknowledgments

- Original Dark Forest game (zkga.me)
- RISC Zero team
- Zero-knowledge cryptography community