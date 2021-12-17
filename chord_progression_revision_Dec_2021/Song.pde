// -------------------------------------------------------------------
// Read the song that has been selected into an array.
// Analyse the chords of the song, re-jigg the array/make a new array.
// -------------------------------------------------------------------

Song song;
int song_no; // the selected song index.

class Song {

  // -------------------------
  // External classes we need
  Music music;  // Gives us music functions to use.
  Realbook realbook; // the directory of songs.
  // -------------------------

  // -------------------------
  // The main variables, arrays.
  String[] lines; // the length of this array is equal to the total number of chords in the song!
  int[] bar_index;
  int[] c_bar; //how many chords in each bar.
  String[][] structured; // a 2D array of the chords, rows are bars, columns are chords.
  int[][][] indexed; // the same 2D array but as indexed chord numbers.
  // -------------------------
  String song; // the name of the selected song without .txt suffix.
  String root;  // key of the song
  int root_index; // index value of the key
  int total_bars; // how many bars in the song
  int c_max = 1; // max number of chords that occur in a bar of the song (initialised to 1).
  // -------------------------
  int left_margin;
  float bar_width;
  float chord_gap; // i.e. the bar-wdith divided by the max. numbr of chords that appear in a bar.
  int ref_y;
  int chord_height;
  // -------------------------


  // -------------------------
  // The constructor
  Song () {
    music = new Music();
    realbook = new Realbook();
  }
  // -------------------------


  // The functions
  // ...


  // -------------------------
  // Load the song

  void load(int song_no) {
    song = songname[song_no];
    String file_name = song;
    lines = loadStrings(file_name);
  }

  void display() {
    println("there are " + lines.length + " chords in this song");
    println("the chords are ");
    for (int i = 0; i < lines.length; i++) {
      println(lines[i]);
    }
  }
  // ------------------------



  // -------------------------
  // What's the key of the song?

  void key() {
    for (int k=0; k<song.length(); k++) {
      if (song.charAt(k) == '(') {

        int f = 0; // extra character to read if there's a flat or sharp.

        // Accounting for sharps or flats
        if (song.charAt(k+2) == '#' || song.charAt(k+2) =='b') {
          f = 1;
        } else {
          f = 0;
        }

        root = song.substring(k+1, k+2+f);
        println("Root of song: " + root);


        // Use function from Music class
        root_index = music.index(root);
        println("Root indexed: " + root_index);
        break;
      }
    }
  }
  // -------------------------



  // -------------------------
  // Are there bars annotated?

  void identify_bars() {

    int b = 0; // bar counter
    int c = 0; // no. of chords in a bar.
    bar_index = new int[lines.length];

    for (int a=0; a<lines.length; a++) {
      if (lines[a].charAt(0) == '|' || a==0) {
        b ++;
        c=1;
      } else {
        c++;
        if (c > c_max) {
          c_max = c;
        }
      }
      // println("Bar index: " + b);
      bar_index[a] = b;
      total_bars = b;
      println("Bar index: " + bar_index[a]);
    }
  }
  // -------------------------



  // -------------------------
  // Transfer to a new array.

  void structure() {
    // int total_bars = bar_index[bar_index.length-1];
    println("Total no. of bars: " + total_bars);

    println("Max chords/bar: " + c_max);
    structured = new String[total_bars][c_max];

    int c=0; // chord counter
    int b=0; // bar counter
    int prev_bar = 0;
    String truncated_string;
    int t=0; // to shift start of the truncated substring.
    c_bar = new int[total_bars];

    for (int a=0; a<lines.length; a++) {
      if (a != 0) {
        if (bar_index[a] == prev_bar) {
          c++;
          t=0;
        } else {
          // save how many chords there were in the previous bar.
          c_bar[b] = c + 1;
          b++;
          c=0;
          t=1;
        }
      }

      truncated_string = lines[a].substring(0+t, lines[a].length());

      int bar_no = bar_index[a];

      // -----------------------------------------------
      structured[bar_no-1][c] = truncated_string;
      // -----------------------------------------------

      println("c: " + c + ", Bar: " + bar_no + ", chord: " + structured[bar_no-1][c]);
      prev_bar = bar_index[a];

      // For the END ... there is no previous bar to look back on.
      if (a == lines.length-1) {
        c_bar[b] = c + 1;

        for (int i=0; i < c_bar.length; i++) {
          println("Chords in bar " + (i+1) + ": " + c_bar[i]);
        }
      }
    }

    // In the case of a .txt file that has bars annotated, test with a chord position that shouldn't exist:
    // println("This should be empty: " + structured[0][1]); // only works if there is actually more than one column (i.e. one instance of more than one chord per bar).
  }
  // -------------------------





