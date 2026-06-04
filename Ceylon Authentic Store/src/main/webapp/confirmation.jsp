<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Order" %>
<%
    String ctx = request.getContextPath();
    Order order = (Order) request.getAttribute("order");
    if (order == null) {
        order = (Order) session.getAttribute("lastOrder");
    }
    String orderRef = "CAS-" + String.format("%06d", System.currentTimeMillis() % 1000000L);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Successful — Ceylon Authentic Store</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" crossorigin="anonymous">

<style>
:root {
    --green-dark: #0f5132;
    --green-mid: #198754;
    --green-light: #d1e7dd;
    --gold: #ffc107;
    --beige: #f5f0e8;
    --beige-soft: #faf7f2;
    --beige-warm: #ebe4d6;
    --white: #ffffff;
    --text: #1a2e24;
    --text-muted: #5c6b63;
    --border: rgba(15, 81, 50, 0.12);
    --shadow-sm: 0 4px 16px rgba(15, 81, 50, 0.08);
    --shadow-md: 0 12px 40px rgba(15, 81, 50, 0.14);
    --shadow-lg: 0 24px 56px rgba(15, 81, 50, 0.12);
    --radius: 16px;
    --radius-lg: 24px;
    --nav-h: 72px;
    --transition: 0.35s cubic-bezier(0.4, 0, 0.2, 1);
}

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

html { scroll-behavior: smooth; }

body {
    font-family: "Outfit", system-ui, sans-serif;
    color: var(--text);
    line-height: 1.6;
    min-height: 100vh;
    background: linear-gradient(160deg, var(--beige-soft) 0%, var(--beige) 45%, #e8dfd0 100%);
}

body::before {
    content: "";
    position: fixed;
    inset: 0;
    background:
        radial-gradient(ellipse 80% 50% at 20% 10%, rgba(25, 135, 84, 0.08), transparent),
        radial-gradient(ellipse 60% 40% at 90% 80%, rgba(255, 193, 7, 0.06), transparent);
    pointer-events: none;
    z-index: 0;
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

/* ——— Navbar ——— */
.navbar {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    height: var(--nav-h);
    z-index: 1000;
    background: rgba(255, 255, 255, 0.96);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
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

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
}

.logo-icon {
    width: 42px;
    height: 42px;
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--gold);
    font-size: 18px;
}

.logo-text {
    display: flex;
    flex-direction: column;
    line-height: 1.15;
}

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
    font-weight: 500;
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
    color: var(--text);
    border-radius: 10px;
    transition: color var(--transition), background var(--transition);
}

.nav-links a:hover { color: var(--green-dark); background: rgba(15, 81, 50, 0.06); }

.nav-actions { display: flex; align-items: center; gap: 12px; }

.cart-btn {
    width: 44px;
    height: 44px;
    border-radius: 12px;
    background: var(--beige);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--green-dark);
    font-size: 1.1rem;
    transition: transform var(--transition), background var(--transition);
}

.cart-btn:hover {
    background: var(--green-dark);
    color: var(--gold);
    transform: translateY(-2px);
}

.menu-toggle {
    display: none;
    width: 44px;
    height: 44px;
    border: none;
    background: var(--beige);
    border-radius: 12px;
    color: var(--green-dark);
    font-size: 1.25rem;
    cursor: pointer;
}

/* ——— Success page ——— */
.success-page {
    position: relative;
    z-index: 1;
    padding: calc(var(--nav-h) + 48px) 24px 64px;
    display: flex;
    justify-content: center;
    align-items: flex-start;
    min-height: 100vh;
}

.success-card {
    width: 100%;
    max-width: 560px;
    background: var(--white);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border);
    overflow: hidden;
    animation: cardIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
}

@keyframes cardIn {
    from { opacity: 0; transform: translateY(24px); }
    to { opacity: 1; transform: translateY(0); }
}

.success-header {
    padding: 40px 32px 28px;
    text-align: center;
    background: linear-gradient(180deg, rgba(209, 231, 221, 0.35) 0%, transparent 100%);
}

