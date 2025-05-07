int [][] maze;
int success;
int mazeSize = 30;
int blockSize = 30;
int roomX = int(random(1, mazeSize - 6));
int roomY = int(random(1, mazeSize - 6));
PImage monster;
PImage monsterDefeated;
PImage monsterOriginal;
PImage playerUp, playerDown, playerLeft, playerRight;
String playerDir = "D";
int playerX = 0; // TODO: to be modified, range: 0 ~ mazeSize-1
int playerY = 29; // TODO: to be modified
int moveInterval = 5;
int lastMoveFrame = 0;

java.util.Deque<PVector> deque = new java.util.ArrayDeque<PVector>();
ArrayList<PVector> doorPositions = new ArrayList<PVector>();

boolean dfsFinished = false;
boolean hasPassedDoor = false;
boolean BFS = false; // TODO: to be modified
boolean isPaused=false;
boolean gameStarted = false;

//BUTTON SETUP
//100
int Alg_buttonX = 950;
int Alg_buttonY = 100-20;
int Alg_buttonW = 200;
int Alg_buttonH = 100;

//250
int random_buttonX = 950;
int random_buttonY = 250-20;
int random_buttonW = 200;
int random_buttonH = 100;

//400
int Reset_buttonX = 950;
int Reset_buttonY = 400-20;
int Reset_buttonW = 200;
int Reset_buttonH = 100;

//550
int Pause_buttonX = 950;
int Pause_buttonY = 550-20;
int Pause_buttonW = 200;
int Pause_buttonH = 100;

int Start_buttonX = 950+100;
int Start_buttonY = 800-20;
int Start_buttonW = 200;
int Start_buttonH = 200;

boolean Start_Pressed = false;
boolean Alg_Pressed = false;
boolean Reset_Pressed = false;
boolean Random_Pressed = false;
boolean Pause_Pressed = false;

void setup() {
  size(1200, 900, P3D);
  maze = new int[mazeSize][mazeSize];
  monsterOriginal = loadImage("monster.png");
  monsterDefeated = loadImage("monster_defeated.png");
  monster=monsterOriginal;
  playerUp = loadImage("player_u.png");
  playerDown = loadImage("player_d.png");
  playerLeft = loadImage("player_l.png");
  playerRight = loadImage("player_r.png");

  initMaze();
  go(playerX, playerY);
  deque.push(new PVector(playerX, playerY));
  noStroke();
}

