To run this program, install processing: https://processing.org\
After opening the app, select file > open,
navigate to the folder maze_automove, and open maze_automove.pde.
Click the run button, and the program would start.

This program simulates a maze search using two graph traversal algorithms: 
DFS (depth-first search), and BFS (breadth-first search).

The buttons on the right, from top to bottom, allows users to:
1. switch between the algorithms used (set to DFS as default),
2. randomly change the starting position,
3. randomly generate a new maze (after which the starting position is reset to the bottom left), 
4. pause the search, and
5. start the search.

After the program starts, it runs until:
1. the user pauses the program, after which the user can resume it, or
2. the red character meets the monster (at which point is is considered defeated)

Explanation of algorithms used:
DFS: at each intersection the character chooses one path to go, and then explores until it hits a dead end, at which point it returns to the last intersection, and choose another path untaken.

BFS: At each intersection the character does not choose one path to explore. Instead, it moves between the points equidistant to the intersection, exploring all different paths at the same time.