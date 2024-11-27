// Copyright 2023 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
#![no_main]
use risc0_zkvm::guest::env;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Village {
    x: u8,
    y: u8,
    village_type: u8,
    elixir: u64,
    defense: u64,
    owner: [u8; 20],
    is_revealed: bool,
}

#[derive(Serialize, Deserialize)]
struct ActionInput {
    player: [u8; 20],
    action_type: u8,
    from_x: u8,
    from_y: u8,
    to_x: u8,
    to_y: u8,
    elixir_amount: u64,
    from_village: Village,
    to_village: Village,
}

risc0_zkvm::guest::entry!(main);

pub fn main() {
    // Read the input
    let input: ActionInput = env::read();
    
    // Verify the move is valid
    assert!(verify_move(&input), "Invalid move");
    
    // Commit the result
    env::commit(&true);

    // TODO: Check if I should commit the result instead
    // env::commit(&input);

    // Write the new state to the environment (for proof generation)
    // env::write(input.to_village);
    // env::write(new_elixir);
    // env::write(new_defense);
    // env::write(new_owner);
}

fn verify_move(input: &ActionInput) -> bool {
    // Check if villages are adjacent
    if !is_adjacent(input.from_x, input.from_y, input.to_x, input.to_y) {
        return false;
    }

    // Check if source village belongs to player
    if input.from_village.owner != input.player {
        return false;
    }

    // Check if elixir amount is within limits
    if input.elixir_amount > (input.from_village.elixir * 80) / 100 {
        return false;
    }

    match input.action_type {
        0 => verify_conquer(input),
        1 => verify_reinforce(input),
        _ => false,
    }
}

fn verify_conquer(input: &ActionInput) -> bool {
    // Check if attack power exceeds defense
    input.elixir_amount > input.to_village.defense
}

fn verify_reinforce(input: &ActionInput) -> bool {
    // Check if target village belongs to player
    input.to_village.owner == input.player
}

fn is_adjacent(x1: u8, y1: u8, x2: u8, y2: u8) -> bool {
    (x1 == x2 && (y1 == y2.wrapping_add(1) || y1 == y2.wrapping_sub(1))) ||
    (y1 == y2 && (x1 == x2.wrapping_add(1) || x1 == x2.wrapping_sub(1)))
}
