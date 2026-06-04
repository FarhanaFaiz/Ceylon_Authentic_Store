<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         import="java.util.LinkedHashMap, java.util.Map, java.util.List" %>
<%!
    static String norm(String s) {
        if (s == null) return "";
        return s.trim().toLowerCase().replaceAll("\\s+", " ");
    }

    static void addAlias(Map<String, String[]> catalog, String key, String display, String price) {
        catalog.put(norm(key), new String[]{display, price});
    }

    static Map<String, String[]> buildProductCatalog() {
        Map<String, String[]> catalog = new LinkedHashMap<>();
        String[][] products = {
            {"Ceylon Black Tea", "1500"},
            {"Ceylon Green Tea", "1700"},
            {"Herbal Tea", "1600"},
            {"Cinnamon Tea", "1800"},
            {"Ceylon Cinnamon", "1200"},
            {"Black Pepper", "900"},
            {"Cardamom", "2200"},
            {"Cloves", "1700"},
            {"Batik Table Runner", "2400"},
            {"Batik Saree", "6500"},
            {"Batik Handbag", "2200"},
            {"Batik Wall Art", "3500"},
            {"Herbal Oil", "1800"},
            {"Skincare Cream", "2500"},
            {"Herbal Soap", "1800"},
            {"Wellness Items", "1800"},
            {"Wooden Elephant", "3000"},
            {"Traditional Sri Lankan Mask", "3200"},
            {"Handmade Decorations", "2600"},
            {"Coconut Shell Decoration", "2200"}
        };
        for (String[] p : products) {
            addAlias(catalog, p[0], p[0], p[1]);
        }
        addAlias(catalog, "Herbal  Tea", "Herbal Tea", "1600");
        addAlias(catalog, "Cinnamon tea", "Cinnamon Tea", "1800");
        addAlias(catalog, "skincare", "Skincare Cream", "2500");
        addAlias(catalog, "soaps", "Herbal Soap", "1800");
        addAlias(catalog, "wellness items", "Wellness Items", "1800");
        addAlias(catalog, "handmade decorations", "Handmade Decorations", "2600");
        return catalog;
    }

    static String[] resolveProduct(String name, Map<String, String[]> catalog) {
        if (name == null || name.trim().isEmpty()) return null;
        return catalog.get(norm(name));
    }
