<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.util.List, java.util.Map, java.util.LinkedHashMap, java.net.URLEncoder" %>
<%
    String ctx = request.getContextPath();

    List<String> cart = (List<String>) session.getAttribute("cart");
    Map<String, Integer> itemCounts = new LinkedHashMap<>();
    int totalItems = 0;

    if (cart != null) {
        for (String item : cart) {
            itemCounts.put(item, itemCounts.getOrDefault(item, 0) + 1);
            totalItems++;
        }
    }

    boolean isEmpty = itemCounts.isEmpty();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shopping Cart — Ceylon Authentic Store</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" crossorigin="anonymous">

<style>
:root {
    --green-dark: #0f5132;
    --green-mid: #198754;
    --gold: #ffc107;
    --beige: #f5f0e8;
    --beige-soft: #faf7f2;
    --white: #ffffff;
    --text: #1a2e24;
    --text-muted: #5c6b63;
    --border: rgba(15, 81, 50, 0.12);
    --shadow-sm: 0 4px 16px rgba(15, 81, 50, 0.08);
    --shadow-md: 0 12px 32px rgba(15, 81, 50, 0.14);
    --radius: 16px;
    --radius-lg: 24px;
    --nav-h: 72px;
    --transition: 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
    font-family: "Outfit", system-ui, sans-serif;
    background: var(--beige-soft);
    color: var(--text);
    line-height: 1.6;
    min-height: 100vh;
}

h1, h2, h3 {
    font-family: "Cormorant Garamond", Georgia, serif;
    font-weight: 600;
    line-height: 1.2;
}

a { text-decoration: none; color: inherit; }

.container {
    width: 100%;
    max-width: 1100px;
    margin: 0 auto;
    padding: 0 24px;
}

/* Navbar */
.navbar {
    position: fixed;
    top: 0; left: 0; right: 0;
    height: var(--nav-h);
    z-index: 1000;
    background: rgba(255, 255, 255, 0.96);
    backdrop-filter: blur(14px);
    border-bottom: 1px solid var(--border);
    box-shadow: 0 2px 20px rgba(15, 81, 50, 0.06);
}

.nav-inner {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
}

.logo { display: flex; align-items: center; gap: 10px; }

.logo-icon {
    width: 42px; height: 42px;
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    color: var(--gold); font-size: 18px;
}

.logo-text { display: flex; flex-direction: column; line-height: 1.15; }

.logo-text strong {
    font-family: "Cormorant Garamond", serif;
    font-size: 1.25rem;
    color: var(--green-dark);
    font-weight: 700;
}

.logo-text span {
    font-size: 0.65rem;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: var(--text-muted);
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 6px;
    list-style: none;
}

.nav-links a {
    padding: 10px 16px;
    font-size: 0.95rem;
    font-weight: 500;
    border-radius: 10px;
    transition: color var(--transition), background var(--transition);
}

.nav-links a:hover,
.nav-links a.active {
    color: var(--green-dark);
    background: rgba(15, 81, 50, 0.06);
}

.nav-actions { display: flex; align-items: center; gap: 12px; }

.cart-btn {
    position: relative;
    width: 44px; height: 44px;
    border-radius: 12px;
    background: var(--green-dark);
    color: var(--gold);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
}

.cart-badge {
    position: absolute;
    top: -4px; right: -4px;
    min-width: 20px; height: 20px;
    padding: 0 5px;
    background: var(--gold);
    color: var(--green-dark);
    font-size: 0.7rem;
    font-weight: 700;
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
}

.menu-toggle {
    display: none;
    width: 44px; height: 44px;
    border: none;
    background: var(--beige);
    border-radius: 12px;
    color: var(--green-dark);
    font-size: 1.25rem;
    cursor: pointer;
}

/* Page header */
.page-header {
    padding: calc(var(--nav-h) + 48px) 0 36px;
    text-align: center;
}

.breadcrumb {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 0.875rem;
    color: var(--text-muted);
    margin-bottom: 20px;
}

.breadcrumb a { color: var(--green-mid); font-weight: 500; }
.breadcrumb a:hover { color: var(--green-dark); }
.breadcrumb i { font-size: 0.65rem; opacity: 0.5; }

.page-header h1 {
    font-size: clamp(2rem, 5vw, 2.75rem);
    color: var(--green-dark);
    margin-bottom: 10px;
}

.page-header p {
    color: var(--text-muted);
    font-size: 1.05rem;
}

