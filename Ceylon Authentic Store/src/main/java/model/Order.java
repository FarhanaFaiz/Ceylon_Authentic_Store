package model;

public class Order {

    private String customerName;
    private String email;
    private String productName;
    private int quantity;

    // Constructor
    public Order(String customerName, String email,
                 String productName, int quantity) {

        this.customerName = customerName;
        this.email = email;
        this.productName = productName;
        this.quantity = quantity;
    }

    // Getters

    public String getCustomerName() {
        return customerName;
    }

    public String getEmail() {
        return email;
    }

    public String getProductName() {
        return productName;
    }

    public int getQuantity() {
        return quantity;
    }
}