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

use risc0_zkvm::guest::env;

fn main() {
    // Load inputs from the environment
    let village_id: u32 = env::read();
    let current_energy: u32 = env::read();
    let current_defense: u32 = env::read();
    let owner: String = env::read();
    let action: String = env::read(); // e.g., "attack" or "reinforce"
    let action_energy: u32 = env::read();

    // Compute the new state based on the action
    let mut new_energy = current_energy;
    let mut new_defense = current_defense;
    let mut new_owner = owner.clone();

    match action.as_str() {
        "attack" => {
            if action_energy > current_defense {
                new_energy = action_energy - current_defense;
                new_defense = 0;
                new_owner = "new_player".to_string(); // TODO: replace with new owner address
            } else {
                new_defense -= action_energy;
            }
        }
        "reinforce" => {
            new_energy += action_energy;
        }
        _ => {}
    }

    // Prove correctness of the computation
    // risc0_zkvm::prove(new_state);
    
    // Write the new state to the environment (for proof generation)
    env::write(village_id);
    env::write(new_energy);
    env::write(new_defense);
    env::write(new_owner);
}