void draw() {
  background(230, 245, 216);


  for (int x = 0; x < mazeSize; x++)
  {
    for (int y = 0; y < mazeSize; y++)
    {
      switch (maze[x][y]) {
      case 0:
        fill(230, 245, 216);//background
        break;
      case 1:
        fill(67, 133, 113);//wall
        break;
      case 5:
        fill(78, 156, 154);//room
        break;
      case 6:
        fill(200, 55, 55);
        break; // door
      case 8:
        fill(255, 247, 212);//pass
        break;
      case 9:
        fill(234, 171, 145);//return road
        break;
      default:
        fill(241,248,243);//road
        break;
      }
      rect(x * blockSize, y * blockSize, blockSize, blockSize);
    }
  }
  //buttom
  draw_button();

  // monster picture
  imageMode(CENTER);
  image(monster, (roomX + 3) * blockSize, (roomY + 3) * blockSize, 4 * blockSize, 4 * blockSize);

  // draw character
  //fill(255, 0, 0);
  //ellipse(playerX * blockSize+15, playerY * blockSize+15, blockSize, blockSize);
  imageMode(CENTER);
  PImage img;
  if (playerDir.equals("U")) img = playerUp;
  else if (playerDir.equals("D")) img = playerDown;
  else if (playerDir.equals("L")) img = playerLeft;
  else img = playerRight;

  image(img, playerX * blockSize + blockSize/2, playerY * blockSize + blockSize/2, blockSize, blockSize);


  if (isPaused)
  {
    fill(255, 133, 113, 220);
    rectMode(CENTER);
    rect(width / 2, height /2, 300, 180, 10);
    fill(255);
    textSize(56);
    text("Paused", width / 2, height /2-10);
    rectMode(CORNER);
    return; // 停止更新遊戲狀態
  }
  if (!gameStarted)
  {
    return; // 尚未開始遊戲，不執行下方邏輯
  }

  // DFS move
  if (!dfsFinished) {
    if (deque.size() == 0) {
      dfsFinished = true;
      return;
    }

    if (frameCount - lastMoveFrame >= moveInterval) {
      lastMoveFrame = frameCount;
      PVector current = deque.peek();
      int cx = int(current.x);
      int cy = int(current.y);
      playerX = cx;
      playerY = cy;

      for (PVector door : doorPositions) {
        if (playerX == int(door.x) && playerY == int(door.y)) {
          hasPassedDoor = true;
        }
      }

      if (hasPassedDoor &&
        playerX >= roomX && playerX < roomX + 6 &&
        playerY >= roomY && playerY < roomY + 6) {
        dfsFinished = true;
        deque.clear();
        return;
      }

      boolean moved = false;
      int[] dx = {0, 1, 0, -1};
      int[] dy = {-1, 0, 1, 0};
      Integer[] dirs = {0, 1, 2, 3};
      // java.util.Collections.shuffle(java.util.Arrays.asList(dirs));

      for (int d = 0; d < 4; d++) {
        int i = dirs[d];
        int nx = playerX + dx[i];
        int ny = playerY + dy[i];

        if (nx >= 0 && ny >= 0 && nx < mazeSize && ny < mazeSize &&
          maze[nx][ny] != 1 && maze[nx][ny] != 8 && maze[nx][ny] != 9) {

          if (maze[nx][ny] == 5 && !hasPassedDoor) {
            continue;
          }
          // 判斷方向
          if (dx[i] == 0 && dy[i] == -1) playerDir = "U";
          else if (dx[i] == 1 && dy[i] == 0) playerDir = "R";
          else if (dx[i] == 0 && dy[i] == 1) playerDir = "D";
          else if (dx[i] == -1 && dy[i] == 0) playerDir = "L";
          if (BFS)
          {
            deque.addLast(new PVector(nx, ny));
          } else
          {
            deque.push(new PVector(nx, ny));
          }
          maze[nx][ny] = 8;
          moved = true;
          break;
        }
      }

      if (!moved) {
        maze[playerX][playerY] = 9;
        deque.pop();
      }
    }
  }

  // finish banner
  if (dfsFinished) {
    monster = monsterDefeated;
    //fill(0);
    //textSize(20);
    //text("Success!", 20, 30);
  }
}
void draw_button()
{
  //BUTTON DRAW
  // 畫出按鈕
  if (!Start_Pressed) fill(200, 133, 113);
  else fill (255, 133, 113);
  ellipse(Start_buttonX, Start_buttonY, Start_buttonW, Start_buttonH); // 圓角按鈕
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(48);
  //text("Start", Start_buttonX + Start_buttonW/2, Start_buttonY + Start_buttonH/2);
  text("Start", Start_buttonX, Start_buttonY-10);

  if (!Alg_Pressed) fill(200, 133, 113);
  else fill (255, 133, 113);
  rect(Alg_buttonX, Alg_buttonY, Alg_buttonW, Alg_buttonH, 10); // 圓角按鈕
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);

  if (!Reset_Pressed) fill (200, 133, 113);
  else fill (255, 133, 113);
  rect(Reset_buttonX, Reset_buttonY, Reset_buttonW, Reset_buttonH, 10); // 圓角按鈕
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Reset", Reset_buttonX + Reset_buttonW/2, Reset_buttonY + Reset_buttonH/2);

  if (!Random_Pressed)
  {
    fill(200, 133, 113);
  } else fill (255, 133, 113);
  rect(random_buttonX, random_buttonY, random_buttonW, random_buttonH, 10); // 圓角按鈕
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Random Pos", random_buttonX + random_buttonW/2, random_buttonY + random_buttonH/2);

  if (!Pause_Pressed)
    fill(200, 133, 113);
  else
    fill(255, 133, 113);

  rect(Pause_buttonX, Pause_buttonY, Pause_buttonW, Pause_buttonH, 10);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(28);

  if (isPaused) {
    text("Resume", Pause_buttonX + Pause_buttonW/2, Pause_buttonY + Pause_buttonH/2);
  } else {
    text("Pause", Pause_buttonX + Pause_buttonW/2, Pause_buttonY + Pause_buttonH/2);
  }

  if (BFS == false) {
    text("DFS", Alg_buttonX + Alg_buttonW/2, Alg_buttonY + Alg_buttonH/2);
  } else {
    text("BFS", Alg_buttonX + Alg_buttonW/2, Alg_buttonY + Alg_buttonH/2);
  }
}
void resetGame() {
  playerX = 0;
  playerY = 29;
  moveInterval = 5;
  lastMoveFrame = 0;
  dfsFinished = false;
  hasPassedDoor = false;
  doorPositions.clear();
  deque.clear();
  gameStarted = false;
  monster = monsterOriginal;
  maze = new int[mazeSize][mazeSize];
  roomX = int(random(1, mazeSize - 6));
  roomY = int(random(1, mazeSize - 6));

  initMaze();
  go(playerX, playerY);
  deque.push(new PVector(playerX, playerY));
}

