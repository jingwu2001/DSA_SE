# DSA Software Engineering Group 34

## Introduction
This program simulates a maze search using two graph traversal algorithms: 
DFS (depth-first search), and BFS (breadth-first search).

## Environment Setting
To run this program, install processing: https://processing.org/download.
In linux, simply run 
```bash
sudo snap install processing
```

After opening the app, select file > open,
navigate to the folder maze_automove, and open `maze_automove.pde`.
Click the upper left run button, and the program would start.

## Usage
The buttons on the right, from top to bottom, allows users to:
1. **DFS/BFS**: switch between the algorithms used (set to DFS as default),
2. **Random Pos**: randomly change the starting position,
3. **Reset**: randomly generate a new maze, 
4. **Pause**: pause the search, and
5. **Start**: start the search.

After the program starts, it runs until:
1. the user pauses the program, after which the user can resume it, or
2. the red character meets the monster (at which point is is considered defeated)

## Implementation Logic
### DFS
At each intersection the character chooses one path to go, and then explores until it hits a dead end, at which point it returns to the last intersection, and choose another path untaken.

### BFS
At each intersection the character does not choose one path to explore. Instead, it moves between the points equidistant to the intersection, exploring all different paths at the same time.


## Example
Give the following graph represented as adjacency lists:\
A: [B, C]\
B: [D, E]\
C: [F]\
D: []\
E: []\
F: []

The traversals would be\
BFS: A -> B -> C -> D -> E -> F\
DFS: A -> B -> D -> E -> C -> F

## Demo
Here's a video demo of the project: https://youtu.be/yfMud1MOXF0