%>
<%
    String ctx = request.getContextPath();
    Map<String, String[]> catalog = buildProductCatalog();

    @SuppressWarnings("unchecked")
    List<Map<String, Object>> orderItems =
            (List<Map<String, Object>>) request.getAttribute("orderItems");
    String orderSource = (String) request.getAttribute("orderSource");
    double cartOrderTotal = 0.0;
    Object orderTotalAttr = request.getAttribute("orderTotal");
    if (orderTotalAttr instanceof Number) {
        cartOrderTotal = ((Number) orderTotalAttr).doubleValue();
    }
    boolean isCartCheckout = "cart".equals(orderSource)
            && orderItems != null && !orderItems.isEmpty();

    if (isCartCheckout) {
        session.setAttribute("checkoutItems", orderItems);
        session.setAttribute("checkoutTotal", Double.valueOf(cartOrderTotal));
    }

    String productParam = request.getParameter("product");
    String qtyParam = request.getParameter("quantity");

    if (!isCartCheckout && (productParam == null || productParam.trim().isEmpty())) {
        session.removeAttribute("lockedCheckoutProduct");
        session.removeAttribute("lockedCheckoutMaxQty");
    }

    String[] locked = null;
    int lockedMaxQty = 99;
    int defaultQty = 1;

    if (productParam != null && !productParam.trim().isEmpty()) {
        locked = resolveProduct(productParam, catalog);
        if (locked != null) {
            if (qtyParam != null && !qtyParam.isEmpty()) {
                try {
                    defaultQty = Integer.parseInt(qtyParam.trim());
                } catch (NumberFormatException ignored) {
                    defaultQty = 1;
                }
            }
            if (defaultQty < 1) defaultQty = 1;
            lockedMaxQty = defaultQty;
            session.setAttribute("lockedCheckoutProduct", locked[0]);
            session.setAttribute("lockedCheckoutMaxQty", Integer.valueOf(lockedMaxQty));
        }
    } else {
        String sessionProduct = (String) session.getAttribute("lockedCheckoutProduct");
        if (sessionProduct != null) {
            locked = resolveProduct(sessionProduct, catalog);
            Integer sessionMaxQty = (Integer) session.getAttribute("lockedCheckoutMaxQty");
            if (sessionMaxQty != null && sessionMaxQty > 0) {
                lockedMaxQty = sessionMaxQty;
                defaultQty = sessionMaxQty;
            }
        }
    }

    boolean isLockedCheckout = locked != null;

    if (!isCartCheckout && "direct".equals(orderSource) && orderItems != null && orderItems.size() == 1) {
        Map<String, Object> item = orderItems.get(0);
        String directName = String.valueOf(item.get("name"));
        int directQty = item.get("qty") instanceof Number
                ? ((Number) item.get("qty")).intValue() : 1;
        String[] resolved = resolveProduct(directName, catalog);
        if (resolved != null) {
            locked = resolved;
            defaultQty = directQty;
            lockedMaxQty = directQty;
            isLockedCheckout = true;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Place Your Order — Ceylon Authentic Store</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" crossorigin="anonymous">

<style>
:root {
    --green-dark: #0f5132;
    --green-mid: #198754;
    --gold: #ffc107;
    --gold-hover: #ffcd39;
    --beige: #f5f0e8;
    --beige-soft: #faf7f2;
    --white: #ffffff;
    --text: #1a2e24;
    --text-muted: #5c6b63;
    --border: rgba(15, 81, 50, 0.12);
    --error: #dc3545;
    --error-bg: rgba(220, 53, 69, 0.06);
    --error-border: rgba(220, 53, 69, 0.35);
    --shadow-sm: 0 4px 16px rgba(15, 81, 50, 0.08);
    --shadow-md: 0 12px 32px rgba(15, 81, 50, 0.14);
    --radius: 16px;
    --radius-lg: 24px;
    --nav-h: 72px;
    --transition: 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html { scroll-behavior: smooth; }
body {
    font-family: "Outfit", system-ui, sans-serif;
    background: var(--beige-soft);
    color: var(--text);
    line-height: 1.6;
    min-height: 100vh;
}
h1, h2, h3 { font-family: "Cormorant Garamond", Georgia, serif; font-weight: 600; line-height: 1.2; }
a { text-decoration: none; color: inherit; }

.container { width:100%; max-width:1200px; margin:auto; padding:0 24px; }

/* ——— Navbar ——— */
.navbar {
    position: fixed; top: 0; left: 0; right: 0;
    height: var(--nav-h); z-index: 1000;
    background: rgba(255,255,255,0.96);
    backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px);
    border-bottom: 1px solid var(--border);
    box-shadow: 0 2px 20px rgba(15,81,50,0.06);
}
.nav-inner { height:100%; display:flex; align-items:center; justify-content:space-between; gap:20px; }
.logo { display:flex; align-items:center; gap:10px; }
.logo-icon {
    width:42px; height:42px;
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    border-radius:12px; display:flex; align-items:center; justify-content:center;
    color:var(--gold); font-size:18px;
}
.logo-text { display:flex; flex-direction:column; line-height:1.15; }
.logo-text strong { font-family:"Cormorant Garamond",serif; font-size:1.25rem; color:var(--green-dark); font-weight:700; }
.logo-text span { font-size:0.65rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--text-muted); font-weight:500; }
.nav-links { display:flex; align-items:center; gap:6px; list-style:none; }
.nav-links a { padding:10px 16px; font-size:0.95rem; font-weight:500; color:var(--text); border-radius:10px; transition:color var(--transition),background var(--transition); }
.nav-links a:hover, .nav-links a.active { color:var(--green-dark); background:rgba(15,81,50,0.06); }
.nav-actions { display:flex; align-items:center; gap:12px; }
.cart-btn {
    width:44px; height:44px; border-radius:12px; background:var(--beige);
    display:flex; align-items:center; justify-content:center;
    color:var(--green-dark); font-size:1.1rem;
    transition:transform var(--transition),background var(--transition);
}
.cart-btn:hover { background:var(--green-dark); color:var(--gold); transform:translateY(-2px); }
.menu-toggle {
    display:none; width:44px; height:44px; border:none;
    background:var(--beige); border-radius:12px;
    color:var(--green-dark); font-size:1.25rem; cursor:pointer;
}

/* ——— Page header ——— */
.page-header { padding:calc(var(--nav-h) + 48px) 0 40px; text-align:center; }
.breadcrumb {
    display:flex; align-items:center; justify-content:center; gap:8px;
    font-size:0.875rem; color:var(--text-muted); margin-bottom:20px;
}
.breadcrumb a { color:var(--green-mid); font-weight:500; transition:color var(--transition); }
.breadcrumb a:hover { color:var(--green-dark); }
.breadcrumb i { font-size:0.65rem; opacity:0.5; }
.page-header h1 { font-size:clamp(2rem,5vw,2.75rem); color:var(--green-dark); margin-bottom:12px; }
.page-header p { max-width:520px; margin:0 auto; color:var(--text-muted); font-size:1.05rem; }

/* ——— Steps ——— */
.steps {
    display:flex; align-items:center; justify-content:center;
    gap:0; margin:36px auto 0; max-width:480px;
}
.step { display:flex; flex-direction:column; align-items:center; gap:8px; flex:1; position:relative; }
.step-num {
    width:40px; height:40px; border-radius:50%;
    display:flex; align-items:center; justify-content:center;
    font-weight:700; font-size:0.9rem;
    background:var(--beige); color:var(--text-muted);
    border:2px solid var(--border); transition:all var(--transition);
}
.step.active .step-num {
    background:linear-gradient(135deg, var(--green-dark), var(--green-mid));
    color:var(--gold); border-color:transparent;
    box-shadow:0 4px 16px rgba(15,81,50,0.25);
}
.step span { font-size:0.75rem; font-weight:600; text-transform:uppercase; letter-spacing:0.06em; color:var(--text-muted); }
.step.active span { color:var(--green-dark); }
.step-line { flex:0 0 48px; height:2px; background:var(--border); margin-top:-22px; }

/* ——— Main layout ——— */
.checkout-layout { display:flex; justify-content:center; align-items:flex-start; padding-bottom:80px; }

/* ——— Form card ——— */
.form-card {
    width:100%; max-width:850px; margin:auto;
    background:var(--white); border-radius:var(--radius-lg);
    box-shadow:var(--shadow-sm); border:1px solid var(--border); overflow:hidden;
}
.form-section { padding:32px 36px; border-bottom:1px solid var(--border); }
.form-section:last-of-type { border-bottom:none; }

.section-title { display:flex; align-items:center; gap:12px; margin-bottom:24px; }
.section-icon {
    width:44px; height:44px; border-radius:12px;
    background:rgba(15,81,50,0.08); color:var(--green-dark);
    display:flex; align-items:center; justify-content:center; font-size:1.1rem;
}
.section-title h2 { font-size:1.35rem; color:var(--green-dark); }
.section-title p { font-size:0.85rem; color:var(--text-muted); margin-top:2px; }

.field-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
.field { display:flex; flex-direction:column; gap:8px; }
.field.full { grid-column:1 / -1; }
.field label { font-size:0.875rem; font-weight:600; color:var(--text); }
.field label .optional { font-weight:400; color:var(--text-muted); }

.input-wrap { position:relative; }
.input-wrap i.field-icon {
    position:absolute; left:16px; top:50%; transform:translateY(-50%);
    color:var(--text-muted); font-size:0.95rem; pointer-events:none;
    transition:color var(--transition);
}
.input-wrap input,
.input-wrap select {
    width:100%; padding:14px 16px 14px 46px;
    font-family:inherit; font-size:1rem; color:var(--text);
    background:var(--beige-soft); border:2px solid transparent;
    border-radius:12px; outline:none;
    transition:border-color var(--transition),background var(--transition),box-shadow var(--transition);
    appearance:none; -webkit-appearance:none;
}
.input-wrap select {
    cursor:pointer;
    background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%235c6b63' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
    background-repeat:no-repeat; background-position:right 16px center; padding-right:40px;
}
.input-wrap input:focus,
.input-wrap select:focus {
    background:var(--white); border-color:var(--green-mid);
    box-shadow:0 0 0 4px rgba(25,135,84,0.12);
}
.input-wrap:focus-within i.field-icon { color:var(--green-mid); }
.input-wrap input::placeholder { color:#9aa8a0; }

/* ——— Validation error states ——— */
.input-wrap.has-error input,
.input-wrap.has-error select {
    border-color: var(--error) !important;
    background: var(--error-bg) !important;
    box-shadow: 0 0 0 4px rgba(220,53,69,0.10) !important;
}
.input-wrap.has-error i.field-icon { color: var(--error) !important; }

.field-error {
    display: none;
    align-items: center;
    gap: 6px;
    font-size: 0.8rem;
    font-weight: 500;
    color: var(--error);
    padding: 6px 10px;
    background: var(--error-bg);
    border: 1px solid var(--error-border);
    border-radius: 8px;
    margin-top: 4px;
    animation: errShake 0.35s ease;
}
.field-error.visible { display: flex; }
.field-error i { font-size: 0.75rem; flex-shrink:0; }

@keyframes errShake {
    0%,100% { transform: translateX(0); }
    20%      { transform: translateX(-5px); }
    60%      { transform: translateX(4px); }
    80%      { transform: translateX(-3px); }
}

/* ——— Order price summary ——— */
.order-price-summary {
    margin-top:20px; padding:20px 22px;
    background:linear-gradient(135deg,rgba(15,81,50,0.06) 0%,rgba(255,193,7,0.08) 100%);
    border:1px solid var(--border); border-radius:14px;
}
.order-price-summary h3 {
    font-size:0.95rem; font-weight:600; color:var(--green-dark);
    margin-bottom:14px; display:flex; align-items:center; gap:8px;
}
.order-price-summary h3 i { color:var(--green-mid); }
.price-row {
    display:flex; align-items:center; justify-content:space-between;
    gap:12px; padding:8px 0; font-size:0.9rem; color:var(--text-muted);
}
.price-row + .price-row { border-top:1px dashed rgba(15,81,50,0.12); }
.price-row strong { font-family:"Cormorant Garamond",serif; font-size:1.25rem; font-weight:700; color:var(--green-dark); }
.price-row.total { margin-top:4px; padding-top:12px; border-top:2px solid rgba(15,81,50,0.15); font-weight:600; color:var(--text); }
.price-row.total strong { font-size:1.5rem; color:var(--green-dark); }

.checkout-locked-note {
    margin-top:12px; padding:12px 14px; font-size:0.85rem;
    color:var(--green-dark); background:rgba(25,135,84,0.08);
    border:1px solid rgba(25,135,84,0.2); border-radius:10px;
    display:flex; align-items:flex-start; gap:10px;
}
.checkout-locked-note i { color:var(--green-mid); margin-top:2px; }
.checkout-locked-note a { color:var(--green-dark); font-weight:600; text-decoration:underline; }

.cart-checkout-list {
    display:flex; flex-direction:column; gap:12px;
}
.cart-checkout-item {
    display:flex; align-items:flex-start; justify-content:space-between; gap:16px;
    padding:16px 18px; background:var(--white);
    border:1px solid var(--border); border-radius:12px;
}
.cart-checkout-item .item-main h3 {
    font-size:1.1rem; color:var(--green-dark); margin-bottom:4px;
}
.cart-checkout-item .item-main p {
    font-size:0.85rem; color:var(--text-muted);
}
.cart-checkout-item .item-meta {
    text-align:right; flex-shrink:0;
}
.cart-checkout-item .item-meta .line {
    font-size:0.85rem; color:var(--text-muted); margin-bottom:4px;
}
.cart-checkout-item .item-meta .subtotal {
    font-family:"Cormorant Garamond",serif;
    font-size:1.2rem; font-weight:700; color:var(--green-dark);
}

.input-wrap.locked-product input[readonly] {
    cursor:default; background:var(--white);
    border-color:rgba(25,135,84,0.25); color:var(--green-dark); font-weight:600;
}

/* ——— Submit area ——— */
.form-footer {
    padding:28px 36px;
    background:linear-gradient(180deg, var(--beige-soft) 0%, rgba(245,240,232,0.5) 100%);
    display:flex; flex-direction:column; gap:16px;
}
.btn-submit {
    width:100%; padding:16px 28px;
    font-family:inherit; font-size:1.05rem; font-weight:600;
    color:var(--white);
    background:linear-gradient(135deg, var(--green-dark) 0%, var(--green-mid) 100%);
    border:none; border-radius:14px; cursor:pointer;
    display:flex; align-items:center; justify-content:center; gap:10px;
    transition:transform var(--transition),box-shadow var(--transition);
    box-shadow:0 6px 24px rgba(15,81,50,0.28);
}
.btn-submit:hover { transform:translateY(-2px); box-shadow:0 10px 32px rgba(15,81,50,0.35); }
.btn-submit:active { transform:translateY(0); }
.btn-submit:disabled {
    opacity:0.55; cursor:not-allowed;
    transform:none !important; box-shadow:none !important;
}
.secure-note {
    display:flex; align-items:center; justify-content:center; gap:8px;
    font-size:0.8rem; color:var(--text-muted);
}
.secure-note i { color:var(--green-mid); }

/* ——— Form-level error banner ——— */
.form-error-banner {
    display:none;
    align-items:center; gap:12px;
    padding:14px 18px; margin-bottom:4px;
    background:rgba(220,53,69,0.07);
    border:1px solid var(--error-border); border-radius:12px;
    font-size:0.9rem; font-weight:500; color:var(--error);
}
.form-error-banner.visible { display:flex; }
.form-error-banner i { font-size:1.1rem; flex-shrink:0; }

/* ——— Footer ——— */
.page-footer {
    text-align:center; padding:24px; font-size:0.85rem;
    color:var(--text-muted); border-top:1px solid var(--border); background:var(--white);
}

/* ——— Responsive ——— */
@media (max-width:900px) {
    .checkout-layout { grid-template-columns:1fr; }
}
@media (max-width:640px) {
    .nav-links {
        display:none; position:absolute; top:var(--nav-h); left:0; right:0;
        flex-direction:column; background:var(--white); padding:16px;
        border-bottom:1px solid var(--border); box-shadow:var(--shadow-md);
    }
    .nav-links.open { display:flex; }
    .menu-toggle { display:flex; align-items:center; justify-content:center; }
    .field-grid { grid-template-columns:1fr; }
    .form-section { padding:24px 20px; }
    .form-footer { padding:24px 20px; }
    .step-line { flex:0 0 24px; }
}
</style>
</head>

<body>

<nav class="navbar" id="navbar">
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
            <li><a href="<%= ctx %>/cart">Cart</a></li>
            <li><a href="<%= ctx %>/order" class="active">Order</a></li>
        </ul>
        <div class="nav-actions">
            <a href="<%= ctx %>/cart" class="cart-btn" aria-label="Shopping cart">
                <i class="fas fa-shopping-bag"></i>
            </a>
            <button class="menu-toggle" id="menuToggle" aria-label="Open menu" type="button">
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
            <span>Checkout</span>
        </nav>
        <h1>Complete Your Order</h1>
        <p>Fill in your details below and we will prepare your authentic Ceylon treasures for delivery.</p>
        <div class="steps" aria-hidden="true">
            <div class="step active">
                <div class="step-num">1</div>
                <span>Details</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-num">2</div>
                <span>Confirm</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-num">3</div>
                <span>Done</span>
            </div>
        </div>
    </div>
</header>

<main class="container checkout-layout">
    <div class="form-card">
<%
    String formError = (String) request.getAttribute("formError");
    if (formError != null && !formError.isEmpty()) {
%>
        <div class="form-error-banner visible" style="margin:24px 36px 0;" role="alert">
            <i class="fas fa-triangle-exclamation"></i>
            <span><%= formError %></span>
        </div>
<%
    }
%>
       <form action="<%= ctx %>/order" method="post" novalidate id="orderForm">
            <% if (isCartCheckout) { %>
            <input type="hidden" name="checkoutMode" value="cart">
            <% } %>

            <!-- ===== Contact Information ===== -->
            <div class="form-section">
                <div class="section-title">
                    <div class="section-icon"><i class="fas fa-user"></i></div>
                    <div>
                        <h2>Contact Information</h2>
                        <p>How we can reach you about your order</p>
                    </div>
                </div>

                <div class="field-grid">
                    <!-- Full Name -->
                    <div class="field full">
                        <label for="customerName">Full Name <span style="color:var(--error)">*</span></label>
                        <div class="input-wrap" id="wrap-customerName">
                            <input type="text" id="customerName" name="customerName"
                                   placeholder="Enter your full name"
                                   autocomplete="name" required>
                            <i class="fas fa-user field-icon"></i>
                        </div>
                        <div class="field-error" id="err-customerName">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Full name is required.</span>
                        </div>
                    </div>

                    <!-- Email -->
                    <div class="field full">
                        <label for="email">Email Address <span style="color:var(--error)">*</span></label>
                        <div class="input-wrap" id="wrap-email">
                            <input type="email" id="email" name="email"
                                   placeholder="you@example.com"
                                   autocomplete="email" required>
                            <i class="fas fa-envelope field-icon"></i>
                        </div>
                        <div class="field-error" id="err-email">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>A valid email address is required.</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ===== Order Details ===== -->
            <div class="form-section">
                <div class="section-title">
                    <div class="section-icon"><i class="fas fa-box-open"></i></div>
                    <div>
                        <h2>Order Details</h2>
                        <% if (isCartCheckout) { %>
                        <p>Your cart items — review before submitting</p>
                        <% } else if (isLockedCheckout) { %>
                        <p>Complete your order for the selected cart item</p>
                        <% } else { %>
                        <p>Choose your product and quantity</p>
                        <% } %>
                    </div>
                </div>

                <% if (isCartCheckout) {
                    int cartItemCount = 0;
                    for (Map<String, Object> item : orderItems) {
                        cartItemCount += item.get("qty") instanceof Number
                                ? ((Number) item.get("qty")).intValue() : 0;
                    }
                %>
                <div class="cart-checkout-list" id="cartCheckoutList">
                    <% for (Map<String, Object> item : orderItems) {
                        String itemName = String.valueOf(item.get("name"));
                        String itemCategory = item.get("category") != null
                                ? String.valueOf(item.get("category")) : "Authentic Ceylon product";
                        int itemQty = item.get("qty") instanceof Number
                                ? ((Number) item.get("qty")).intValue() : 1;
                        double unitPrice = item.get("unitPrice") instanceof Number
                                ? ((Number) item.get("unitPrice")).doubleValue() : 0.0;
                        double subtotal = item.get("subtotal") instanceof Number
                                ? ((Number) item.get("subtotal")).doubleValue() : unitPrice * itemQty;
                        if (unitPrice <= 0) {
                            String[] catEntry = resolveProduct(itemName, catalog);
                            if (catEntry != null) {
                                unitPrice = Double.parseDouble(catEntry[1]);
                                subtotal = unitPrice * itemQty;
                            }
                        }
                    %>
                    <article class="cart-checkout-item">
                        <div class="item-main">
                            <h3><%= itemName %></h3>
                            <p><%= itemCategory.isEmpty() ? "Authentic Ceylon product" : itemCategory %></p>
                        </div>
                        <div class="item-meta">
                            <div class="line">Qty <%= itemQty %> &times; Rs. <%= String.format("%,.0f", unitPrice) %></div>
                            <div class="subtotal">Rs. <%= String.format("%,.0f", subtotal) %></div>
                        </div>
                    </article>
                    <% } %>
                </div>

                <div class="order-price-summary" id="orderPriceSummary">
                    <h3><i class="fas fa-tags"></i> Order Total</h3>
                    <div class="price-row">
                        <span>Products</span>
                        <strong><%= orderItems.size() %></strong>
                    </div>
                    <div class="price-row">
                        <span>Total items</span>
                        <strong><%= cartItemCount %></strong>
                    </div>
                    <div class="price-row total">
                        <span>Grand total</span>
                        <strong id="orderTotal">Rs. <%= String.format("%,.0f", cartOrderTotal) %></strong>
                    </div>
                </div>
                <p class="checkout-locked-note">
                    <i class="fas fa-shopping-cart"></i>
                    Checkout includes all items from your cart.
                    <a href="<%= ctx %>/cart">Return to cart</a> to make changes.
                </p>

                <% } else { %>
                <div class="field-grid">
                    <!-- Product -->
                    <div class="field full">
                        <label for="productName">Product <span style="color:var(--error)">*</span></label>

                        <% if (isLockedCheckout) {
                            String lockedName = locked[0];
                            String lockedPrice = locked[1];
                        %>
                        <input type="hidden" id="productName" name="productName"
                               value="<%= lockedName %>" data-price="<%= lockedPrice %>">
                        <div class="input-wrap locked-product" id="wrap-productName">
                            <input type="text" id="productNameDisplay" readonly
                                   value="<%= lockedName %> — Rs. <%= String.format("%,d", Integer.parseInt(lockedPrice)) %>"
                                   aria-label="Selected product">
                            <i class="fas fa-lock field-icon"></i>
                        </div>
                        <p class="checkout-locked-note">
                            <i class="fas fa-shopping-cart"></i>
                            Checkout is locked to this cart item only (qty <%= defaultQty %>).
                            <a href="<%= ctx %>/cart">Return to cart</a> to order a different product.
                        </p>
                        <% } else { %>
                        <%
                            String selectedProduct = request.getParameter("product");
                        %>
                        <% if (selectedProduct != null && !selectedProduct.isEmpty()) { %>
                        <div class="input-wrap" id="wrap-productName">
                            <input type="text" id="productName" name="productName"
                                   value="<%= selectedProduct %>" readonly>
                            <i class="fas fa-leaf field-icon"></i>
                        </div>
                        <% } else { %>
                        <div class="input-wrap" id="wrap-productName">
                            <select id="productName" name="productName" required>
                                <option value="" disabled selected>— Select a product —</option>
                                <optgroup label="Teas">
                                    <option value="Ceylon Black Tea"  data-price="1500">Ceylon Black Tea</option>
                                    <option value="Ceylon Green Tea"  data-price="1700">Ceylon Green Tea</option>
                                    <option value="Herbal Tea"        data-price="1600">Herbal Tea</option>
                                    <option value="Cinnamon Tea"      data-price="1800">Cinnamon Tea</option>
                                </optgroup>
                                <optgroup label="Spices">
                                    <option value="Ceylon Cinnamon"   data-price="1200">Ceylon Cinnamon</option>
                                    <option value="Black Pepper"      data-price="900">Black Pepper</option>
                                    <option value="Cardamom"          data-price="2200">Cardamom</option>
                                    <option value="Cloves"            data-price="1700">Cloves</option>
                                </optgroup>
                                <optgroup label="Batik">
                                    <option value="Batik Table Runner" data-price="2400">Batik Table Runner</option>
                                    <option value="Batik Saree"        data-price="6500">Batik Saree</option>
                                    <option value="Batik Handbag"      data-price="2200">Batik Handbag</option>
                                    <option value="Batik Wall Art"     data-price="3500">Batik Wall Art</option>
                                </optgroup>
                                <optgroup label="Wellness">
                                    <option value="Herbal Oil"         data-price="1800">Herbal Oil</option>
                                    <option value="Skincare Cream"     data-price="2500">Skincare Cream</option>
                                    <option value="Herbal Soap"        data-price="1800">Herbal Soap</option>
                                    <option value="Wellness Items"     data-price="1800">Wellness Items</option>
                                </optgroup>
                                <optgroup label="Crafts">
                                    <option value="Wooden Elephant"              data-price="3000">Wooden Elephant</option>
                                    <option value="Traditional Sri Lankan Mask"  data-price="3200">Traditional Sri Lankan Mask</option>
                                    <option value="Handmade Decorations"         data-price="2600">Handmade Decorations</option>
                                    <option value="Coconut Shell Decoration"     data-price="2200">Coconut Shell Decoration</option>
                                </optgroup>
                            </select>
                            <i class="fas fa-leaf field-icon"></i>
                        </div>
                        <% } %>
                        <div class="field-error" id="err-productName">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Please select a product.</span>
                        </div>
                        <% } %>
                    </div>

                    <!-- Quantity -->
                    <div class="field">
                        <label for="quantity">Quantity <span style="color:var(--error)">*</span></label>
                        <div class="input-wrap" id="wrap-quantity">
                            <input type="number" id="quantity" name="quantity"
                                   min="1" max="<%= isLockedCheckout ? lockedMaxQty : 99 %>"
                                   value="<%= defaultQty %>" required
                                   <%= isLockedCheckout ? "readonly" : "" %>>
                            <i class="fas fa-hashtag field-icon"></i>
                        </div>
                        <div class="field-error" id="err-quantity">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Quantity must be at least 1.</span>
                        </div>
                    </div>
                </div>

                <!-- Price Summary -->
                <div class="order-price-summary" id="orderPriceSummary">
                    <h3><i class="fas fa-tags"></i> Price Summary</h3>
                    <div class="price-row">
                        <span>Unit price</span>
                        <strong id="unitPrice">—</strong>
                    </div>
                    <div class="price-row">
                        <span>Quantity</span>
                        <strong id="qtyDisplay">1</strong>
                    </div>
                    <div class="price-row total">
                        <span>Estimated total</span>
                        <strong id="orderTotal">—</strong>
                    </div>
                </div>
                <% } %>
            </div>

            <!-- ===== Submit ===== -->
            <div class="form-footer">
                <!-- Form-level error banner -->
                <div class="form-error-banner" id="formErrorBanner">
                    <i class="fas fa-triangle-exclamation"></i>
                    <span>Please fill in all required fields before submitting.</span>
                </div>

                <button type="submit" class="btn-submit" id="btnSubmit">
                    <i class="fas fa-paper-plane"></i>
                    Submit Order
                </button>
                <p class="secure-note">
                    <i class="fas fa-lock"></i>
                    Your information is used only to process this order
                </p>
            </div>
        </form>
    </div>
</main>

<footer class="page-footer">
    &copy; Ceylon Authentic Store — Authentic Sri Lankan Heritage
</footer>

<script>
(function () {
    /* ——— Mobile nav ——— */
    var menuToggle = document.getElementById("menuToggle");
    var navLinks   = document.getElementById("navLinks");
    if (menuToggle && navLinks) {
        menuToggle.addEventListener("click", function () {
            navLinks.classList.toggle("open");
        });
    }

    /* ——— Price helpers ——— */
    function formatRs(amount) {
        return "Rs. " + amount.toLocaleString("en-LK");
    }

    function getUnitPrice(productField) {
        if (!productField) return 0;
        if (productField.tagName === "SELECT") {
            var sel = productField.options[productField.selectedIndex];
            return sel ? parseFloat(sel.getAttribute("data-price") || "0") : 0;
        }
        return parseFloat(productField.getAttribute("data-price") || "0");
    }

    function updateOrderPrice() {
        var productField  = document.getElementById("productName");
        var quantityInput = document.getElementById("quantity");
        var unitPriceEl   = document.getElementById("unitPrice");
        var qtyDisplayEl  = document.getElementById("qtyDisplay");
        var orderTotalEl  = document.getElementById("orderTotal");

        if (!productField || !quantityInput || !unitPriceEl || !qtyDisplayEl || !orderTotalEl) return;

        var unitPrice    = getUnitPrice(productField);
        var quantity     = parseInt(quantityInput.value, 10);
        var productValue = productField.value || "";

        if (isNaN(quantity) || quantity < 1) quantity = 1;
        qtyDisplayEl.textContent = String(quantity);

        if (!unitPrice || !productValue) {
            unitPriceEl.textContent  = "—";
            orderTotalEl.textContent = "—";
            return;
        }
        unitPriceEl.textContent  = formatRs(unitPrice);
        orderTotalEl.textContent = formatRs(unitPrice * quantity);
    }

    /* ——— Validation helpers ——— */
    function showError(fieldId, show) {
        var wrap = document.getElementById("wrap-" + fieldId);
        var err  = document.getElementById("err-"  + fieldId);
        if (wrap) {
            if (show) wrap.classList.add("has-error");
            else      wrap.classList.remove("has-error");
        }
        if (err) {
            if (show) err.classList.add("visible");
            else      err.classList.remove("visible");
        }
    }

    function validateField(fieldId) {
        var el = document.getElementById(fieldId);
        if (!el) return true;            // element not present → skip
        var val = el.value.trim();

        if (fieldId === "customerName") {
            var ok = val.length > 0;
            showError(fieldId, !ok);
            return ok;
        }
        if (fieldId === "email") {
            var emailOk = val.length > 0 && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val);
            showError(fieldId, !emailOk);
            return emailOk;
        }
        if (fieldId === "productName") {
            var prodOk = val.length > 0;
            showError(fieldId, !prodOk);
            return prodOk;
        }
        if (fieldId === "quantity") {
            var qty = parseInt(val, 10);
            var qtyOk = !isNaN(qty) && qty >= 1;
            showError(fieldId, !qtyOk);
            return qtyOk;
        }
        return true;
    }

    /* ——— Live-validate on blur / change ——— */
    ["customerName", "email", "quantity"].forEach(function (id) {
        var el = document.getElementById(id);
        if (el) {
            el.addEventListener("blur",   function () { validateField(id); });
            el.addEventListener("input",  function () { if (document.getElementById("wrap-" + id) && document.getElementById("wrap-" + id).classList.contains("has-error")) validateField(id); });
        }
    });

    var productField = document.getElementById("productName");
    if (productField) {
        if (productField.tagName === "SELECT") {
            productField.addEventListener("change", function () {
                validateField("productName");
                updateOrderPrice();
            });
        }
    }

    var quantityInput = document.getElementById("quantity");
    if (quantityInput && !quantityInput.readOnly) {
        quantityInput.addEventListener("input",  updateOrderPrice);
        quantityInput.addEventListener("change", updateOrderPrice);
    }

    /* ——— Form submit validation ——— */
    var form   = document.getElementById("orderForm");
    var banner = document.getElementById("formErrorBanner");

    var isCartCheckout = <%= isCartCheckout ? "true" : "false" %>;

    if (form) {
        form.addEventListener("submit", function (e) {
            var nameOk  = validateField("customerName");
            var emailOk = validateField("email");
            var productOk = true;
            var qtyOk     = true;

            if (!isCartCheckout) {
                productOk = validateField("productName");
                qtyOk     = validateField("quantity");
            }

            var allOk = nameOk && emailOk && productOk && qtyOk;

            if (!allOk) {
                e.preventDefault();   // block submission
                if (banner) banner.classList.add("visible");

                /* Scroll to first error */
                var firstErr = form.querySelector(".input-wrap.has-error");
                if (firstErr) {
                    firstErr.scrollIntoView({ behavior: "smooth", block: "center" });
                }
            } else {
                if (banner) banner.classList.remove("visible");
            }
        });
    }

    if (!isCartCheckout) {
        updateOrderPrice();
    }
})();
</script>

</body>
</html>
