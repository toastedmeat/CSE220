package HW6;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Scanner;
import stonybrooku.Playlist;
import stonybrooku.SongRecord;

/**
 *
 * @author eloo
 */
public class Store {

    public static void main(String[] args) {
        Item myItem = new Item();
        try {
            //If file is found, open it, Else myItem is still null.
            FileInputStream file = new FileInputStream("myItem.obj");
            ObjectInputStream oIn = new ObjectInputStream(file);
            myItem = (Item) oIn.readObject();
            file.close();
        } catch (IOException | ClassNotFoundException e) {
            System.out.print("items.obj not found, beginning with an empty hash table...\n");
        }

        boolean go = true;
        Scanner s = new Scanner(System.in);
        String option = "";

        while (go) {
            System.out.println("\nPlease select a menu option: \n"
                    + "I) Insert an Item into the Store.\n"
                    + "A) Add to the inventory for a given Item.\n"
                    + "R) Remove an Item from the Store.\n"
                    + "S) Search for Information about an Item.\n"
                    + "G) Go Shopping.\n"
                    + "Q) Quit and Save.\n");
            System.out.print("Select a menu option: ");
            option = s.next();
            switch (option) {
                case "I":
                case "i":
                    break;
                case "A":
                case "a":
                    break;
                case "R":
                case "r":
                    break;
                case "S":
                case "s":
                    break;
                case "G":
                case "g":
                    break;
                case "Q":
                case "q":
                    break;

            }
            if (option.equals("Q") || option.equals("q")) {
                go = false;
                try {
                    FileOutputStream fios = new FileOutputStream("mySaveFile.obj");
                    ObjectOutputStream oOut = new ObjectOutputStream(fios);
                    oOut.writeObject(myItem);
                    oOut.close();
                } catch (IOException a) {
                }
            }
            System.out.print("The file, items.obj, has successfully been saved.\n");
            System.out.print("Program terminating normally.....");
        }
    }
}
