# Erudite: Word Game Program

**Erudite** is a multiplayer word game where players compete to score points by forming valid words from a limited set of letters. 

## Table of Contents
  - [Game Rules](#game-rules)
  - [Initialization](#initialization)
  - [Gameplay Instruction](#gameplay-instruction)
  - [Bonuses](#bonuses)
  - [Game End](#game-end)
  - [Features](#features)
  - [How to Run](#how-to-run)
  - [Author](#author)
  - [License](#license)

---

## Game Rules

### Initialization
1. A **letter bank** is created, consisting of a 4 times larger alphabet (Russian or English).
2. A **dictionary of valid words** is generated programmatically. The dictionary can be expanded during the game.
3. The number of players is requested(from 2 to 5), and each player is given a **set of 10 random letters** from the letter bank.

### Gameplay Instruction
1. Players take turns making a word from the 10 letters given to them
2. **Scoring**:
   - A valid word:
     - Must exist in the dictionary.
     - Must be formed using letters from the player's set (letters cannot be reused).
     - Awards points equal to the number of letters in the word.
     - If the word starts with the last letter of the previous player's word, the score doubles.
   - An invalid word:
     - Subtracts points from the length of the entered word.
     - The player's letters are not removed.
3. **Letter Usage**:
   - Valid words: Used letters are removed from the player's set.
   - Invalid words: Letters remain in the player's set.
4. **Refilling Letters**:
   - If the player has less than 10 letters, he will receive additional letters from the letter bank.
5. **Skipping a Turn**:
   - Players can skip their turn by entering an empty string. 
   - Points will not be deducted.

### Bonuses
Each player can use the following bonuses once per game:
- **"50-50"**:
  - Replace up to 5 unwanted letters with random letters from the letter bank.
  - Subtracts 2 points.
- **"Friend's Help"**:
  - Swap one letter from your set with a letter from another player's set.
  - Points are not deducted.
  - The user selects the letter he wants to exchange, the player, and which player`s letter he is exchanging

### Game End
  - The game ends when all players skip their turn.
  - The winner is the player with the highest total score.

---

## Features
  - Dynamic expansion of the word dictionary during gameplay.
  - Bonuses for interesting gameplay.
  - Support Russian and English languages.

---

## How to Run


---

## Author
This program was being developed by: 
  - **Pavel Ivanov**
  - **Belkevich Konstantin**
  - **Koval Daniil**
  - **Rak Igor**
  - **Redko Anton** 
  - **Baranovskiy Konstantin**
  - **Rublesvkaya Kseniya**
  - **Romanovksaya Darya**
---

## License
This project is licensed under the OsipSoft Technology.