void mousePressed()
{
  //START
  if (!gameStarted) {
    //if (mouseX >= Start_buttonX && mouseX <= Start_buttonX + Start_buttonW &&
    //  mouseY >= Start_buttonY && mouseY <= Start_buttonY + Start_buttonH) {
    //  Start_Pressed = true;
    //}
    float d = dist(mouseX, mouseY, Start_buttonX, Start_buttonY);
    if (d <= Start_buttonW / 2.0) {
      Start_Pressed = true;
    }

    if (mouseX >= Alg_buttonX && mouseX <= Alg_buttonX + Alg_buttonW &&
      mouseY >= Alg_buttonY && mouseY <= Alg_buttonY + Alg_buttonH) {
      Alg_Pressed = true;
    }
  }
  //RESET
  if (mouseX >= Reset_buttonX && mouseX <= Reset_buttonX + Reset_buttonW &&
    mouseY >= Reset_buttonY && mouseY <= Reset_buttonY + Reset_buttonH) {
    Reset_Pressed = true;
  }
  //RANDOM POS
  if ((mouseX >= random_buttonX && mouseX <= random_buttonX + random_buttonW &&
    mouseY >= random_buttonY && mouseY <= random_buttonY + random_buttonH))
  {
    Random_Pressed=true;
  }
  //PAUSE
  if (mouseX >= Pause_buttonX && mouseX <= Pause_buttonX + Pause_buttonW &&
    mouseY >= Pause_buttonY && mouseY <= Pause_buttonY + Pause_buttonH) {
    Pause_Pressed = true;
  }
}

