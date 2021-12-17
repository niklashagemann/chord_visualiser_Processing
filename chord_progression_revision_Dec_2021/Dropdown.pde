import controlP5.*;
ControlP5 cp5;
int menu_x = 45;
int menu_y = 400;
int menu_size_x = 220;
int menu_size_y = 140;
boolean new_song_selected = false;
boolean symmetrical = false;
Realbook realbook;

color active_color = color(250);


void write_heading() {
  textSize(13);
  text("song:", menu_x+5, menu_y - 10);
}

void write_transpose() {
  fill(0);
  textSize(14);
  String t = "Transpose:    " + transpose;
  text(t, menu_x + 250, menu_y + 19);
}

void init_dropdown_list() {
  cp5 = new ControlP5(this);
  realbook = new Realbook();
  // List l = Arrays.asList(songname);
  // .addItems(java.util.Arrays.asList("a","b","c","d","e","f","g"))
  /* add a ScrollableList, by default it behaves like a DropdownList */

  PFont p = createFont("Karla-Bold.ttf", 13);
  ControlFont font = new ControlFont(p);


  cp5.addScrollableList("dropdown")
    .addItems(java.util.Arrays.asList(songname))
    .setPosition(menu_x, menu_y)
    .setSize(menu_size_x, menu_size_y)
    .setBarHeight(28)
    .setItemHeight(25)
    .setLabel("Songs   (" + songname.length + ")")
    .setValue(song_no) // the 'default' song selected.
    .setColorForeground(active_color)
    .setColorBackground(menu_color)
    .setColorLabel(0)
    .setColorValue(0)
    .setColorActive(active_color)
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
