<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.net.URLEncoder, java.util.List" %>
<%@ page import="model.Product" %>
<%
    String ctx = request.getContextPath();
    String catParam = request.getParameter("category");
    String filterCategory = null;
    String pageHeading = "Authentic Sri Lankan Products";
    String pageSubtitle = "Explore premium tea, spices, batik, ayurveda, and handcrafted treasures";

    if (catParam != null) {
        switch (catParam.toLowerCase()) {
            case "tea":
                filterCategory = "Tea";
                pageHeading = "Tea Products";
                pageSubtitle = "Premium Ceylon tea blends with rich aroma and heritage";
                break;
            case "spices":
                filterCategory = "Spices";
                pageHeading = "Spice Products";
                pageSubtitle = "Pure Sri Lankan spices from the pearl of the Indian Ocean";
                break;
            case "batik":
                filterCategory = "Batik Fashion";
                pageHeading = "Batik Fashion";
                pageSubtitle = "Handwoven batik and traditional Sri Lankan fashion";
                break;
            case "ayurveda":
                filterCategory = "Ayurveda";
                pageHeading = "Ayurvedic Products";
                pageSubtitle = "Natural wellness rooted in ancient Ayurvedic tradition";
                break;
            case "handicrafts":
                filterCategory = "Handicrafts";
                pageHeading = "Handicraft Products";
                pageSubtitle = "Artisan crafts and heritage keepsakes from Ceylon";
                break;
        }
    }

    boolean showAll = (filterCategory == null);
    boolean showTea = showAll || "Tea".equals(filterCategory);
    boolean showSpices = showAll || "Spices".equals(filterCategory);
    boolean showBatik = showAll || "Batik Fashion".equals(filterCategory);
    boolean showAyurveda = showAll || "Ayurveda".equals(filterCategory);
    boolean showHandicrafts = showAll || "Handicrafts".equals(filterCategory);

    List<Product> products = (List<Product>) request.getAttribute("products");

    List<String> cart = (List<String>) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.size() : 0;

    String[][] sections = {
        {"tea", "Tea Products", "Tea", "fa-mug-hot", String.valueOf(showTea)},
        {"spices", "Spice Products", "Spices", "fa-mortar-pestle", String.valueOf(showSpices)},
        {"batik", "Batik Fashion", "Batik Fashion", "fa-shirt", String.valueOf(showBatik)},
        {"ayurveda", "Ayurvedic Products", "Ayurveda", "fa-spa", String.valueOf(showAyurveda)},
        {"handicrafts", "Handicraft Products", "Handicrafts", "fa-hands", String.valueOf(showHandicrafts)}
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%= pageHeading %> — Ceylon Authentic Store</title>
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
    max-width: 1240px;
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
    background: var(--beige);
    color: var(--green-dark);
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem;
    transition: transform var(--transition), background var(--transition);
}

.cart-btn:hover {
    background: var(--green-dark);
    color: var(--gold);
    transform: translateY(-2px);
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
    padding: calc(var(--nav-h) + 48px) 0 32px;
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
.breadcrumb i { font-size: 0.65rem; opacity: 0.5; }

.page-header h1 {
    font-size: clamp(2rem, 5vw, 2.75rem);
    color: var(--green-dark);
    margin-bottom: 12px;
}

.page-header p {
    max-width: 560px;
    margin: 0 auto;
    color: var(--text-muted);
    font-size: 1.05rem;
}

/* Category filters */
.filter-bar {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 10px;
    padding: 8px 0 48px;
}

.filter-pill {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 18px;
    font-size: 0.9rem;
    font-weight: 500;
    color: var(--text);
    background: var(--white);
    border: 2px solid var(--border);
    border-radius: 100px;
    transition: all var(--transition);
}

.filter-pill:hover {
    border-color: var(--green-mid);
    color: var(--green-dark);
    transform: translateY(-2px);
    box-shadow: var(--shadow-sm);
}

.filter-pill.active {
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    color: var(--white);
    border-color: transparent;
    box-shadow: 0 6px 20px rgba(15, 81, 50, 0.25);
}

.filter-pill.active i { color: var(--gold); }

.filter-pill i { font-size: 0.85rem; color: var(--green-mid); }

/* Category sections */
.category-section {
    margin-bottom: 64px;
    scroll-margin-top: calc(var(--nav-h) + 24px);
}

.section-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 28px;
    padding-bottom: 16px;
    border-bottom: 2px solid var(--border);
}

