<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Ceylon Authentic Store — Authentic Sri Lankan Heritage</title>
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
    --shadow-sm: 0 4px 16px rgba(15, 81, 50, 0.08);
    --shadow-md: 0 12px 32px rgba(15, 81, 50, 0.14);
    --shadow-lg: 0 20px 48px rgba(15, 81, 50, 0.18);
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
    overflow-x: hidden;
}

h1, h2, h3, h4 {
    font-family: "Cormorant Garamond", Georgia, serif;
    font-weight: 600;
    line-height: 1.2;
}

img { max-width: 100%; display: block; }

a { text-decoration: none; color: inherit; }

.container {
    width: 100%;
    max-width: 1240px;
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
    background: rgba(255, 255, 255, 0.92);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    border-bottom: 1px solid rgba(15, 81, 50, 0.08);
    box-shadow: 0 2px 20px rgba(15, 81, 50, 0.06);
    transition: background var(--transition), box-shadow var(--transition);
}

.navbar.scrolled {
    background: rgba(255, 255, 255, 0.98);
    box-shadow: var(--shadow-sm);
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
    flex-shrink: 0;
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
    position: relative;
}

.nav-links a:hover,
.nav-links a.active {
    color: var(--green-dark);
    background: rgba(15, 81, 50, 0.06);
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

/* ——— Hero ——— */
.hero {
    position: relative;
    min-height: 100vh;
    min-height: 100dvh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: calc(var(--nav-h) + 48px) 24px 80px;
    overflow: hidden;
}

.hero-bg {
    position: absolute;
    inset: 0;
    background: url("<%= ctx %>/images/welcome.png") center / cover no-repeat;
    transform: scale(1.02);
    transition: transform 8s ease-out;
}

.hero:hover .hero-bg { transform: scale(1.06); }

.hero-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(
        135deg,
        rgba(15, 81, 50, 0.88) 0%,
        rgba(15, 81, 50, 0.72) 45%,
        rgba(10, 50, 32, 0.85) 100%
    );
}

.hero-pattern {
    position: absolute;
    inset: 0;
    opacity: 0.06;
    background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffc107' fill-opacity='1'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
    z-index: 1;
}

.hero-content {
    position: relative;
    z-index: 2;
    text-align: center;
    max-width: 820px;
    color: var(--white);
}

.hero-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 8px 18px;
    background: rgba(255, 193, 7, 0.15);
    border: 1px solid rgba(255, 193, 7, 0.35);
    border-radius: 50px;
    font-size: 0.8rem;
    font-weight: 600;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--gold);
    margin-bottom: 24px;
    animation: fadeUp 0.8s ease both;
}

.hero-content h1 {
    font-size: clamp(2.5rem, 6vw, 4.25rem);
    font-weight: 700;
    margin-bottom: 20px;
    text-shadow: 0 4px 24px rgba(0, 0, 0, 0.3);
    animation: fadeUp 0.8s 0.1s ease both;
}

.hero-subtitle {
    font-size: clamp(1rem, 2.2vw, 1.25rem);
    color: rgba(255, 255, 255, 0.92);
    max-width: 620px;
    margin: 0 auto 36px;
    font-weight: 400;
    line-height: 1.75;
    animation: fadeUp 0.8s 0.2s ease both;
}

.hero-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 16px;
    justify-content: center;
    animation: fadeUp 0.8s 0.3s ease both;
}

.btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 16px 32px;
    font-family: "Outfit", sans-serif;
    font-size: 1rem;
    font-weight: 600;
    border-radius: 50px;
    border: none;
    cursor: pointer;
    transition: transform var(--transition), box-shadow var(--transition), background var(--transition), color var(--transition);
}

.btn-primary {
    background: var(--gold);
    color: var(--green-dark);
    box-shadow: 0 4px 20px rgba(255, 193, 7, 0.4);
}

.btn-primary:hover {
    background: var(--gold-hover);
    transform: translateY(-4px);
    box-shadow: 0 0 32px rgba(255, 193, 7, 0.65), 0 12px 28px rgba(0, 0, 0, 0.15);
}