.item-count-pill {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-top: 16px;
    padding: 8px 18px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 100px;
    font-size: 0.9rem;
    font-weight: 500;
    color: var(--green-dark);
    box-shadow: var(--shadow-sm);
}

.item-count-pill i { color: var(--green-mid); }

/* Layout */
.cart-layout {
    display: grid;
    grid-template-columns: 1fr 320px;
    gap: 32px;
    align-items: start;
    padding-bottom: 80px;
}

/* Cart card */
.cart-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    box-shadow: var(--shadow-sm);
    overflow: hidden;
}

.cart-card-header {
    padding: 24px 28px;
    border-bottom: 1px solid var(--border);
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    background: linear-gradient(180deg, var(--beige-soft) 0%, var(--white) 100%);
}

.cart-card-header h2 {
    font-size: 1.35rem;
    color: var(--green-dark);
    display: flex;
    align-items: center;
    gap: 10px;
}

.cart-card-header h2 i { color: var(--green-mid); font-size: 1rem; }

.cart-card-header span {
    font-size: 0.85rem;
    color: var(--text-muted);
    font-family: "Outfit", sans-serif;
    font-weight: 500;
}

/* Cart items */
.cart-items { padding: 8px 0; }

.cart-item {
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 20px 28px;
    border-bottom: 1px solid var(--border);
    transition: background var(--transition);
}

.cart-item:last-child { border-bottom: none; }

.cart-item:hover { background: var(--beige-soft); }

.item-thumb {
    width: 72px; height: 72px;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.6rem;
    flex-shrink: 0;
}

