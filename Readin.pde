//---- For reading filenames -----------------------------------------
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Arrays;

String[] songname; // array of the names of the song text files in the folder.

//---- For reading filenames -----------------------------------------


public static String[] fileNames(String directoryPath) {
  File dir = new File(directoryPath);
  ArrayList<String> files  = new ArrayList<String>();

  if (dir.isDirectory()) {
    File[] listFiles = dir.listFiles();

    for (File file : listFiles) {
      if (file.isFile()) {
        files.add(file.getName());
      }
    }
  }
  return files.toArray(new String[]{});
}
