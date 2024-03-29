// Chord-visualiser app
// Niklas Hagemann
// ongoing ... 2021
// ----------------------

// PDF export
import processing.pdf.*;
boolean record = false;
boolean started_recording = false;


// Did we receive a new song selection? Move into UI class ...
boolean update = false, first_go = true;


// Colors, line weights etc.
color bg_color = color(255);
color text_col = color(255);
color inv_text_col = color(0);
color menu_color = color(230);
color normal_color = color(220);
color dominant_color = color(50);
color minor_color = color(180, 200, 220);
color major_color = color(235);
color augm_color = color(240, 200, 200);
color transitions_color = color(0);
color arrow_color = color(20);
color foreground_color = color(220);
color dash_color = color(220);
float dash_thickness = 1.5;
float bubble_border = 1.5;
float arrow_thickness = 1.5;
color bar_color = color(220);
int bar_thickness = 2;

// Font
PFont f;


void setup() {

  // read songnames into an array
  songname = fileNames(dataPath(""));
  Arrays.sort(songname); //sort alphabetically.
  println("There are " + songname.length + " songs in the folder.");
  println("---------------------------------");
  for (int j=0; j<songname.length; j++) {
    println(songname[j]);
  }

  size(1300, 560); // add /*, PDF, "filename.pdf"*/ in oder to export PDF, plus, uncomment the exit() line in the draw loop.
  f = createFont("Karla-Bold.ttf", 14, true); // DINPro-Medium.otf
  init_dropdown_list();
  song_no = 0;
}



void draw() {

  if (first_go == true || new_song_selected == true) {

    background(bg_color);

    if (record) {
      started_recording = true;
      String songname_truncated = songname[song_no].substring(0, songname[song_no].lastIndexOf('.'));
      beginRecord(PDF, "./exports/chords ~ " + songname_truncated + ".pdf"); // pdf file with the current selected song.
    }


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

    if (record && started_recording) {
      endRecord();
      record = false;
      started_recording = false;
    }


    write_heading();
    write_transpose();

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



void keyPressed() {
  if (key == 'p') {
    record = true;
  }
  if (key == '+' || key == '=') {
    transpose(1);
  }
  if (key == '-') {
    transpose(-1);
  }
  if (key == 'r') { // refresh
    new_song_selected = true; // refresh!
    record = true;
  }

  if (key == CODED) {
    if (key == UP) {
      transpose(1);
    }
    if (key == DOWN) {
      transpose(-1);
    }
  }
}


void transpose(int t) {
  transpose += t;
  transposeWrap();
  println("new transpose" + transpose);
  new_song_selected = true; // refresh!
}

void transposeWrap() {
  if (transpose == 12) {
    transpose = 0;
  }
  if (transpose == -12) {
    transpose = 0;
  }
}