void mouseReleased() {
  //START
  if (!gameStarted && Start_Pressed)
  {
    float d = dist(mouseX, mouseY, Start_buttonX, Start_buttonY);
    if (d <= Start_buttonW / 2.0) {
      if (gameStarted) gameStarted = false;
      else gameStarted = true;
    }
    //    if (mouseX >= Start_buttonX && mouseX <= Start_buttonX + Start_buttonW &&
    //      mouseY >= Start_buttonY && mouseY <= Start_buttonY + Start_buttonH) {
    //      if (gameStarted) gameStarted = false;
    //      else gameStarted = true;
    //    }
    Start_Pressed = false;
  }
  if (!gameStarted && Alg_Pressed)
  {
    if (mouseX >= Alg_buttonX && mouseX <= Alg_buttonX + Alg_buttonW &&
      mouseY >= Alg_buttonY && mouseY <= Alg_buttonY + Alg_buttonH) {
      if (BFS == true) BFS = false;
      else BFS = true;
    }
    Alg_Pressed = false;
  }
  //RESET
  if (Reset_Pressed)
  {
    if (mouseX >= Reset_buttonX && mouseX <= Reset_buttonX + Reset_buttonW &&
      mouseY >= Reset_buttonY && mouseY <= Reset_buttonY + Reset_buttonH) {
      resetGame();
    }
    Reset_Pressed = false;
  }
  //RANDOM POS
  if (!gameStarted && Random_Pressed)
  {
    if ((mouseX >= random_buttonX && mouseX <= random_buttonX + random_buttonW &&
      mouseY >= random_buttonY && mouseY <= random_buttonY + random_buttonH))
    {
      random_pos();
    }
    Random_Pressed=false;
  }
  //PAUSE
  if (Pause_Pressed)
  {
    isPaused = !isPaused;
    Pause_Pressed = false;
  }
}
void random_pos()
{
  if (gameStarted)
  {
    return;
  }

  // 清空舊路徑
  deque.clear();
  dfsFinished = false;
  hasPassedDoor = false;

  // 隨機合法起點
  while (true)
  {
    int rx = int(random(mazeSize));
    int ry = int(random(mazeSize));
    if (maze[rx][ry] == 3) // 確保是可走路
    {
      playerX = rx;
      playerY = ry;
      break;
    }
  }

  // 清除舊 DFS 痕跡
  for (int x = 0; x < mazeSize; x++)
  {
    for (int y = 0; y < mazeSize; y++)
    {
      if (maze[x][y] == 8 || maze[x][y] == 9)
      {
        maze[x][y] = 3;
      }
    }
  }

  // 設定新起點
  deque.push(new PVector(playerX, playerY));
}
void initMaze() {
  if (playerY % 2 == 1) {
    for (int x = 0; x < mazeSize; x++) {
      for (int y = 0; y < mazeSize; y += 2) {
        maze[x][y] = 1;
      }
    }
  } else {
    for (int x = 0; x < mazeSize; x++) {
      for (int y = 1; y < mazeSize; y += 2) {
        maze[x][y] = 1;
      }
    }
  }
  if (playerX % 2 == 1) {
    for (int y = 0; y < mazeSize; y++) {
      for (int x = 0; x < mazeSize; x += 2) {
        maze[x][y] = 1;
      }
    }
  } else {
    for (int y = 0; y < mazeSize; y++) {
      for (int x = 1; x < mazeSize; x += 2) {
        maze[x][y] = 1;
      }
    }
  }

  for (int x = roomX; x < roomX + 6; x++) {
    for (int y = roomY; y < roomY + 6; y++) {
      maze[x][y] = 5;
    }
  }
  for (int x = 1; x < mazeSize - 1; x++) {
    for (int y = 1; y < mazeSize - 1; y++) {
      if (maze[x][y] == 5 &&
        (maze[x-1][y] == 0 || maze[x+1][y] == 0 || maze[x][y-1] == 0 || maze[x][y+1] == 0)) {
        maze[x][y] = 6;
        doorPositions.add(new PVector(x, y));
      }
      if (maze[x][y] == 5 && maze[x][y] != 6 &&
        (maze[x-1][y] == 0 || maze[x+1][y] == 0 || maze[x][y-1] == 0 || maze[x][y+1] == 0))
      {
        maze[x][y] = 1;
      }
    }
  }
}

int go(int x, int y) {
  maze[x][y] = 4;
  int number = floor(random(4));

  if ((y >= 2) && (number == 0)) {
    if (maze[x][y-2] == 0) {
      maze[x][y-1] = 3;
      go(x, y-2);
    }
  }
  if ((x < mazeSize - 2) && (number == 1)) {
    if (maze[x+2][y] == 0) {
      maze[x+1][y] = 3;
      go(x+2, y);
    }
  }
  if ((y < mazeSize - 2) && (number == 2)) {
    if (maze[x][y+2] == 0) {
      maze[x][y+1] = 3;
      go(x, y+2);
    }
  }
  if ((x >= 2) && (number == 3)) {
    if (maze[x-2][y] == 0) {
      maze[x-1][y] = 3;
      go(x-2, y);
    }
  }

  if (y >= 2 && maze[x][y-2] == 0) {
    maze[x][y-1] = 3;
    go(x, y-2);
  }
  if (x < mazeSize - 2 && maze[x+2][y] == 0) {
    maze[x+1][y] = 3;
    go(x+2, y);
  }
  if (y < mazeSize - 2 && maze[x][y+2] == 0) {
    maze[x][y+1] = 3;
    go(x, y+2);
  }
  if (x >= 2 && maze[x-2][y] == 0) {
    maze[x-1][y] = 3;
    go(x-2, y);
  }
  return success;
}