.btn-outline {
    background: transparent;
    color: var(--white);
    border: 2px solid rgba(255, 255, 255, 0.7);
}

.btn-outline:hover {
    background: rgba(255, 255, 255, 0.12);
    border-color: var(--white);
    transform: translateY(-4px);
    box-shadow: 0 0 24px rgba(255, 255, 255, 0.2);
}

.hero-scroll {
    position: absolute;
    bottom: 32px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 2;
    color: rgba(255, 255, 255, 0.7);
    font-size: 0.75rem;
    letter-spacing: 0.1em;
    text-transform: uppercase;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    animation: bounce 2s infinite;
}

@keyframes fadeUp {
    from { opacity: 0; transform: translateY(28px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes bounce {
    0%, 100% { transform: translateX(-50%) translateY(0); }
    50% { transform: translateX(-50%) translateY(8px); }
}

/* ——— Sections ——— */
.section {
    padding: 88px 0;
}

.section-beige { background: var(--beige); }
.section-white { background: var(--white); }

.section-header {
    text-align: center;
    margin-bottom: 52px;
}

.section-label {
    display: inline-block;
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.14em;
    text-transform: uppercase;
    color: var(--green-mid);
    margin-bottom: 10px;
}

.section-header h2 {
    font-size: clamp(2rem, 4vw, 2.75rem);
    color: var(--green-dark);
    margin-bottom: 12px;
}

.section-header p {
    color: var(--text-muted);
    font-size: 1.05rem;
    max-width: 520px;
    margin: 0 auto;
}

.section-divider {
    width: 64px;
    height: 4px;
    background: linear-gradient(90deg, var(--green-dark), var(--gold));
    margin: 18px auto 0;
    border-radius: 4px;
}

/* ——— Categories ——— */
.categories-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 22px;
}

.category-card {
    background: var(--white);
    border-radius: var(--radius);
    overflow: hidden;
    box-shadow: var(--shadow-sm);
    transition: transform var(--transition), box-shadow var(--transition);
    display: block;
}

.category-card:hover {
    transform: translateY(-10px) scale(1.02);
    box-shadow: var(--shadow-lg);
}

.category-img-wrap {
    position: relative;
    height: 180px;
    overflow: hidden;
}

.category-card img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.6s ease;
}

.category-card:hover img { transform: scale(1.1); }

.category-img-wrap::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(to top, rgba(15, 81, 50, 0.5), transparent 50%);
    opacity: 0;
    transition: opacity var(--transition);
}

.category-card:hover .category-img-wrap::after { opacity: 1; }

.category-body {
    padding: 20px 18px 22px;
    text-align: center;
}

.category-body h3 {
    font-size: 1.35rem;
    color: var(--green-dark);
    margin-bottom: 6px;
}

.category-body span {
    font-size: 0.85rem;
    color: var(--green-mid);
    font-weight: 500;
}

/* ——— Featured Products ——— */
.products-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 28px;
}

.product-card {
    background: var(--white);
    border-radius: var(--radius-lg);
    overflow: hidden;
    box-shadow: var(--shadow-sm);
    transition: transform var(--transition), box-shadow var(--transition);
    display: flex;
    flex-direction: column;
}

.product-card:hover {
    transform: translateY(-8px) scale(1.02);
    box-shadow: var(--shadow-lg);
}

.product-img {
    position: relative;
    height: 220px;
    overflow: hidden;
    background: var(--beige);
}

.product-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.6s ease;
}

.product-card:hover .product-img img { transform: scale(1.08); }

.product-tag {
    position: absolute;
    top: 14px;
    left: 14px;
    padding: 6px 12px;
    background: var(--green-dark);
    color: var(--gold);
    font-size: 0.7rem;
    font-weight: 700;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    border-radius: 8px;
}

.product-body {
    padding: 22px 22px 24px;
    flex: 1;
    display: flex;
    flex-direction: column;
}

.product-body h3 {
    font-size: 1.4rem;
    color: var(--green-dark);
    margin-bottom: 8px;
}

.product-rating {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 12px;
    font-size: 0.85rem;
    color: var(--text-muted);
}

.product-rating .stars { color: var(--gold); }

