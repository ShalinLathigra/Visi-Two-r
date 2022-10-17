# TLDR
## Goals
- Player actions can be undone w/ backspace or ctrl-z
- Enemies should have their own queue of actions that they are going to take on their turn
- They generate this list at the END of their previous turn, this info is shared with the
player visually
- Player stores the set of actions taken, can move back and forth through the list while on it's turn.
- Game turns the encounter on and off, same w/ player controller.
