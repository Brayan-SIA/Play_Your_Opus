public class SecondApplet extends PApplet
{
  boolean play = false;
  
  void settings()
  {
    size(displayWidth, displayHeight, P2D);
  }
  
  void draw()
  {
    pw.beginDraw();  
    pw_drawPlayWindow();
    pw.endDraw();
    pw.image(pw, 0, 0);
    if(mode != MODE.PLAY || mode != MODE.PAUSE_PLAY){
      this.exit();
    }
  }
  
} //<>//