.success-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 24px;
    border-radius: 50%;
    background: linear-gradient(145deg, var(--green-mid), var(--green-dark));
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--white);
    font-size: 2.25rem;
    box-shadow: 0 8px 24px rgba(25, 135, 84, 0.35);
    animation: iconPop 0.5s 0.2s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}

@keyframes iconPop {
    from { transform: scale(0); opacity: 0; }
    to { transform: scale(1); opacity: 1; }
}

.success-header h1 {
    font-size: clamp(1.75rem, 4vw, 2.25rem);
    color: var(--green-dark);
    margin-bottom: 10px;
}

.success-header .subtitle {
    font-size: 1rem;
    color: var(--text-muted);
    max-width: 400px;
    margin: 0 auto;
    line-height: 1.55;
}

.success-header .subtitle strong {
    color: var(--green-dark);
    font-weight: 600;
}

.order-ref {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-top: 18px;
    padding: 8px 16px;
    background: var(--beige-soft);
    border: 1px solid var(--border);
    border-radius: 100px;
    font-size: 0.875rem;
    font-weight: 500;
    color: var(--text-muted);
}

.order-ref span {
    font-family: "Outfit", monospace;
    font-weight: 600;
    color: var(--green-dark);
    letter-spacing: 0.04em;
}

.success-body {
    padding: 0 32px 32px;
}

.summary-box {
    background: var(--beige-soft);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    padding: 24px;
    transition: box-shadow 0.4s ease, border-color 0.4s ease;
}

.summary-box.highlight {
    border-color: var(--green-mid);
    box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.15);
}

.summary-title {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 20px;
    padding-bottom: 16px;
    border-bottom: 1px solid var(--border);
}

.summary-title i {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    background: var(--white);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--green-mid);
    font-size: 0.95rem;
}

.summary-title h2 {
    font-size: 1.25rem;
    color: var(--green-dark);
}

.summary-rows {
    list-style: none;
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 16px;
    font-size: 0.95rem;
}

.summary-row .label {
    color: var(--text-muted);
    font-weight: 500;
    flex-shrink: 0;
}

.summary-row .value {
    text-align: right;
    font-weight: 600;
    color: var(--text);
    word-break: break-word;
}

.summary-row.product .value {
    color: var(--green-dark);
}

.confirm-note {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-top: 20px;
    padding: 14px 16px;
    background: rgba(25, 135, 84, 0.06);
    border-radius: 12px;
    font-size: 0.875rem;
    color: var(--text-muted);
}

.confirm-note i {
    color: var(--green-mid);
    margin-top: 2px;
}

.success-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 28px;
}

.btn {
    flex: 1;
    min-width: 140px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 14px 24px;
    font-family: inherit;
    font-size: 0.95rem;
    font-weight: 600;
    border-radius: 12px;
    border: none;
    cursor: pointer;
    transition: transform var(--transition), box-shadow var(--transition), background var(--transition), color var(--transition);
}

.btn-primary {
    background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
    color: var(--white);
    box-shadow: 0 4px 16px rgba(15, 81, 50, 0.25);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 24px rgba(15, 81, 50, 0.3);
}

.btn-secondary {
    background: var(--white);
    color: var(--green-dark);
    border: 2px solid var(--green-mid);
}

.btn-secondary:hover {
    background: var(--beige-soft);
    transform: translateY(-2px);
}

.page-footer {
    position: relative;
    z-index: 1;
    text-align: center;
    padding: 24px;
    font-size: 0.85rem;
    color: var(--text-muted);
}

/* ——— Error state ——— */
.error-card {
    max-width: 480px;
    text-align: center;
    padding: 48px 32px;
    background: var(--white);
    border-radius: var(--radius-lg);
    box-shadow: var(--shadow-md);
}

.error-card h1 { color: var(--green-dark); margin-bottom: 12px; }
.error-card p { color: var(--text-muted); margin-bottom: 24px; }