.item-thumb.tea { background: linear-gradient(135deg, #2d5a3d, #4a7c59); color: #e8f5e9; }
.item-thumb.spice { background: linear-gradient(135deg, #8b4513, #c67c2e); color: #fff3e0; }
.item-thumb.craft { background: linear-gradient(135deg, #5c3d6e, #8e5a9b); color: #f3e5f5; }
.item-thumb.herbal { background: linear-gradient(135deg, #1b5e4a, #2e8b6e); color: #e0f2f1; }
.item-thumb.default { background: linear-gradient(135deg, var(--green-dark), var(--green-mid)); color: var(--gold); }

.item-info { flex: 1; min-width: 0; }

.item-info h3 {
    font-size: 1.15rem;
    color: var(--green-dark);
    margin-bottom: 4px;
}

.item-info p {
    font-size: 0.85rem;
    color: var(--text-muted);
}

.item-qty {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
    padding: 10px 16px;
    background: var(--beige-soft);
    border-radius: 12px;
    min-width: 64px;
}

.item-qty .qty-num {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--green-dark);
    line-height: 1;
}

.item-qty .qty-label {
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.06em;
    color: var(--text-muted);
    font-weight: 600;
}

.item-actions { flex-shrink: 0; }

.btn-item-order {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 16px;
    font-size: 0.875rem;
    font-weight: 600;
    color: var(--white);
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    border-radius: 10px;
    white-space: nowrap;
    transition: transform var(--transition), box-shadow var(--transition);
    box-shadow: 0 4px 14px rgba(15, 81, 50, 0.2);
}

.btn-item-order:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 18px rgba(15, 81, 50, 0.28);
}

/* Empty state */
.empty-cart {
    padding: 56px 32px;
    text-align: center;
}

.empty-icon {
    width: 100px; height: 100px;
    margin: 0 auto 24px;
    background: var(--beige);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2.5rem;
    color: var(--text-muted);
}

.empty-cart h2 {
    font-size: 1.5rem;
    color: var(--green-dark);
    margin-bottom: 10px;
}

.empty-cart p {
    color: var(--text-muted);
    max-width: 360px;
    margin: 0 auto 28px;
}

/* Summary sidebar */
.summary-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    box-shadow: var(--shadow-sm);
    padding: 28px;
    position: sticky;
    top: calc(var(--nav-h) + 24px);
}

.summary-card h3 {
    font-size: 1.3rem;
    color: var(--green-dark);
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border);
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    font-size: 0.95rem;
}

.summary-row .label { color: var(--text-muted); }

.summary-row .value { font-weight: 600; color: var(--text); }

.summary-total {
    margin-top: 16px;
    padding-top: 16px;
    border-top: 2px dashed var(--border);
}

.summary-total .label {
    font-size: 1rem;
    font-weight: 600;
    color: var(--green-dark);
}

.summary-total .value {
    font-family: "Cormorant Garamond", serif;
    font-size: 1.5rem;
    color: var(--green-dark);
    font-weight: 700;
}

.summary-note {
    font-size: 0.8rem;
    color: var(--text-muted);
    margin-top: 12px;
    line-height: 1.5;
}

.summary-actions {
    display: flex;
    flex-direction: column;
    gap: 12px;
    margin-top: 24px;
}

.btn {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 14px 24px;
    font-family: inherit;
    font-size: 0.95rem;
    font-weight: 600;
    border-radius: 12px;
    border: 2px solid transparent;
    cursor: pointer;
    transition: transform var(--transition), box-shadow var(--transition), background var(--transition);
}

.btn-primary {
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    color: var(--white);
    box-shadow: 0 6px 20px rgba(15, 81, 50, 0.25);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 28px rgba(15, 81, 50, 0.32);
}

.btn-outline {
    background: var(--white);
    color: var(--green-dark);
    border-color: var(--border);
}

.btn-outline:hover {
    background: var(--beige-soft);
    border-color: var(--green-mid);
}

.btn:disabled,
.btn.disabled {
    opacity: 0.45;
    pointer-events: none;
    cursor: not-allowed;
    transform: none !important;
    box-shadow: none !important;
}

.trust-row {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid var(--border);
}

.trust-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-size: 0.75rem;
    color: var(--text-muted);
    background: var(--beige-soft);
    padding: 6px 10px;
    border-radius: 8px;
}

.trust-tag i { color: var(--green-mid); }

.page-footer {
    text-align: center;
    padding: 24px;
    font-size: 0.85rem;
    color: var(--text-muted);
    border-top: 1px solid var(--border);
    background: var(--white);
}

@media (max-width: 900px) {
    .cart-layout { grid-template-columns: 1fr; }
    .summary-card { position: static; }
}

@media (max-width: 640px) {
    .nav-links {
        display: none;
        position: absolute;
        top: var(--nav-h); left: 0; right: 0;
        flex-direction: column;
        background: var(--white);
        padding: 16px;
        border-bottom: 1px solid var(--border);
        box-shadow: var(--shadow-md);
    }
    .nav-links.open { display: flex; }
    .menu-toggle { display: flex; align-items: center; justify-content: center; }
    .cart-item { padding: 16px 20px; gap: 14px; flex-wrap: wrap; }
    .item-thumb { width: 56px; height: 56px; font-size: 1.25rem; }
    .item-actions { width: 100%; }
    .btn-item-order { width: 100%; justify-content: center; }
}
</style>
</head>

<body>

<nav class="navbar">
    <div class="container nav-inner">
        <a href="<%= ctx %>/home" class="logo">
            <div class="logo-icon"><i class="fas fa-leaf"></i></div>
            <div class="logo-text">
                <strong>Ceylon Authentic</strong>
                <span>Sri Lankan Heritage</span>
            </div>
        </a>
        <ul class="nav-links" id="navLinks">
            <li><a href="<%= ctx %>/home">Home</a></li>
            <li><a href="<%= ctx %>/products">Products</a></li>
            <li><a href="<%= ctx %>/cart" class="active">Cart</a></li>
            <li><a href="<%= ctx %>/order.jsp">Order</a></li>
        </ul>
        <div class="nav-actions">
            <a href="<%= ctx %>/cart" class="cart-btn" aria-label="Shopping cart">
                <i class="fas fa-shopping-bag"></i>
                <% if (totalItems > 0) { %>
                <span class="cart-badge"><%= totalItems %></span>
                <% } %>
            </a>
            <button class="menu-toggle" id="menuToggle" type="button" aria-label="Open menu">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </div>
</nav>

<header class="page-header">
    <div class="container">
        <nav class="breadcrumb" aria-label="Breadcrumb">
            <a href="<%= ctx %>/home"><i class="fas fa-home"></i> Home</a>
            <i class="fas fa-chevron-right"></i>
            <span>Cart</span>
        </nav>
        <h1>Your Shopping Cart</h1>
        <p>Review your selected authentic Ceylon products before checkout.</p>
        <% if (!isEmpty) { %>
        <div class="item-count-pill">
            <i class="fas fa-bag-shopping"></i>
            <%= totalItems %> item<%= totalItems == 1 ? "" : "s" %> in your cart
        </div>
        <% } %>
    </div>
</header>

<main class="container cart-layout">

    <div class="cart-card">
        <div class="cart-card-header">
            <h2><i class="fas fa-shopping-cart"></i> Cart Items</h2>
            <% if (!isEmpty) { %>
            <span><%= itemCounts.size() %> product<%= itemCounts.size() == 1 ? "" : "s" %></span>
            <% } %>
        </div>

        <% if (isEmpty) { %>
        <div class="empty-cart">
            <div class="empty-icon"><i class="fas fa-cart-shopping"></i></div>
            <h2>Your cart is empty</h2>
            <p>Discover premium Ceylon tea, spices, and handcrafted treasures from Sri Lanka.</p>
            <a href="<%= ctx %>/products" class="btn btn-primary" style="display:inline-flex;">
                <i class="fas fa-compass"></i> Browse Products
            </a>
        </div>
        <% } else { %>
        <div class="cart-items">
            <%
            for (Map.Entry<String, Integer> entry : itemCounts.entrySet()) {
                String name = entry.getKey();
                int qty = entry.getValue();
                String thumbClass = "default";
                String icon = "fa-leaf";
                String category = "Authentic Ceylon product";

                String lower = name.toLowerCase();
                if (lower.contains("tea")) {
                    thumbClass = "tea";
                    icon = "fa-mug-hot";
                    category = "Premium Ceylon tea";
                } else if (lower.contains("cinnamon") || lower.contains("cardamom") || lower.contains("spice")) {
                    thumbClass = "spice";
                    icon = "fa-mortar-pestle";
                    category = "Fine Ceylon spice";
                } else if (lower.contains("batik") || lower.contains("shawl") || lower.contains("craft")) {
                    thumbClass = "craft";
                    icon = "fa-shirt";
                    category = "Handcrafted heritage";
                } else if (lower.contains("herbal") || lower.contains("oil") || lower.contains("ayurvedic")) {
                    thumbClass = "herbal";
                    icon = "fa-spa";
                    category = "Natural wellness";
                }
            %>
            <article class="cart-item">
                <div class="item-thumb <%= thumbClass %>">
                    <i class="fas <%= icon %>"></i>
                </div>
                <div class="item-info">
                    <h3><%= name %></h3>
                    <p><%= category %></p>
                </div>
                <div class="item-qty" title="Quantity">
                    <span class="qty-num"><%= qty %></span>
                    <span class="qty-label">Qty</span>
                </div>
                <div class="item-actions">
                    <a href="<%= ctx %>/order.jsp?product=<%= URLEncoder.encode(name, "UTF-8") %>&quantity=<%= qty %>"
                       class="btn-item-order" title="Order this item only">
                        <i class="fas fa-bolt"></i> Order
                    </a>
                </div>
            </article>
            <%
            }
            %>
        </div>
        <% } %>
    </div>

    <aside class="summary-card">
    <h3>Order Summary</h3>

    <div class="summary-row">
        <span class="label">Products</span>
        <span class="value"><%= isEmpty ? 0 : itemCounts.size() %></span>
    </div>
    <div class="summary-row">
        <span class="label">Total items</span>
        <span class="value"><%= totalItems %></span>
    </div>
    <div class="summary-row summary-total">
        <span class="label">Status</span>
        <span class="value"><%= isEmpty ? "—" : "Ready" %></span>
    </div>

    <p class="summary-note">
        <i class="fas fa-info-circle"></i>
        <% if (isEmpty) { %>
            Add products to your cart, then use <strong>Proceed to Order</strong> to checkout.
        <% } else { %>
            Use <strong>Proceed to Order</strong> to checkout all items, or <strong>Order</strong> on a single item for that product only.
        <% } %>
    </p>

    <div class="summary-actions">
        <a href="<%= ctx %>/order"
           class="btn btn-primary<%= isEmpty ? " disabled" : "" %>"
           <%= isEmpty ? "aria-disabled='true' tabindex='-1'" : "" %>>
            <i class="fas fa-receipt"></i> Proceed to Order
        </a>
        <a href="<%= ctx %>/products" class="btn btn-outline">
            <i class="fas fa-store"></i> Continue Shopping
        </a>
    </div>

    <div class="trust-row">
        <span class="trust-tag"><i class="fas fa-leaf"></i> Authentic</span>
        <span class="trust-tag"><i class="fas fa-truck"></i> Careful packing</span>
        <span class="trust-tag"><i class="fas fa-shield-halved"></i> Trusted</span>
    </div>
</aside>

</main>

<footer class="page-footer">
    &copy; Ceylon Authentic Store — Authentic Sri Lankan Heritage
</footer>

<script>
(function () {
    var menuToggle = document.getElementById("menuToggle");
    var navLinks = document.getElementById("navLinks");
    if (menuToggle && navLinks) {
        menuToggle.addEventListener("click", function () {
            navLinks.classList.toggle("open");
        });
    }
})();
</script>

</body>
</html>
