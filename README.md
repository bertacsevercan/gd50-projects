# GD50-Projects

The assignments completed during the Harvard's GD50: Intro to Game Development course.

**Disclaimer**  
All projects include base source code written by the course instructor **Colton Ogden**. I added the assignments and my own implementations on top of the original code.

---

## Lesson 1 - Pong

A classic Pong recreation built with Lua and LÖVE2D. This lesson focuses on fundamentals like drawing, game state handling, simple physics, and implementing basic AI logic.

![pong](https://github.com/user-attachments/assets/ce220d8d-360b-47c7-ac20-9bd0d5c5732e)

---


### Topics Covered

- Lua
- LÖVE2D
- Drawing Shapes
- Drawing Text
- Delta Time & Velocity
- Game State Management
- Basic OOP
- Box Collision (Hitboxes)
- Sound Effects (bfxr)

---

### Original Assignment

- [x] Implement a basic AI for either Player 1 or Player 2 (or both).

---

### What I Implemented

-  [x] Completed the assignment as required.
- [x] Implemented AI for **both** players.
- [x] Added an **autoplay toggle**: both AIs can play against each other with no player input.
- [x] Added an **AI mistake chance** to mimic human inaccuracy.
- [x] Implemented logic for AI to **serve the ball away from the opponent**.
- [x] Added **full controls** for both players so two humans can play.
- [x] You can play against the AI on either side, and take control of an AI mid-autoplay. Autoplay shuts off only for the player you overwrite.
- [x] The ball changes color (to red) based on a random velocity value.

---

### Extra Ideas

- Power-ups:
  - Speed up the ball
  - “Power ball” that can’t be blocked
  - Multiple balls (ball multiplication)
  - Paddle speed modifiers (slow down / speed up paddles)

---

## Lesson 2 — Flappy Bird

A Flappy Bird clone featuring procedural pipe generation, infinite scrolling backgrounds, game states, and performance-based rewards.

![flappy](https://github.com/user-attachments/assets/c04c01d6-3d92-43ec-9380-4d6893aeeec5)

---

### Topics Covered

- Sprites  
- Infinite Scrolling  
- Procedural Generation  
- State Machines

---

### Original Assignment

- [x] Influence the generation of pipes to create more complex level patterns.  
- [x] Award the player a medal based on performance, along with their score.  
- [x] Implement a pause feature.

---

### What I Implemented

- [x] Completed all assignment requirements.
- [x] Added different sound effects for different medal results.

---

### Extra Ideas

- A dynamic commentator system that reacts to your performance (e.g., praise, insults, hype commentary).

---

## Lesson 3 — Breakout

A Breakout clone featuring procedural level layouts, multiple powerups, particle effects, paddle upgrades, collision handling, and persistent save data.

![breakout](https://github.com/user-attachments/assets/c2592e92-d522-4413-a2b9-6d26a15ad446)

---

### Topics Covered

- Sprite Sheets  
- Procedural Layouts  
- Managing State  
- Levels  
- Player Health  
- Particle Systems  
- Collision Detection  
- Persistent Save Data

---

### Original Assignment

- [x] Add a powerup that spawns two extra balls.  
- [x] Grow or shrink the paddle based on score increases or life loss.  
- [x] Add a locked brick that can only be opened with a key powerup, which should spawn only when such a brick exists and randomly like the ball powerup.

---

### What I Implemented

- [x] Fixed the `recoverPoints` bug.  
- [x] Implemented logic to spawn a key again if it is lost.  
- [x] Added seven total powerups: multiple balls, bigger ball, smaller ball, big paddle, small paddle, fast paddle, slow paddle.  
- [x] When multiple balls exist, the player only loses health when **all** balls are destroyed.  
- [x] Each brick has a random chance to contain a powerup.  
- [x] When a brick breaks, it drops its assigned powerup if it has one.  
- [x] Display on-screen text to indicate which powerup was picked up.  
- [x] Implemented level saving and added the ability to continue from the last saved level.

---

## Lesson 4 — Match 3

A Match-3 puzzle game featuring animated tile movement, procedural grid generation, timed gameplay, shiny tile mechanics, variety-based scoring, and hint assistance.

![match3](https://github.com/user-attachments/assets/248d9b24-f0a2-4813-9583-f73d6f1c1a82)


---

### Topics Covered

- Anonymous Functions  
- Tweening  
- Timers  
- Procedural Grids  
- Sprite Art and Palettes

---

### Original Assignments

- [x] Ensure Level 1 starts with simple flat blocks (first row of each color in the sprite sheet).  
      Later levels should include patterned blocks (triangle, cross, etc.) worth more points.  
- [x] Add time on match: +1 second per matched tile.  
- [x] Add shiny tiles that destroy an entire row when matched, awarding points for every tile in the row.  
- [x] Only allow swapping if it results in a valid match.  
      If no possible matches remain, reset the board.

---

### What I Implemented

- [x] Fixed the `setColor` bug.  
- [x] Introduced a new **color** every 3 levels and a new **variety** every 4 levels.  
- [x] Added optional mouse-based matching.  
- [x] Added particle effects on shiny tile matches.  
- [x] Implemented a **hint system** when the player is stuck (up to 3 hints max).  
- [x] Matching now checks **both color and variety**, not just color alone.
- [x] Disable input when hint is active.

---

## Lesson 5 — Super Mario Bros

A procedurally generated 2D platformer inspired by Super Mario Bros, featuring tile-based worlds, animated entities, platformer physics, keys and locks, goal posts, powerups, enemies, camera movement, and scalable level progression.

![mario](https://github.com/user-attachments/assets/19bf53d1-33a5-46e0-99f6-96b95633c9d5)


---

### Topics Covered

- Tile Maps  
- 2D Animation  
- Procedural Level Generation  
- Platformer Physics  
- Basic AI  
- Powerups

---

### Original Assignments

- [x] Ensure the player always spawns above solid ground when entering the level.  
- [x] In `LevelMaker.lua`, generate a random-colored key and matching lock block (from `keys_and_locks.png`).  
      Colliding with a key should unlock the block and make it disappear.  
      *(I generate 4 collectible keys and show collected keys on screen.)*  
- [x] Once the lock has disappeared, trigger a goal post to spawn at the end of the level.
   Goal posts can be found in flags.png; feel free to use whichever one you’d like! 
   Note that the flag and the pole are separated, so you’ll have to spawn a
   GameObject for each segment of the flag and one for the flag itself.
   *(I spawn a gameobject as a pole and spawn an entity as the flag since its animated)*
- [x] Touching the goal post regenerates the level, restarts the player at the beginning,  
      increases the level length, and preserves score via parameters passed into `PlayState:enter`.  
      *(When the player unlocks the locks the camera moves to the flag and show that its up)*

---

### Additions I Implemented

- [x] Camera pan to the goal flag at the start of each level.  
- [x] Player becomes invincible while the camera is moving.  
- [x] Camera pan can be skipped with the Enter key.  
- [x] Added randomly generated water tiles.  
- [x] Fixed snail jitter when it has no room to move.  
- [x] Corrected the player collision box (original was too large).  
- [x] Added a red mushroom power-up for health restoration  
      (max hearts = 3; extra health converts to score).  
- [x] Added visual health bars using heart icons.  
      The player cannot die unless all hearts are depleted.

---

### Extra Ideas

- Climbing state for ascending the flag pole.  
- Ladder tiles for climbing tall structures.  
- Two new enemy types.  
- A mushroom power-up granting temporary invincibility.

---