@media (max-width: 768px) {
    .nav-links {
        display: none;
        position: absolute;
        top: var(--nav-h);
        left: 0;
        right: 0;
        flex-direction: column;
        background: var(--white);
        padding: 16px;
        border-bottom: 1px solid var(--border);
        box-shadow: var(--shadow-md);
    }

    .nav-links.open { display: flex; }
    .menu-toggle { display: flex; align-items: center; justify-content: center; }

    .success-header { padding: 32px 24px 24px; }
    .success-body { padding: 0 24px 28px; }
    .summary-box { padding: 20px; }

    .success-actions { flex-direction: column; }
    .btn { width: 100%; min-width: unset; }
}

@media (max-width: 400px) {
    .summary-row { flex-direction: column; gap: 4px; }
    .summary-row .value { text-align: left; }
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
            <li><a href="<%= ctx %>/order.jsp">Order</a></li>
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

<% if (order != null) { %>

<main class="success-page">
    <article class="success-card" aria-labelledby="success-title">

        <header class="success-header">
            <div class="success-icon" aria-hidden="true">
                <i class="fas fa-check"></i>
            </div>
            <h1 id="success-title">Order Successful!</h1>
            <p class="subtitle">
                Thank you, <strong><%= order.getCustomerName() %></strong>.
                Your authentic Ceylon order has been received and is being prepared with care.
            </p>
            <div class="order-ref">
                <i class="fas fa-receipt"></i>
                Order <span><%= orderRef %></span>
            </div>
        </header>

        <div class="success-body">
            <section class="summary-box" id="order-summary" aria-labelledby="summary-heading">
                <div class="summary-title">
                    <i class="fas fa-clipboard-list"></i>
                    <h2 id="summary-heading">Order Summary</h2>
                </div>

                <ul class="summary-rows">
                    <li class="summary-row">
                        <span class="label">Customer</span>
                        <span class="value"><%= order.getCustomerName() %></span>
                    </li>
                    <li class="summary-row">
                        <span class="label">Email</span>
                        <span class="value"><%= order.getEmail() %></span>
                    </li>
                    <li class="summary-row product">
                        <span class="label">Product</span>
                        <span class="value"><%= order.getProductName() %></span>
                    </li>
                    <li class="summary-row">
                        <span class="label">Quantity</span>
                        <span class="value"><%= order.getQuantity() %></span>
                    </li>
                    <li class="summary-row">
                        <span class="label">Status</span>
                        <span class="value" style="color: var(--green-mid);">Confirmed</span>
                    </li>
                </ul>

                <p class="confirm-note">
                    <i class="fas fa-envelope-circle-check"></i>
                    <span>A confirmation has been sent to <strong><%= order.getEmail() %></strong>. We will contact you when your order ships.</span>
                </p>
            </section>

            <div class="success-actions">
                <a href="<%= ctx %>/products" class="btn btn-primary">
                    <i class="fas fa-store"></i>
                    Continue Shopping
                </a>
                <a href="#order-summary" class="btn btn-secondary" id="viewOrderBtn">
                    <i class="fas fa-eye"></i>
                    View Order
                </a>
            </div>
        </div>

    </article>
</main>

<% } else { %>

<main class="success-page">
    <div class="error-card">
        <h1>No Order Found</h1>
        <p>Please place an order first, or return to the store to browse our authentic products.</p>
        <a href="<%= ctx %>/products" class="btn btn-primary" style="display:inline-flex;">
            <i class="fas fa-store"></i>
            Continue Shopping
        </a>
    </div>
</main>

<% } %>

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

    var viewBtn = document.getElementById("viewOrderBtn");
    var summary = document.getElementById("order-summary");
    if (viewBtn && summary) {
        viewBtn.addEventListener("click", function (e) {
            e.preventDefault();
            summary.scrollIntoView({ behavior: "smooth", block: "center" });
            summary.classList.add("highlight");
            setTimeout(function () {
                summary.classList.remove("highlight");
            }, 2000);
        });
    }
})();
</script>

</body>
</html>