  // This one is about indexing everything about each chord.
  void indexed() {

    indexed = new int[structured.length][structured[0].length][12];

    for (int b=0; b<structured.length; b++) { // cycle through all the bars.
      for (int c=0; c<c_bar[b]; c++) { // cycle through the chords of each bar.
        if (structured[b][c] != null) {  // Only cycle through the positions where there actually is a chord.



          // ***
          // 0th: The step of the chord


          int t=0;

          if (music.flat(structured[b][c])) {
            t = 1;
            indexed[b][c][10] = 1;
          } else if (music.sharp(structured[b][c])) {
            t = 1;
            indexed[b][c][11] = 1;
          }

          indexed[b][c][0] = music.index(structured[b][c].substring(0, 1+t));
          println("indexed: " + indexed[b][c][0]);



          // ***
          // nth dimension: the rest of the annotations


          if (music.minor(structured[b][c])) {
            indexed[b][c][1] = 1;
            println("This is a minor chord");
          }

          if (music.dominant(structured[b][c])) {
            indexed[b][c][2] = 1;
            println("This is a dominant chord");
          }

          if (music.major(structured[b][c])) {
            indexed[b][c][3] = 1;
            println("This is a major chord");
          }

          if (music.flat_five(structured[b][c])) {
            indexed[b][c][4] = 1;
            println("This is a flat-five chord");
          }

          if (music.flat_nine(structured[b][c])) {
            indexed[b][c][5] = 1;
            println("This is a flat_nine chord");
          }

          if (music.sixth(structured[b][c])) {
            indexed[b][c][6] = 1;
            println("This is a sixth chord");
          }

          if (music.diminished(structured[b][c])) {
            indexed[b][c][7] = 1;
            println("This is a diminished chord");
          }

          if (music.augmented(structured[b][c])) {
            indexed[b][c][8] = 1;
            println("This is an augmented chord");
          }

          if (music.sus(structured[b][c])) {
            indexed[b][c][9] = 1;
            println("This is a sus chord");
          }
          // ---------------------------------
        } else {
          // do nothing, don't waste time cycling through positions where there are no chords ...
        }
      }
    }
  }


