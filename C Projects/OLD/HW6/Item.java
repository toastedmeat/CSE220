package HW6;

import java.io.Serializable;

/**
 *
 * @author eloo
 */
public class Item implements Serializable {

    private String name; // The name of the item
    private String rfidName; // The Radio-frequency identification number
    private int quantity; // The amount
    private double price; // The price

    public Item() {
    }
    /*@param name The name of the Item
     * @param rfidName The Radio-frequency identification number
     * @param price The price of the Item
     * @param quantity The quantity of the Item
     */
    public Item(String name, String rfidName, int quantity, double price) {
        if (name.length() <= 25) {
            this.name = name.substring(0, 1).toUpperCase() + name.substring(1, name.length()).toLowerCase();
            this.rfidName = rfidName;
            this.quantity = quantity;
            this.price = price;
        } else {
            throw new IllegalArgumentException("Name was too long");
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getRfidName() {
        return rfidName;
    }

    public void setRfidName(String rfidName) {
        this.rfidName = rfidName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