.product-price {
    font-size: 1.35rem;
    font-weight: 700;
    color: var(--green-dark);
    margin-bottom: 18px;
}

.product-price span {
    font-size: 0.85rem;
    font-weight: 500;
    color: var(--text-muted);
}

.btn-cart {
    margin-top: auto;
    width: 100%;
    padding: 14px;
    background: var(--green-dark);
    color: var(--white);
    border: none;
    border-radius: 12px;
    font-family: inherit;
    font-size: 0.95rem;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    transition: background var(--transition), box-shadow var(--transition), transform var(--transition);
}

.btn-cart:hover {
    background: var(--green-mid);
    transform: translateY(-2px);
    box-shadow: 0 0 24px rgba(15, 81, 50, 0.35);
}

/* ——— Why Choose Us ——— */
.why-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 28px;
}

.why-card {
    background: var(--white);
    padding: 36px 24px;
    border-radius: var(--radius);
    text-align: center;
    box-shadow: var(--shadow-sm);
    transition: transform var(--transition), box-shadow var(--transition);
    border: 1px solid rgba(15, 81, 50, 0.06);
}

.why-card:hover {
    transform: translateY(-6px);
    box-shadow: var(--shadow-md);
}

.why-icon {
    width: 64px;
    height: 64px;
    margin: 0 auto 20px;
    background: linear-gradient(135deg, rgba(15, 81, 50, 0.1), rgba(255, 193, 7, 0.15));
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.6rem;
    color: var(--green-dark);
}

.why-card h3 {
    font-size: 1.35rem;
    color: var(--green-dark);
    margin-bottom: 10px;
}

.why-card p {
    font-size: 0.9rem;
    color: var(--text-muted);
    line-height: 1.65;
}

/* ——— CTA ——— */
.cta-section {
    padding: 100px 24px;
    background: linear-gradient(135deg, var(--green-dark) 0%, #0a3d24 50%, var(--green-dark) 100%);
    position: relative;
    overflow: hidden;
}

.cta-section::before {
    content: "";
    position: absolute;
    inset: 0;
    background: radial-gradient(ellipse at 30% 50%, rgba(255, 193, 7, 0.12) 0%, transparent 60%),
                radial-gradient(ellipse at 70% 80%, rgba(255, 255, 255, 0.05) 0%, transparent 50%);
    pointer-events: none;
}

.cta-inner {
    position: relative;
    z-index: 1;
    text-align: center;
    max-width: 640px;
    margin: 0 auto;
    color: var(--white);
}

.cta-inner h2 {
    font-size: clamp(2rem, 4vw, 3rem);
    margin-bottom: 16px;
}

.cta-inner p {
    font-size: 1.1rem;
    opacity: 0.9;
    margin-bottom: 32px;
    line-height: 1.7;
}

.btn-cta {
    padding: 18px 48px;
    font-size: 1.1rem;
    background: var(--gold);
    color: var(--green-dark);
    border-radius: 50px;
    font-weight: 700;
    box-shadow: 0 8px 32px rgba(255, 193, 7, 0.45);
    transition: transform var(--transition), box-shadow var(--transition), background var(--transition);
}

.btn-cta:hover {
    background: var(--gold-hover);
    transform: translateY(-4px) scale(1.03);
    box-shadow: 0 0 40px rgba(255, 193, 7, 0.7), 0 16px 40px rgba(0, 0, 0, 0.2);
}

/* ——— Footer (compact, muted) ——— */
.footer {
    background: #e8ebe9;
    color: var(--text-muted);
    padding: 28px 0 12px;
    border-top: 1px solid rgba(15, 81, 50, 0.08);
}

.footer-grid {
    display: grid;
    grid-template-columns: 1.2fr 1fr 1fr 1.1fr;
    gap: 20px;
    margin-bottom: 16px;
}

.footer-brand .logo-icon {
    width: 30px;
    height: 30px;
    font-size: 13px;
    background: rgba(15, 81, 50, 0.12);
    color: var(--green-dark);
}

.footer-brand .logo-text strong {
    font-size: 0.95rem;
    color: var(--green-dark);
}

.footer-brand .logo-text span { color: var(--text-muted); }

.footer-brand p {
    margin-top: 8px;
    font-size: 0.75rem;
    line-height: 1.5;
    color: var(--text-muted);
    max-width: 240px;
}

.social-links {
    display: flex;
    gap: 6px;
    margin-top: 10px;
}

.social-links a {
    width: 28px;
    height: 28px;
    border-radius: 6px;
    background: rgba(15, 81, 50, 0.06);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--text-muted);
    font-size: 0.75rem;
    transition: background var(--transition), color var(--transition);
}

