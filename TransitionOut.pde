public class TransitionOut extends Transition {
  public TransitionOut(Snap app) {
    super(app);
    v.transOut = this;

    starting_opacity = 255;
    opacity = starting_opacity;
    end_opacity = 0;
    up = false;
    step = 8;
  }
}
