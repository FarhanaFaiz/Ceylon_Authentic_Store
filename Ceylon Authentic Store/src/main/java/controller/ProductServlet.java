package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Product;

public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> productList = new ArrayList<>();

        // Tea Products
        productList.add(new Product(
                "Ceylon Black Tea",
                "Tea",
                1500.00,
                "Premium Sri Lankan black tea with rich aroma and strong taste.",
                "black tea.jpg"
        ));

        productList.add(new Product(
                "Ceylon Green Tea",
                "Tea",
                1700.00,
                "Healthy green tea made from high-quality Ceylon tea leaves.",
                "Ceylon-Green-Tea.jpg"
        ));

        productList.add(new Product(
                "Herbal  Tea",
                "Tea",
                1600.00,
                "Natural Sri Lankan herbal tea made with healthy organic ingredients.",
                "herbal tea.jpg"
        ));

        productList.add(new Product(
                "Cinnamon tea",
                "Tea",
                1800.00,
                "Refreshing Ceylon cinnamon tea with rich aroma and natural flavor.",
                "cinomen tea.png"
        ));

        // Spice Products
        productList.add(new Product(
                "Ceylon Cinnamon",
                "Spices",
                1200.00,
                "Pure Sri Lankan cinnamon sticks with natural fragrance.",
                "ceylon cinamon.webp"
        ));

        productList.add(new Product(
                "Black Pepper",
                "Spices",
                900.00,
                "Fresh Sri Lankan black pepper.",
                "black pepper.jpg"
        ));

        productList.add(new Product(
                "Cardamom",
                "Spices",
                2200.00,
                "Premium Sri Lankan cardamom with strong aroma and rich flavor.",
                "cardomom.jpg"
        ));

        productList.add(new Product(
                "Cloves",
                "Spices",
                1700.00,
                "High-quality Sri Lankan cloves used for cooking and herbal beverages.",
                "cloves.jpg"
        ));

        // Batik Products
        productList.add(new Product(
                "Batik Table Runner",
                "Batik Fashion",
                2400.00,
                "Elegant batik table runner for home decoration and cultural styling.",
                "table.jpg"
        ));

        productList.add(new Product(
                "Batik Saree",
                "Batik Fashion",
                6500.00,
                "Elegant traditional batik saree.",
                "batik saree.jpg"
        ));

        productList.add(new Product(
                "Batik Handbag",
                "Batik Fashion",
                2200.00,
                "Stylish handmade Sri Lankan batik handbag with colorful traditional designs.",
                "Batik-Bag-Green-Floral1.jpg"
        ));

        productList.add(new Product(
                "Batik Wall Art",
                "Batik Fashion",
                3500.00,
                "Hand-painted batik wall decoration inspired by Sri Lankan heritage.",
                "bartik wall art.jpg"
        ));

        // Ayurvedic Products
        productList.add(new Product(
                "Herbal Oil",
                "Ayurveda",
                1800.00,
                "Natural Ayurvedic herbal oil.",
                "oill.jpg"
        ));

        productList.add(new Product(
                "skincare",
                "Ayurveda",
                2500.00,
                "Ayurvedic skincare cream made using traditional Sri Lankan herbal ingredients.",
                "cream.jpg"
        ));

        productList.add(new Product(
                "soaps",
                "Ayurveda",
                1800.00,
                "Natural Ayurvedic herbal soap.",
                "soap.jpg"
        ));

        productList.add(new Product(
                "wellness items",
                "Ayurveda",
                1800.00,
                "Traditional Ayurvedic wellness products for daily health care.",
                "welness itms.jpg"
        ));

        // Handicrafts
        productList.add(new Product(
                "Wooden Elephant",
                "Handicrafts",
                3000.00,
                "Hand-carved wooden elephant craft.",
                "wooden elephant.jpg"
        ));

        productList.add(new Product(
                "Traditional Sri Lankan Mask",
                "Handicrafts",
                3200.00,
                "Colorful handmade traditional mask inspired by Sri Lankan cultural art.",
                "mask.jpg"
        ));

        productList.add(new Product(
                "handmade decorations",
                "Handicrafts",
                2600.00,
                "Beautiful handmade Sri Lankan decorative crafts for home styling.",
                "h md.jpg"
        ));

        productList.add(new Product(
                "Coconut Shell Decoration",
                "Handicrafts",
                2200.00,
                "Eco-friendly handmade decoration crafted from natural coconut shell.",
                "cocount  s hell.jpg"
        ));
        getServletContext().setAttribute("allProducts", productList);

        request.setAttribute("products", productList);

        request.getRequestDispatcher("products.jsp").forward(request, response);
    }
}