.section-head h2 {
    font-size: 1.75rem;
    color: var(--green-dark);
    display: flex;
    align-items: center;
    gap: 12px;
}

.section-head h2 i {
    width: 44px; height: 44px;
    background: rgba(15, 81, 50, 0.08);
    border-radius: 12px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1rem;
    color: var(--green-mid);
}

.section-head a {
    font-size: 0.9rem;
    font-weight: 600;
    color: var(--green-mid);
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

.section-head a:hover { color: var(--green-dark); }

/* Product grid */
.product-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 28px;
}

.product-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    border: 1px solid var(--border);
    overflow: hidden;
    box-shadow: var(--shadow-sm);
    display: flex;
    flex-direction: column;
    transition: transform var(--transition), box-shadow var(--transition);
}

.product-card:hover {
    transform: translateY(-8px);
    box-shadow: var(--shadow-md);
}

.card-image-wrap {
    position: relative;
    height: 200px;
    overflow: hidden;
    background: var(--beige);
}

.card-image-wrap img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.product-card:hover .card-image-wrap img {
    transform: scale(1.06);
}

.card-body {
    padding: 22px;
    display: flex;
    flex-direction: column;
    flex: 1;
}

.card-body h3 {
    font-size: 1.2rem;
    color: var(--green-dark);
    margin-bottom: 8px;
}

.card-desc {
    font-size: 0.875rem;
    color: var(--text-muted);
    margin-bottom: 16px;
    flex: 1;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.card-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 16px;
}

.price {
    font-family: "Cormorant Garamond", serif;
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--green-dark);
    line-height: 1;
}

.price span {
    font-family: "Outfit", sans-serif;
    font-size: 0.75rem;
    font-weight: 600;
    color: var(--text-muted);
    display: block;
    margin-bottom: 2px;
}

.card-actions {
    display: flex;
    gap: 10px;
}

.btn {
    flex: 1;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 11px 14px;
    font-family: inherit;
    font-size: 0.85rem;
    font-weight: 600;
    border-radius: 10px;
    border: 2px solid transparent;
    transition: transform var(--transition), box-shadow var(--transition), background var(--transition);
}

.btn-cart {
    background: var(--beige);
    color: var(--green-dark);
    border-color: var(--border);
}

.btn-cart:hover {
    background: var(--green-dark);
    color: var(--gold);
    border-color: var(--green-dark);
    transform: translateY(-2px);
}

.btn-order {
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    color: var(--white);
    box-shadow: 0 4px 14px rgba(15, 81, 50, 0.2);
}

.btn-order:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 22px rgba(15, 81, 50, 0.3);
}

.empty-msg {
    text-align: center;
    padding: 48px 24px;
    color: var(--text-muted);
    background: var(--white);
    border-radius: var(--radius);
    border: 1px dashed var(--border);
}