  void draw_chord() {

    noStroke();
    left_margin = 60;
    // bar_width = 100;
    bar_width = (width - 2*left_margin)/total_bars;
    println("The number of bars is: " + total_bars);
    println("The total number of chords in the song (lines.length) = " + lines.length);
    ref_y = 200;
    chord_height = 10;

    //if (indexed.length == 1) { // i.e. if there are no bars annotated in the .txt file.
    //  chord_gap = (width - 2*left_margin)/lines.length;
    //} else {
    //  chord_gap = bar_width/indexed[0].length;
    //}

    // initialise
    int prev_temp_index = 0;
    float prev_x_pos = 0;
    float prev_y_pos = 0;
    color prev_bubble_color = transitions_color;
    float last_x_root = left_margin;
    int bubble_x_offset = 4;
    int bubble_y_offset = -5;


    for (int b=0; b<total_bars; b++) {
      // ------------------------
      // Draw bars
      float bar_x = bubble_x_offset + left_margin + b*bar_width;
      float bar_height = 14;
      float bar_y = ref_y - 4 + bar_height/2;
      strokeWeight(bar_thickness);
      stroke(bar_color);
      line(bar_x, bar_y, bar_x, bar_y - bar_height);

      if  (b == 0) {
        bar_x -= 8;
        line(bar_x, bar_y, bar_x, bar_y - bar_height);
      }
      if (b == total_bars - 1) {
        bar_x += bar_width;
        line(bar_x, bar_y, bar_x, bar_y - bar_height);

        bar_x += 8;
        line(bar_x, bar_y, bar_x, bar_y - bar_height);
      }
      noStroke();
      // ------------------------
    }


    for (int b=0; b<indexed.length; b++) {
      for (int c=0; c<c_bar[b]; c++) {
        if (structured[b][c] != null) {

          int temp_index = indexed[b][c][0] - root_index;

          if (symmetrical == true) {
            // Keep the chords close together .. if they'er further apart than a fifth (7 half steps), then shift up or down.
            if (temp_index > 7) {
              temp_index -= 12;
            } else if (temp_index < -7) {
              temp_index += 12;
            } else if (temp_index == -5) { // keep the dominant of the root positive (just for aesthetics).
              temp_index += 12;
            }
          } else {
            if (temp_index < -4) { // -4 seems a good compromise ...
              temp_index += 12;
            }
            if (temp_index > 8) { //
              temp_index -= 12;
            }
          }

          // -----------------------------------
          // The spacing/position of the chords:
          // First chord of current bar, where it starts:
          chord_gap = bar_width/(c_bar[b]);
          float bar_padding_left = chord_gap/2;

          if (c_bar[b] == 1 && total_bars > 1) { // if there's only one chord in the bar, make it so it's still aligned to the start of the bar (not centred). Unless there aren't any bars, then keep it.
            bar_padding_left = bar_width/4;
          }

          // float x_pos = left_margin + b*chord_gap*indexed[0].length + c*chord_gap;
          float x_pos = left_margin + b*bar_width + bar_padding_left + c*chord_gap;
          float y_pos = ref_y - chord_height*temp_index;

          //text
          fill(255);
          textFont(f);
          float extra_x = 0;
          int flat_sharp = 0;
          boolean dominant = false, minor = false, augmented = false, diminished = false, major = false;

          if (indexed[b][c][10] == 1) { // Flat
            flat_sharp = 8;
          }
          if (indexed[b][c][11] == 1) { // Sharp
            flat_sharp = 8;
          }
          if (indexed[b][c][2] == 1) { // 7th
            dominant = true;
          }
          if (indexed[b][c][7] == 1) {
            diminished = true;
          }
          if (indexed[b][c][8] == 1) {
            augmented = true;
          }
          if (indexed[b][c][1] == 1) { // minor
            minor = true;
          }
          if (indexed[b][c][3] == 1) { // Major 7
            major = true;
          }

          // ------------------------
          // The bubbles, some sort of hierarchy to the color selection
          color bubble_color;
          int bubble_width = 30;
          color temp_text_col = text_col;

          if (dominant == true) {
            bubble_color = dominant_color;
            temp_text_col = text_col;
          }
          else if (minor == true) {
            bubble_color = minor_color;
            temp_text_col = inv_text_col;
          }
          else if (minor == true && dominant == true) {
            bubble_color = minor_color;
            temp_text_col = inv_text_col;
          }
          else if (major == true) {
            bubble_color = major_color;
            temp_text_col = inv_text_col;
          }
          else if (diminished == true || augmented == true) {
            bubble_color = augm_color;
            temp_text_col = inv_text_col;
          }
          else {
            bubble_color = normal_color;
            temp_text_col = inv_text_col;
          }



          // ------------------------
          // Draw the reference line
          if (b == 0 && c == 0) { // the start.
            if (temp_index == 0) {
              last_x_root = x_pos;
            }
          } else {
            if (b == (indexed.length - 1) && c == (c_bar[b]) -1) { // the end.
              draw_dash(x_pos, last_x_root, ref_y - 4, 20, 0);
            } else { // all other cases
              if (temp_index == 0) { // don't draw the line if there is a root chord in the way.
                draw_dash(x_pos, last_x_root, ref_y - 4, 20, 20);
                last_x_root = x_pos;
              }
              if (temp_index == -1 || temp_index == 1) { // i.e. close enough to the root, that the reference line would get in the way ...
                draw_dash(x_pos, last_x_root, ref_y - 4, 20, 20);
                last_x_root = x_pos;
              }
            }
          }


          // ------------------------
          // For the transition arrows ...
          // Check if there's a fifth cadence thing ...

          if (music.fifths(prev_temp_index, temp_index)) {

            noFill();
            strokeWeight(3);//strokeWeight(3);
            // stroke(prev_bubble_color);
            stroke(arrow_color);//stroke(220);
            float factor = 1;

            float delta_y = y_pos - prev_y_pos;
            float delta_x = x_pos-prev_x_pos;
            float alpha = atan(delta_y/delta_x);
            float radius = bubble_width*factor;
            float y_offset = sin(alpha)*radius;
            float x_offset = cos(alpha)*radius;
            float x0 = prev_x_pos + 4 + (0.55/factor)*x_offset;
            float y0 = prev_y_pos - 5 + (0.55/factor)*y_offset;
            float y1 = y_pos - 5 - y_offset;
            float x1 = x_pos + 4 - x_offset;

            line(x0, y0, x1, y1);

            // Arrow head
            float l = 7;
            float gamma = radians(40);
            float theta = radians(90) - alpha - gamma;
            float theta_2 = gamma - alpha;
            float d_y = l*cos(theta);
            float d_x = l*sin(theta);
            float d_y2 = l*sin(theta_2);
            float d_x2 = l*cos(theta_2);

            //if (prev_y_pos < y_pos) {
            //  d_y = -d_y;
            //  d_y2 = -d_y2;
            //}

            line(x1 - d_x, y1 - d_y, x1, y1);
            line(x1 - d_x2, y1 + d_y2, x1, y1);

            noStroke();

            // Text
            fill(160);
            textSize(10);
            text("fifth", x_pos - x_offset - 30, y_pos - 0.7*y_offset);
            textSize(13);
          }



          // ------------------------
          // Draw bubble after drawing the transitions.
          make_bubble(false, bubble_color, bubble_width, x_pos, y_pos, 0, bubble_x_offset, bubble_y_offset); // last input variable is the mode (0 = circle, 1 = rectangle)





          // ------------------------
          // Now the text
          fill(temp_text_col);

          // the annotations
          if (diminished == true) {
            extra_x = 6;
            textSize(12);
            text("o", x_pos + 5 + 0.4*extra_x, y_pos -5);
          }
          if (augmented == true) {
            extra_x = 6;
            textSize(14);
            text("+", x_pos + 5 + 0.4*extra_x, y_pos -3);
          }
          if (minor == true) { // minor
            extra_x = 6;
            textSize(11);
            text("-", x_pos + 5 + 0.4*extra_x + 0.3*flat_sharp, y_pos + 2);
          }
          if (dominant == true /*&& minor == false*/) { // 7th
            extra_x = 6;
            textSize(10);
            text("7", x_pos + 5 + 0.4*extra_x + 0.3*flat_sharp, y_pos -5);
          }
          if (major == true) { // Major 7
            extra_x = 7;
            textSize(9);
            text("M", x_pos + 3 + 0.4*extra_x + 0.3*flat_sharp, y_pos -5);
          }

          // the main chord
          textSize(13);
          String chrd = chordsLookUp[indexed[b][c][0]];
          float x_shift = 0;
          if (chrd.length() == 2) { // i.e. it's a flatted or sharped chord. Cb, D#, etc.
            x_shift = 0.5*flat_sharp;
            println("X CORRECTION");
          }
          text(chrd, x_pos - 0.5*extra_x - x_shift, y_pos);

          // ------------------------
          // Remember values for the next round ...
          prev_temp_index = temp_index;
          prev_x_pos = x_pos;
          prev_y_pos = y_pos;
          prev_bubble_color = bubble_color;
        }
      }
    }

    // draw the reference line
    //println("Last x_pos: " + prev_x_pos);
    //draw_dash(prev_x_pos, left_margin, ref_y);
  }

