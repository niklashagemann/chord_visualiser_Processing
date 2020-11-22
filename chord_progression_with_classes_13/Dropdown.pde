import controlP5.*;
ControlP5 cp5;
int menu_x = 45;
int menu_y = 420;
int menu_size_x = 180;
int menu_size_y = 140;
boolean new_song_selected = false;
boolean symmetrical = false;
Realbook realbook;



void init_dropdown_list() {
  cp5 = new ControlP5(this);
  realbook = new Realbook();
  // List l = Arrays.asList(songname);
  // .addItems(java.util.Arrays.asList("a","b","c","d","e","f","g"))
  /* add a ScrollableList, by default it behaves like a DropdownList */

  PFont p = createFont("DINPro-Regular.otf", 13); 
  ControlFont font = new ControlFont(p);


  cp5.addScrollableList("dropdown")
    .addItems(java.util.Arrays.asList(realbook.songname))
    .setPosition(menu_x, menu_y)
    .setSize(menu_size_x, menu_size_y)
    .setBarHeight(28)
    .setItemHeight(25)
    .setLabel("Songs   (" + realbook.songname.length + ")")
    .setValue(song_no) // the 'default' song selected.
    .setColorForeground(dominant_color)
    .setColorBackground(normal_color)
    .setColorLabel(0)
    .setColorValue(0) 
    .setColorActive(color(230))
    .setOpen(false)
    .setScrollSensitivity(1)
    //.setDirection(UP)
    // .setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;

  // Changing the font ...
  cp5.getController("dropdown").getValueLabel()
    .setFont(font)
    .toUpperCase(false)
    .getStyle().margin(3, 0, 0, 4);
  cp5.getController("dropdown").getCaptionLabel()
    .setFont(font)
    .toUpperCase(false)
    .getStyle().margin(3, 0, 0, 4);
}

void draw_box_over_dropdown_list() {
  noStroke();
  fill(bg_color);
  rect(menu_x, menu_y, menu_size_x, menu_size_y);
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) {
    new_song_selected = true;
    song_no = int(theEvent.getController().getValue());
    println("got something from a controller "
      +song_no
      );
  }
}