.social-links a:hover {
    background: rgba(15, 81, 50, 0.12);
    color: var(--green-dark);
}

.footer h4 {
    font-family: "Outfit", sans-serif;
    font-size: 0.68rem;
    font-weight: 600;
    letter-spacing: 0.06em;
    text-transform: uppercase;
    color: var(--green-dark);
    opacity: 0.7;
    margin-bottom: 10px;
}

.footer-links {
    list-style: none;
}

.footer-links li { margin-bottom: 6px; }

.footer-links a {
    font-size: 0.75rem;
    color: var(--text-muted);
    transition: color var(--transition);
}

.footer-links a:hover {
    color: var(--green-dark);
}

.footer-contact li {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    margin-bottom: 8px;
    font-size: 0.75rem;
    color: var(--text-muted);
}

.footer-contact i {
    color: var(--text-muted);
    opacity: 0.6;
    margin-top: 2px;
    width: 14px;
    font-size: 0.75rem;
}

.footer-bottom {
    padding-top: 12px;
    border-top: 1px solid rgba(15, 81, 50, 0.08);
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 6px;
    font-size: 0.7rem;
    color: var(--text-muted);
}

.footer-bottom a { color: var(--green-dark); opacity: 0.75; }

/* ——— Scroll reveal ——— */
.reveal {
    opacity: 0;
    transform: translateY(32px);
    transition: opacity 0.7s ease, transform 0.7s ease;
}

.reveal.visible {
    opacity: 1;
    transform: translateY(0);
}

.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
.reveal-delay-4 { transition-delay: 0.4s; }

/* ——— Responsive ——— */
@media (max-width: 1100px) {
    .categories-grid { grid-template-columns: repeat(3, 1fr); }
    .products-grid { grid-template-columns: repeat(2, 1fr); }
    .why-grid { grid-template-columns: repeat(2, 1fr); }
    .footer-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 900px) {
    .nav-links { display: none; }
    .menu-toggle { display: flex; align-items: center; justify-content: center; }

    .nav-links.open {
        display: flex;
        flex-direction: column;
        position: fixed;
        top: var(--nav-h);
        left: 0;
        right: 0;
        background: var(--white);
        padding: 20px;
        box-shadow: var(--shadow-md);
        gap: 4px;
        z-index: 999;
    }

    .nav-links.open a { width: 100%; text-align: center; padding: 14px; }
}