  void make_triangle() {
    //int extra_y = -7;
    ////text("△", x_pos+4, y_pos);
    //float triangle_width = 5.4;
    //stroke(0,120);
    //strokeWeight(1);
    //pushMatrix();
    //translate(0, -1);
    //line(x_pos+extra_x + 0.6*flat_sharp, y_pos + extra_y, x_pos+extra_x+triangle_width + 0.6*flat_sharp, y_pos + extra_y);
    //line(x_pos+extra_x + 0.6*flat_sharp, y_pos + extra_y, x_pos+extra_x+triangle_width/2 + 0.6*flat_sharp, y_pos-sin(radians(60))*triangle_width + extra_y);
    //line(x_pos+extra_x+triangle_width + 0.6*flat_sharp, y_pos + extra_y, x_pos+extra_x+triangle_width/2 + 0.6*flat_sharp, y_pos-sin(radians(60))*triangle_width + extra_y);
    //popMatrix();
    //noStroke();
  }





  void make_bubble(boolean strk, color temp_color, int temp_width, float temp_x, float temp_y, int temp_mode, int bubble_x_offset, int bubble_y_offset) {

    // stroke or no-stroke
    if (strk) {
      stroke(0);
      strokeWeight(2);
    }
    else{
      noStroke();
    }

    if (temp_mode == 0) {
      fill(temp_color);
      //ellipseMode(CENTER);
      ellipse(bubble_x_offset + temp_x, bubble_y_offset + temp_y, temp_width, temp_width);
    } else if (temp_mode == 1) {
      fill(temp_color);
      rectMode(CENTER);
      rect(bubble_x_offset + temp_x, bubble_y_offset + temp_y, temp_width*0.9, temp_width*0.7, temp_width*0.4); // last varibale is rounded radius.
    }
    fill(0);
  }





  void draw_dash(float temp_x_pos, float last_x_root, float ref_y, float gap_start, float gap_end) {

    int dash_width = 6;
    strokeWeight(dash_thickness);
    stroke(dash_color);
    float distance = temp_x_pos - last_x_root - gap_start - gap_end;
    float steps = distance/dash_width;

    for (int n=0; n < steps; n++) {
      if (n%2 != 0) { // odd
        // draw dash
        float start_x = last_x_root + gap_start + n*dash_width;
        float end_x = start_x + 0.8*dash_width;
        line(start_x, ref_y, end_x, ref_y);
      }
    }

    noStroke();
  }
  
  // A function / select range of bars to show.
  void part(int temp_range_start, int temp_range_end) {
  }
}
