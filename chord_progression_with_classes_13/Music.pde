
// -------------------------------------------------------------------
// Bundling all the music methods?
// -------------------------------------------------------------------


class Music {

  String[] chordsLookUp = {"C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"};
  String[] chordsLookUp_alt = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

  Music () {
  }

  int index(String note) {
    // Receive a chord/note/key as a String. Return its index value within the octave.
    for (int i = 0; i < chordsLookUp.length; i ++) {
      if (chordsLookUp[i].equals(note) || chordsLookUp_alt[i].equals(note) ) {
        return i; // chord position according to chord look up string i.e. C = 0, Db = 1, D = 2 ... etc.
      }
    }
    return -1;
  }
  
  String look_up_chord(int temp_index) {
    return chordsLookUp[temp_index];
  }


  int relative(int chord_index, int root_index) {
    // where is a chord relative to the key?
    int relative_pos = chord_index - root_index;
    if (relative_pos < 0) {
      relative_pos = 12 + relative_pos;
    }
    return relative_pos;
  }


  boolean fifths(int index_a, int index_b) {
    switch(index_a - index_b) {
    case 7:
    case -5:
      return true;
    }
    return false;
  }


  int distance(int index_a, int index_b) {
    // Distance between two chords/notes/keys.
    return 0;
  }

  boolean sharp(String current_chord) {
    if (current_chord.length() > 1) {
      if (current_chord.charAt(1) == '#') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  boolean flat(String current_chord) {
    if (current_chord.length() > 1) {
      if (current_chord.charAt(1) == 'b') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  boolean minor(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case 'm':
        case '-':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean diminished(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case '0':
        case 'º':
        case 'o':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean dominant(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case '7':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean sixth(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case '6':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean nine(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case '9':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean augmented(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case '+':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean major(String current_chord) {
    if (current_chord.length() > 1) {
      for (int i=1; i<current_chord.length(); i++) {
        switch(current_chord.charAt(i)) {
        case 'M':
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean sus(String current_chord) {
    if (current_chord.length() > 2) {
      for (int i=3; i<current_chord.length(); i++) {
        // println("substring: " + current_chord.substring(i-2, i+1));
        switch(current_chord.substring(i-2, i+1)) {
        case "sus":
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean flat_five(String current_chord) {
    if (current_chord.length() > 3) {
      for (int i=3; i<current_chord.length(); i++) {
        println("substring: " + current_chord.substring(i-1, i+1));
        switch(current_chord.substring(i-1, i+1)) {
        case "b5":
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  boolean flat_nine(String current_chord) {
    if (current_chord.length() > 3) {
      for (int i=3; i<current_chord.length(); i++) {
        println("substring: " + current_chord.substring(i-1, i+1));
        switch(current_chord.substring(i-1, i+1)) {
        case "b9":
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }
}
