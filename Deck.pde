public class Deck extends Clickable implements ICardHolder {
  public LinkedList<Card> cards = new LinkedList();
  public LinkedList<MovableCard> movableCards = new LinkedList();

  // * DRAWING CONSTANTS
  public int x_txt;
  public int y_txt;

  protected void _setup() {
    x = 20;
    y = m.h - 20;
    w = Card.w;
    h = Card.h;

    x_txt = x;
    y_txt = y - h - 30;

    cornerToCenter();
  }

  protected void _update() {
    textAlign(CORNERS);
    textSize(32);
    text("" + cards.size() + " cards", x_txt, y_txt);

    for(int i=movableCards.size() - 1; i>=0; i--) {
      MovableCard mc = movableCards.get(i);
      mc.update();

      if (mc.done) {
        movableCards.remove(i);
      }
    }


    // Draw the deck
    if (cards.size() >= 1) {
      imageMode(CENTER);
      image(a.back, x, y, Card.w, Card.h);
    }

    if (clicked) {
      if (cards.size() < 1 || (m.curPlayer.hand.cards.size() + movableCards.size()) >= 5) return;

      Card c = cards.remove();
      MovableCard mc = new MovableCard(m);
      mc.c = c;
      mc.deck = this;

      mc.setup();

      movableCards.add(mc);

      // Play a swipe sound effect
      a.swipe.jump(0);
    }
  }


  private class MovableCard extends Obj {
    public Card c;
    public Deck deck;

    public static final float lerp_step = 0.15;
    public int max_x = Snap.w - 300;
    public boolean done = false;
    public int x = 20 + Card.h / 2;
    public int y = Snap.h - 20 - Card.h / 2;

    public int space = Card.w - Hand.overlap;

    protected void _setup() {
      int pos = (5 - m.curPlayer.hand.cards.size() + 2 - movableCards.size());
      max_x = pos * space - Hand.overlap;
    }

    protected void preUpdate() {
      super.preUpdate();
    }

    protected void _update() {
      imageMode(CENTER);
      image(a.getCard(c), x, y, Card.w, Card.h);

      if (x >= max_x) {
        done = true;
        // Stop updating the object
        shouldUpdate = false;

        m.curPlayer.hand.cards.add(c);
        return;
      }

      x = Math.round(lerp(x, max_x, lerp_step)) + 1;
    }

    public MovableCard(Snap app) { super(app); }
  }

  public void add(Card c) {
    cards.add(c);
  }

  public String toString() {
    return cards.toString();
  }

  public Deck(Snap app) { super(app); }
}
