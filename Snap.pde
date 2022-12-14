import java.util.*;
import java.lang.reflect.Field;
import processing.sound.*;

import controlP5.*;

// * CONSTANTS
public static final int h = 1000;
public static final int w = 1000;

public static final int ch = 500;
public static final int cw = 500;

// * VARIABLES
public boolean doingIntro = true;
public boolean transitioning = false;
public boolean turnOver = true;
public boolean roundOver = false;
public int startTurn = ((Math.random() * 2) > 1.0) ? 1 : 2;
public int curTurn = startTurn;
public int curCardIndex = -1;

public boolean gOver = false;
// The highest round the game can reach before ending
public int maxRound = 6;

public int curRound = 1;
public int numTurns = curRound;

// * COLORS
public static final color bg = #1e293b;

// * Util classes
public Assets a = new Assets();

// * Librarry classes
public ControlP5 cp5;

// * Transition classes
public TransitionIn transIn = new TransitionIn(this);
public TransitionOut transOut = new TransitionOut(this);

// * Game classes
public StartUp startUp = new StartUp(this);
public Intro intro = new Intro(this);

public Dealer dealer = new Dealer();
public Player p1 = new Player(this, 1);
public Player p2 = new Player(this, 2);
public Player curPlayer = startTurn == 1 ? p1 : p2;

public Turn turn = new Turn(this);

public Location l1 = new Location(this, -1);
public Location l2 = new Location(this, 0);
public Location l3 = new Location(this, 1);

public SkipBtn skipBtn = new SkipBtn(this);

public Header header = new Header(this);

public Tooltip tooltip = new Tooltip(this);
public GameOver gameOver = new GameOver(this);

void setup() {
  size(1000, 1000);
  procSet();

  // * Setup variables and assets
  a.setup(this);
  cp5 = new ControlP5(this);

  // * SETUP CLASSES
  dealCards();
  p1.setup();
  p2.setup();

  startUp.setup();
  intro.setup();

  l1.setup();
  l2.setup();
  l3.setup();

  skipBtn.setup();

  turn.setup();
  header.setup();
  tooltip.setup();
  gameOver.setup();
}

void draw() {
  background(bg);

  // If the game over transition is done only update the game over screen to avoid redrawing hidden items to the screen
  if (gOver && gameOver.paused) {
    gameOver.update();
    return;
  }

  intro.update();
  if (doingIntro) {
    return;
  }

  // Do game updates here!
  startUp.update();

  if (!startUp.done) return;

  if (turnOver) {
    turn.update();
    return;
  }

  if (turnOver) return;

  // Draw the background
  image(a.bg, cw, ch);

  if (curTurn == 1) {
    p1.update();
  } else if (curTurn == 2) {
    p2.update();
  } else {
    println("aaaaaaaaaa wtf happened to the turn?");
  }

  l1.update();
  l2.update();
  l3.update();

  skipBtn.update();
  header.update();
  tooltip.update();

  if (skipBtn.clicked) {
    turnOver = true;
    curTurn = curTurn == 1 ? 2 : 1;
    curPlayer = curTurn == 1 ? p1 : p2;
    curCardIndex = -1;

    gOver = isGameOver();

    if (curTurn == startTurn) {
      curRound++;

      if (curRound >= maxRound) {
        gOver = true;
      }
    }
    numTurns = curRound;
  }

  gameOver.update();
}

/**
 * Sets the default settings for drawing with processing
 */
void procSet() {
  background(0);
  shapeMode(CENTER);
  textAlign(CENTER);
  imageMode(CENTER);
  noStroke();

  // Default fill color is white
  fill(255);
}

void dealCards() {
  dealer.deal(p1.hand, 5);
  dealer.deal(p1.deck, 7);

  dealer.deal(p2.hand, 5);
  dealer.deal(p2.deck, 7);

  // Print out the cards of the player for debuggging
  // printCards();
}

// Print out the cards of the player for debuggging
void printCards() {
  println("Player 1: \n" + p1 + "\n\n");
  println("Player 2: \n" + p2 + "\n\n");
}

boolean isGameOver() {
  // ! Uncomment this line for debbugging the game over screen
  // return true;

  boolean hasSpace = l1.cards.size() < 2 || l2.cards.size() < 4 || l3.cards.size() < 4;
  boolean hasCards = p1.hasCards() || p2.hasCards();
  boolean hasSpecialCards = p1.hasSpecialCard() || p2.hasSpecialCard();
  return (!hasSpace && !hasCards) && !hasSpecialCards;
}