.page-footer {
    text-align: center;
    padding: 24px;
    font-size: 0.85rem;
    color: var(--text-muted);
    border-top: 1px solid var(--border);
    background: var(--white);
    margin-top: 24px;
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
    .card-actions { flex-direction: column; }
    .filter-bar { gap: 8px; }
    .filter-pill { padding: 8px 14px; font-size: 0.8rem; }
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
            <li><a href="<%= ctx %>/products" class="active">Products</a></li>
            <li><a href="<%= ctx %>/cart">Cart</a></li>
            <li><a href="<%= ctx %>/order.jsp">Order</a></li>
        </ul>
        <div class="nav-actions">
            <% request.setAttribute("navCartCount", cartCount); %>
            <jsp:include page="/includes/nav-actions.jsp" />
        </div>
    </div>
</nav>

<header class="page-header">
    <div class="container">
        <nav class="breadcrumb" aria-label="Breadcrumb">
            <a href="<%= ctx %>/home"><i class="fas fa-home"></i> Home</a>
            <i class="fas fa-chevron-right"></i>
            <span>Products</span>
        </nav>
        <h1><%= pageHeading %></h1>
        <p><%= pageSubtitle %></p>
    </div>
</header>

<div class="container filter-bar">
    <a href="<%= ctx %>/products" class="filter-pill<%= showAll ? " active" : "" %>">
        <i class="fas fa-grid-2"></i> All
    </a>
    <a href="<%= ctx %>/products?category=tea" class="filter-pill<%= "Tea".equals(filterCategory) ? " active" : "" %>">
        <i class="fas fa-mug-hot"></i> Tea
    </a>
    <a href="<%= ctx %>/products?category=spices" class="filter-pill<%= "Spices".equals(filterCategory) ? " active" : "" %>">
        <i class="fas fa-mortar-pestle"></i> Spices
    </a>
    <a href="<%= ctx %>/products?category=batik" class="filter-pill<%= "Batik Fashion".equals(filterCategory) ? " active" : "" %>">
        <i class="fas fa-shirt"></i> Batik
    </a>
    <a href="<%= ctx %>/products?category=ayurveda" class="filter-pill<%= "Ayurveda".equals(filterCategory) ? " active" : "" %>">
        <i class="fas fa-spa"></i> Ayurveda
    </a>
    <a href="<%= ctx %>/products?category=handicrafts" class="filter-pill<%= "Handicrafts".equals(filterCategory) ? " active" : "" %>">
        <i class="fas fa-hands"></i> Handicrafts
    </a>
</div>

<main class="container" style="padding-bottom: 64px;">

<%
if (products == null || products.isEmpty()) {
%>
    <p class="empty-msg">No products available at the moment. Please check back soon.</p>
<%
} else {
    for (String[] section : sections) {
        if (!"true".equals(section[4])) continue;

        String sectionId = section[0];
        String sectionTitle = section[1];
        String categoryMatch = section[2];
        String sectionIcon = section[3];

        boolean hasProducts = false;
        for (Product p : products) {
            if (categoryMatch.equals(p.getCategory())) {
                hasProducts = true;
                break;
            }
        }
        if (!hasProducts) continue;
%>

<section class="category-section" id="<%= sectionId %>">
    <% if (showAll) { %>
    <div class="section-head">
        <h2><i class="fas <%= sectionIcon %>"></i> <%= sectionTitle %></h2>
        <a href="<%= ctx %>/products?category=<%= sectionId %>">View all <i class="fas fa-arrow-right"></i></a>
    </div>
    <% } %>

    <div class="product-grid">
    <%
        for (Product p : products) {
            if (!categoryMatch.equals(p.getCategory())) continue;

            String imgUrl = ctx + "/images/" + URLEncoder.encode(p.getImage(), "UTF-8").replace("+", "%20");
            String priceStr = (p.getPrice() == Math.floor(p.getPrice()))
                ? String.valueOf((long) p.getPrice())
                : String.format("%.2f", p.getPrice());
    %>
        <article class="product-card">
            <div class="card-image-wrap">
                <img src="<%= imgUrl %>" alt="<%= p.getName() %>" loading="lazy">
            </div>
            <div class="card-body">
                <h3><%= p.getName() %></h3>
                <p class="card-desc"><%= p.getDescription() %></p>
                <div class="card-footer">
                    <div class="price">
                        <span>Price</span>
                        Rs. <%= priceStr %>
                    </div>
                </div>
                <div class="card-actions">
                    <a href="<%= ctx %>/cart?product=<%= URLEncoder.encode(p.getName(), "UTF-8") %>" class="btn btn-cart">
                        <i class="fas fa-cart-plus"></i> Add to Cart
                    </a>
                    <a href="<%= ctx %>/order.jsp?product=<%= URLEncoder.encode(p.getName(), "UTF-8") %>&quantity=1" class="btn btn-order">
                        <i class="fas fa-bolt"></i> Order
                    </a>
                </div>
            </div>
        </article>
    <%
        }
    %>
    </div>
</section>

<%
    }
}
%>

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
