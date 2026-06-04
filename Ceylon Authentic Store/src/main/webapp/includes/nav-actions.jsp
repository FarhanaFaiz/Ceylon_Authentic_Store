<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String navCtx = request.getContextPath();
    int navCartCount = 0;
    Object countAttr = request.getAttribute("navCartCount");
    if (countAttr instanceof Number) {
        navCartCount = ((Number) countAttr).intValue();
    } else {
        java.util.List<?> cart = (java.util.List<?>) session.getAttribute("cart");
        if (cart != null) {
            navCartCount = cart.size();
        }
    }
%>
<a href="<%= navCtx %>/cart" class="cart-btn" aria-label="Shopping cart">
    <i class="fas fa-shopping-bag"></i>
    <% if (navCartCount > 0) { %>
    <span class="cart-badge"><%= navCartCount %></span>
    <% } %>
</a>
<button class="menu-toggle" id="menuToggle" type="button" aria-label="Open menu">
    <i class="fas fa-bars"></i>
</button>
