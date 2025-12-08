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

- Completed the assignment as required.
- Implemented AI for **both** players.
- Added an **autoplay toggle**: both AIs can play against each other with no player input.
- Added an **AI mistake chance** to mimic human inaccuracy.
- Implemented logic for AI to **serve the ball away from the opponent**.
- Added **full controls** for both players so two humans can play.
- You can play against the AI on either side, and take control of an AI mid-autoplay. Autoplay shuts off only for the player you overwrite.
- The ball changes color (to red) based on a random velocity value.

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

- Completed all assignment requirements.
- Added different sound effects for different medal results.

---

### Extra Ideas

- A dynamic commentator system that reacts to your performance (e.g., praise, insults, hype commentary).

---