@media (max-width: 700px) {
    .section { padding: 64px 0; }
    .categories-grid { grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .category-img-wrap { height: 140px; }
    .products-grid { grid-template-columns: 1fr; max-width: 400px; margin: 0 auto; }
    .why-grid { grid-template-columns: 1fr; gap: 16px; }
    .footer { padding: 22px 0 10px; }
    .footer-grid { grid-template-columns: 1fr; gap: 16px; margin-bottom: 12px; }
    .hero-actions { flex-direction: column; align-items: stretch; }
    .hero-actions .btn { width: 100%; max-width: 320px; margin: 0 auto; }
}

@media (max-width: 480px) {
    .categories-grid { grid-template-columns: 1fr; }
}
</style>
</head>

<body>

<!-- Navbar -->
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
            <li><a href="<%= ctx %>/home" class="active">Home</a></li>
            <li><a href="<%= ctx %>/products">Products</a></li>
            <li><a href="#categories">Categories</a></li>
            <li><a href="<%= ctx %>/cart">Cart</a></li>
            <li><a href="#contact">Contact</a></li>
        </ul>

        <button class="menu-toggle" id="menuToggle" aria-label="Open menu" type="button">
            <i class="fas fa-bars"></i>
        </button>
    </div>
</nav>

<!-- Hero -->
<section class="hero">
    <div class="hero-bg" aria-hidden="true"></div>
    <div class="hero-overlay" aria-hidden="true"></div>
    <div class="hero-pattern" aria-hidden="true"></div>
    <div class="hero-content">
        <div class="hero-badge"><i class="fas fa-star"></i> Premium Ceylon Collection</div>
        <h1>Authentic Sri Lankan Heritage</h1>
        <p class="hero-subtitle">Discover premium Ceylon tea, spices, handcrafted items, and natural treasures.</p>
        <div class="hero-actions">
            <a href="<%= ctx %>/products" class="btn btn-primary"><i class="fas fa-compass"></i> Explore Collection</a>
            <a href="<%= ctx %>/products" class="btn btn-outline"><i class="fas fa-shopping-cart"></i> Shop Now</a>
        </div>
    </div>
    <a href="#categories" class="hero-scroll" aria-hidden="true">
        <span>Scroll</span>
        <i class="fas fa-chevron-down"></i>
    </a>
</section>

<!-- Categories -->
<section class="section section-beige" id="categories">
    <div class="container">
        <div class="section-header reveal">
            <span class="section-label">Browse</span>
            <h2>Shop by Category</h2>
            <p>Explore our finest authentic collections from the pearl of the Indian Ocean</p>
            <div class="section-divider"></div>
        </div>
        <div class="categories-grid">
            <a href="<%= ctx %>/products?category=tea" class="category-card reveal reveal-delay-1">
                <div class="category-img-wrap">
                    <img src="<%= ctx %>/images/black%20tea.jpg" alt="Ceylon Tea">
                </div>
                <div class="category-body">
                    <h3>Tea</h3>
                    <span>Premium Ceylon blends</span>
                </div>
            </a>
            <a href="<%= ctx %>/products?category=spices" class="category-card reveal reveal-delay-2">
                <div class="category-img-wrap">
                    <img src="<%= ctx %>/images/ceylon%20cinamon.webp" alt="Spices">
                </div>
                <div class="category-body">
                    <h3>Spices</h3>
                    <span>Pure &amp; aromatic</span>
                </div>
            </a>
            <a href="<%= ctx %>/products?category=batik" class="category-card reveal reveal-delay-3">
                <div class="category-img-wrap">
                    <img src="<%= ctx %>/images/batik%20saree.jpg" alt="Batik">
                </div>
                <div class="category-body">
                    <h3>Batik</h3>
                    <span>Traditional artistry</span>
                </div>
            </a>
            <a href="<%= ctx %>/products?category=ayurveda" class="category-card reveal reveal-delay-4">
                <div class="category-img-wrap">
                    <img src="<%= ctx %>/images/oill.jpg" alt="Ayurveda">
                </div>
                <div class="category-body">
                    <h3>Ayurveda</h3>
                    <span>Natural wellness</span>
                </div>
            </a>
            <a href="<%= ctx %>/products?category=handicrafts" class="category-card reveal">
                <div class="category-img-wrap">
                    <img src="<%= ctx %>/images/wooden%20elephant.jpg" alt="Handicrafts">
                </div>
                <div class="category-body">
                    <h3>Handicrafts</h3>
                    <span>Handmade treasures</span>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Featured Products -->
<section class="section section-white" id="featured">
    <div class="container">
        <div class="section-header reveal">
            <span class="section-label">Curated</span>
            <h2>Featured Products</h2>
            <p>Handpicked favourites loved by customers worldwide</p>
            <div class="section-divider"></div>
        </div>
        <div class="products-grid">
            <article class="product-card reveal reveal-delay-1">
                <div class="product-img">
                    <img src="<%= ctx %>/images/Ceylon-Green-Tea.jpg" alt="Ceylon Green Tea">
                    <span class="product-tag">Bestseller</span>
                </div>
                <div class="product-body">
                    <h3>Ceylon Green Tea</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                        <span>4.8 (124)</span>
                    </div>
                    <p class="product-price">Rs. 1,250 <span>/ 100g</span></p>
                    <a href="<%= ctx %>/cart?product=Ceylon%20Green%20Tea" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
            <article class="product-card reveal reveal-delay-2">
                <div class="product-img">
                    <img src="<%= ctx %>/images/ceylon%20cinamon.webp" alt="Ceylon Cinnamon">
                    <span class="product-tag">Organic</span>
                </div>
                <div class="product-body">
                    <h3>Ceylon Cinnamon Sticks</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                        <span>5.0 (89)</span>
                    </div>
                    <p class="product-price">Rs. 890 <span>/ 50g</span></p>
                    <a href="<%= ctx %>/cart?product=Ceylon%20Cinnamon" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
            <article class="product-card reveal reveal-delay-3">
                <div class="product-img">
                    <img src="<%= ctx %>/images/batik%20saree.jpg" alt="Batik Saree">
                    <span class="product-tag">Handmade</span>
                </div>
                <div class="product-body">
                    <h3>Traditional Batik Saree</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="far fa-star"></i></span>
                        <span>4.6 (56)</span>
                    </div>
                    <p class="product-price">Rs. 8,500 <span>/ each</span></p>
                    <a href="<%= ctx %>/order.jsp" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
            <article class="product-card reveal reveal-delay-1">
                <div class="product-img">
                    <img src="<%= ctx %>/images/herbal%20tea.jpg" alt="Herbal Tea">
                    <span class="product-tag">Wellness</span>
                </div>
                <div class="product-body">
                    <h3>Ayurvedic Herbal Tea</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                        <span>4.7 (72)</span>
                    </div>
                    <p class="product-price">Rs. 1,100 <span>/ 100g</span></p>
                    <a href="<%= ctx %>/cart?product=Herbal%20Tea" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
            <article class="product-card reveal reveal-delay-2">
                <div class="product-img">
                    <img src="<%= ctx %>/images/cardomom.jpg" alt="Cardamom">
                    <span class="product-tag">Spices</span>
                </div>
                <div class="product-body">
                    <h3>Premium Green Cardamom</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i></span>
                        <span>4.9 (41)</span>
                    </div>
                    <p class="product-price">Rs. 1,650 <span>/ 100g</span></p>
                    <a href="<%= ctx %>/cart?product=Cardamom" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
            <article class="product-card reveal reveal-delay-3">
                <div class="product-img">
                    <img src="<%= ctx %>/images/wooden%20elephant.jpg" alt="Wooden Elephant">
                    <span class="product-tag">Craft</span>
                </div>
                <div class="product-body">
                    <h3>Handcarved Wooden Elephant</h3>
                    <div class="product-rating">
                        <span class="stars"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star-half-alt"></i></span>
                        <span>4.8 (33)</span>
                    </div>
                    <p class="product-price">Rs. 3,200 <span>/ piece</span></p>
                    <a href="<%= ctx %>/order.jsp" class="btn-cart"><i class="fas fa-plus"></i> Add to Cart</a>
                </div>
            </article>
        </div>
    </div>
</section>

<!-- Why Choose Us -->
<section class="section section-beige" id="why-us">
    <div class="container">
        <div class="section-header reveal">
            <span class="section-label">Our Promise</span>
            <h2>Why Choose Us</h2>
            <p>Quality, authenticity, and care in every product we deliver</p>
            <div class="section-divider"></div>
        </div>
        <div class="why-grid">
            <div class="why-card reveal reveal-delay-1">
                <div class="why-icon"><i class="fas fa-certificate"></i></div>
                <h3>100% Authentic</h3>
                <p>Genuine Sri Lankan products sourced directly from trusted local producers.</p>
            </div>
            <div class="why-card reveal reveal-delay-2">
                <div class="why-icon"><i class="fas fa-seedling"></i></div>
                <h3>Natural &amp; Organic</h3>
                <p>Tea, spices, and herbs grown using traditional, chemical-free methods.</p>
            </div>
            <div class="why-card reveal reveal-delay-3">
                <div class="why-icon"><i class="fas fa-hands"></i></div>
                <h3>Handmade</h3>
                <p>Batik, masks, and crafts lovingly made by skilled local artisans.</p>
            </div>
            <div class="why-card reveal reveal-delay-4">
                <div class="why-icon"><i class="fas fa-truck-fast"></i></div>
                <h3>Fast Delivery</h3>
                <p>Careful packaging and swift shipping to bring Ceylon to your doorstep.</p>
            </div>
        </div>
    </div>
</section>

<!-- CTA -->
<section class="cta-section reveal">
    <div class="cta-inner">
        <h2>Ready to Experience Ceylon?</h2>
        <p>Bring the taste, aroma, and artistry of Sri Lanka into your home. Start your authentic journey today.</p>
        <a href="<%= ctx %>/order.jsp" class="btn btn-cta"><i class="fas fa-gift"></i> Order Now</a>
    </div>
</section>

<!-- Footer -->
<footer class="footer" id="contact">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand">
                <a href="<%= ctx %>/home" class="logo">
                    <div class="logo-icon"><i class="fas fa-leaf"></i></div>
                    <div class="logo-text">
                        <strong>Ceylon Authentic</strong>
                        <span>Sri Lankan Heritage</span>
                    </div>
                </a>
                <p>Your trusted destination for premium Ceylon tea, spices, batik, Ayurveda, and handcrafted treasures.</p>
                <div class="social-links">
                    <a href="#" aria-label="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" aria-label="Instagram"><i class="fab fa-instagram"></i></a>
                    <a href="#" aria-label="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" aria-label="YouTube"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
            <div>
                <h4>Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="<%= ctx %>/home">Home</a></li>
                    <li><a href="<%= ctx %>/products">Products</a></li>
                    <li><a href="#categories">Categories</a></li>
                    <li><a href="<%= ctx %>/cart">Cart</a></li>
                    <li><a href="<%= ctx %>/order.jsp">Place Order</a></li>
                </ul>
            </div>
            <div>
                <h4>Categories</h4>
                <ul class="footer-links">
                    <li><a href="<%= ctx %>/products?category=tea">Tea</a></li>
                    <li><a href="<%= ctx %>/products?category=spices">Spices</a></li>
                    <li><a href="<%= ctx %>/products?category=batik">Batik</a></li>
                    <li><a href="<%= ctx %>/products?category=ayurveda">Ayurveda</a></li>
                    <li><a href="<%= ctx %>/products?category=handicrafts">Handicrafts</a></li>
                </ul>
            </div>
            <div>
                <h4>Contact Us</h4>
                <ul class="footer-contact">
                    <li><i class="fas fa-location-dot"></i><span>123 Galle Road, Colombo 03, Sri Lanka</span></li>
                    <li><i class="fas fa-phone"></i><span>+94 11 234 5678</span></li>
                    <li><i class="fas fa-envelope"></i><span>info@ceylonauthentic.lk</span></li>
                    <li><i class="fas fa-clock"></i><span>Mon – Sat: 9:00 AM – 6:00 PM</span></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <span>&copy; 2026 Ceylon Authentic Store. All rights reserved.</span>
            <span>Made with <i class="fas fa-heart" style="color:rgba(15,81,50,0.35)"></i> in Sri Lanka</span>
        </div>
    </div>
</footer>

<script>
(function () {
    var navbar = document.getElementById("navbar");
    var menuToggle = document.getElementById("menuToggle");
    var navLinks = document.getElementById("navLinks");
    window.addEventListener("scroll", function () {
        navbar.classList.toggle("scrolled", window.scrollY > 40);
    });

    menuToggle.addEventListener("click", function () {
        navLinks.classList.toggle("open");
        var icon = menuToggle.querySelector("i");
        icon.classList.toggle("fa-bars");
        icon.classList.toggle("fa-times");
    });

    navLinks.querySelectorAll("a").forEach(function (link) {
        link.addEventListener("click", function () {
            navLinks.classList.remove("open");
            var icon = menuToggle.querySelector("i");
            icon.classList.add("fa-bars");
            icon.classList.remove("fa-times");
        });
    });

    var reveals = document.querySelectorAll(".reveal");
    var observer = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add("visible");
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12, rootMargin: "0px 0px -40px 0px" });

    reveals.forEach(function (el) { observer.observe(el); });
})();
</script>

</body>
</html>
