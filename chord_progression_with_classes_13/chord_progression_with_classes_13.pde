import processing.pdf.*;

// -------------------------------------------------------------------
// Did we receive a new song selection? Move into UI class ... 
boolean update = false, first_go = true;
// -------------------------------------------------------------------

color bg_color = color(241);
color normal_color = color(220);
color dominant_color = color(255, 205, 40, 130);
color minor_color = color(30, 60, 80, 80);
color transitions_color = color(190, 200, 210);
color foreground_color = color(255, 220, 20, 120);
PFont f;
Song song;
int song_no;


void setup() {
  size(1300, 560); // add /*, PDF, "filename.pdf"*/ in oder to export PDF, plus, uncomment the exit() line in the draw loop.
  f = createFont("SwedenSans.otf", 14, true); // DINPro-Medium.otf
  init_dropdown_list();
  song_no = 4;
}



void draw() {

  if (first_go == true || new_song_selected == true) {

    background(bg_color);
    // -------------------------------------------------------------------
    // PART 1: Read/analyse all the chords
    song = new Song();
    song.load(song_no);
    song.display();
    song.key();
    song.identify_bars();
    song.structure();
    song.indexed(); 

    // -------------------------------------------------------------------
    // PART 2: draw the chord ..
    song.draw_chord();

    // -------------------------------------------------------------------
    // PART 3: Set booleans.
    first_go = false;
    new_song_selected = false;
  } else {
    draw_box_over_dropdown_list();
  }
  
  //// Exit the program 
  //println("Finished.");
  //exit();
}
