package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Order;
import model.Product;

public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * GET /order
     *
     * Flow 1 — Cart checkout:
     *   Called with NO parameters (from "Proceed to Order" button in cart).
     *   Reads the "cart" list from the session, groups items by name,
     *   looks up each product's price from the allProducts list stored in
     *   ServletContext, then forwards to order.jsp with:
     *     - request attr "orderItems"  : List<Map<String,Object>>
     *                                    each map has keys: name, qty, unitPrice, subtotal
     *     - request attr "orderTotal"  : double
     *     - request attr "orderSource" : "cart"
     *
     * Flow 2 — Direct product checkout:
     *   Called with ?product=<name>&quantity=<n> (from product card "Order" button).
     *   Looks up the single product, then forwards to order.jsp with:
     *     - request attr "orderItems"  : List<Map<String,Object>> (single entry)
     *     - request attr "orderTotal"  : double
     *     - request attr "orderSource" : "direct"
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve the master product list stored by ProductServlet
        @SuppressWarnings("unchecked")
        List<Product> allProducts =
                (List<Product>) getServletContext().getAttribute("allProducts");

        String productParam = request.getParameter("product");

        List<Map<String, Object>> orderItems = new ArrayList<>();
        double orderTotal = 0.0;
        String orderSource;

        if (productParam != null && !productParam.trim().isEmpty()) {
            // ── Flow 2: Direct product checkout ──────────────────────────────
            orderSource = "direct";

            int qty = 1;
            try {
                qty = Integer.parseInt(request.getParameter("quantity"));
                if (qty < 1) qty = 1;
            } catch (NumberFormatException ignored) {}

            Product found = findProduct(allProducts, productParam.trim());
            if (found != null) {
                double subtotal = found.getPrice() * qty;
                orderTotal = subtotal;

                Map<String, Object> item = new LinkedHashMap<>();
                item.put("name",       found.getName());
                item.put("category",   found.getCategory());
                item.put("unitPrice",  found.getPrice());
                item.put("qty",        qty);
                item.put("subtotal",   subtotal);
                orderItems.add(item);
            }

        } else {
            // ── Flow 1: Cart checkout ─────────────────────────────────────────
            orderSource = "cart";

            HttpSession session = request.getSession(false);
            @SuppressWarnings("unchecked")
            List<String> cart = (session != null)
                    ? (List<String>) session.getAttribute("cart")
                    : null;

            if (cart != null && !cart.isEmpty()) {
                // Group cart items by name → count
                Map<String, Integer> countMap = new LinkedHashMap<>();
                for (String name : cart) {
                    countMap.put(name, countMap.getOrDefault(name, 0) + 1);
                }

                for (Map.Entry<String, Integer> entry : countMap.entrySet()) {
                    String name = entry.getKey();
                    int qty     = entry.getValue();
                    Product found = findProduct(allProducts, name);

                    Map<String, Object> item = new LinkedHashMap<>();
                    item.put("name",      name);
                    item.put("category",  found != null ? found.getCategory() : "");
                    item.put("unitPrice", found != null ? found.getPrice()    : 0.0);
                    item.put("qty",       qty);
                    double subtotal = (found != null ? found.getPrice() : 0.0) * qty;
                    item.put("subtotal",  subtotal);
                    orderTotal += subtotal;
                    orderItems.add(item);
                }
            }
        }

        request.setAttribute("orderItems",  orderItems);
        request.setAttribute("orderTotal",  orderTotal);
        request.setAttribute("orderSource", orderSource);

        request.getRequestDispatcher("order.jsp").forward(request, response);
    }

    // ── POST: handle the order form submission ────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String customerName = trimParam(request.getParameter("customerName"));
        String email        = trimParam(request.getParameter("email"));
        String checkoutMode = trimParam(request.getParameter("checkoutMode"));

        HttpSession session = request.getSession();

        String productName;
        int quantity;

        if ("cart".equals(checkoutMode)) {
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> checkoutItems =
                    (List<Map<String, Object>>) session.getAttribute("checkoutItems");

            if (checkoutItems == null || checkoutItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            StringBuilder summary = new StringBuilder();
            quantity = 0;
            for (int i = 0; i < checkoutItems.size(); i++) {
                Map<String, Object> item = checkoutItems.get(i);
                String name = String.valueOf(item.get("name"));
                int qty = item.get("qty") instanceof Number
                        ? ((Number) item.get("qty")).intValue() : 1;
                quantity += qty;
                if (i > 0) {
                    summary.append(", ");
                }
                summary.append(name).append(" (x").append(qty).append(")");
            }
            productName = summary.toString();
        } else {
            productName = trimParam(request.getParameter("productName"));
            quantity = 1;
            try {
                String qtyParam = request.getParameter("quantity");
                if (qtyParam != null && !qtyParam.trim().isEmpty()) {
                    quantity = Integer.parseInt(qtyParam.trim());
                }
            } catch (NumberFormatException ignored) {
                quantity = 1;
            }
            if (quantity < 1) {
                quantity = 1;
            }
        }

        if (customerName.isEmpty() || email.isEmpty() || productName.isEmpty()) {
            request.setAttribute("formError", "Please complete all required fields.");
            if ("cart".equals(checkoutMode)) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> checkoutItems =
                        (List<Map<String, Object>>) session.getAttribute("checkoutItems");
                if (checkoutItems != null && !checkoutItems.isEmpty()) {
                    request.setAttribute("orderItems", checkoutItems);
                    Object total = session.getAttribute("checkoutTotal");
                    if (total instanceof Number) {
                        request.setAttribute("orderTotal", total);
                    }
                    request.setAttribute("orderSource", "cart");
                }
            }
            request.getRequestDispatcher("order.jsp").forward(request, response);
            return;
        }

        Order order = new Order(customerName, email, productName, quantity);

        session.setAttribute("lastOrder", order);
        session.removeAttribute("cart");
        session.removeAttribute("checkoutItems");
        session.removeAttribute("checkoutTotal");
        session.removeAttribute("lockedCheckoutProduct");
        session.removeAttribute("lockedCheckoutMaxQty");

        response.sendRedirect(request.getContextPath() + "/confirmation.jsp");
    }

    private static String trimParam(String value) {
        return value == null ? "" : value.trim();
    }

    // ── Helper ────────────────────────────────────────────────────────────────
    private Product findProduct(List<Product> products, String name) {
        if (products == null || name == null) return null;
        for (Product p : products) {
            if (p.getName().equalsIgnoreCase(name)) return p;
        }
        return null;
    }
}
