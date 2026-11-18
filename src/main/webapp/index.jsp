<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ecommerce.dao.ProductDAO, com.ecommerce.dao.CategoryDAO, com.ecommerce.model.Product, com.ecommerce.model.Category, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    try {
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        List<Product> allProds = productDAO.getAllProducts();
        List<Category> allCats = categoryDAO.getAllCategories();
        
        // 8 featured products for homepage
        List<Product> featured = allProds;
        if (allProds != null && allProds.size() > 8) {
            featured = allProds.subList(0, 8);
        }
        
        request.setAttribute("featuredProducts", featured);
        request.setAttribute("categories", allCats);
        request.setAttribute("totalCatalogCount", allProds != null ? allProds.size() : 0);
    } catch (Exception e) {
        request.setAttribute("dbError", e.getMessage());
    }
%>

<c:set var="pageTitle" value="E-Manager – Premium E-Commerce Experience"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<!-- Hero Banner (2-Column Responsive Layout) -->
<section class="hero">
    <div class="hero-content">
        <div class="hero-pill">
            🚀 <span>NEXT-GEN SHOPPING PLATFORM &bull; 30+ PRODUCTS LIVE</span>
        </div>
        <h1>Elevate Your Daily Lifestyle &amp; Workspace</h1>
        <p>
            Discover high-performance audio, sleek electronics, contemporary streetwear, and minimalist desk aesthetics with real-time stock availability and seamless simulated checkout.
        </p>
        <div class="hero-actions">
            <a class="btn large accent" href="${pageContext.request.contextPath}/products">
                🛍️ Explore All Products
            </a>
            <a class="btn large outline" href="#categories-section" style="color:#ffffff; border-color:rgba(255,255,255,0.4); background:rgba(255,255,255,0.08);">
                Explore Categories &darr;
            </a>
        </div>
        <div class="hero-trust-row">
            <div class="hero-trust-item"><span class="check">✓</span> <span>Free Express Shipping</span></div>
            <div class="hero-trust-item"><span class="check">✓</span> <span>30-Day Guarantee</span></div>
            <div class="hero-trust-item"><span class="check">✓</span> <span>ACID-Safe Orders</span></div>
        </div>
    </div>

    <!-- Spotlight Hero Showcase Product (Right Column) -->
    <div class="hero-spotlight">
        <div class="spotlight-header">
            <span class="spotlight-badge">⭐ Flagship Pick</span>
            <span class="spotlight-rating">★★★★★ 4.9</span>
        </div>
        <div class="spotlight-img-wrap">
            <img src="${pageContext.request.contextPath}/images/products/elec_headphones.jpg" alt="Wireless Noise-Cancelling Headphones">
        </div>
        <div class="spotlight-info">
            <span class="product-category-tag" style="background:rgba(255,255,255,0.15); color:#93c5fd; border:1px solid rgba(255,255,255,0.2);">Electronics</span>
            <h3 style="color:#ffffff; font-size:1.15rem; margin:6px 0 4px; font-weight:700;">Wireless Over-Ear Headphones</h3>
            <p style="color:#cbd5e1; font-size:0.85rem; line-height:1.4; margin-bottom:12px;">High-fidelity titanium dynamic drivers with 45-hour battery life &amp; active noise cancellation.</p>
            <div class="spotlight-price-row">
                <span class="spotlight-price">₹2,999.00</span>
                <span class="spotlight-orig-price">₹4,499.00</span>
                <span class="discount-badge">33% OFF</span>
            </div>
            <form action="${pageContext.request.contextPath}/cart" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="productId" value="1">
                <input type="hidden" name="quantity" value="1">
                <button class="btn accent" type="submit" style="width:100%;">
                    ⚡ Quick Add to Cart
                </button>
            </form>
        </div>
    </div>
</section>

<!-- Value Props / Feature Highlights Grid -->
<div class="features-bar">
    <div class="feature-box">
        <div class="feature-icon" style="background:#eff6ff; color:#2563eb;">⚡</div>
        <div class="feature-info">
            <h4>Fast Delivery</h4>
            <p>Express dispatch within 24 hours</p>
        </div>
    </div>
    <div class="feature-box">
        <div class="feature-icon" style="background:#ecfdf5; color:#10b981;">🛡️</div>
        <div class="feature-info">
            <h4>100% Genuine</h4>
            <p>Verified authentic merchandise</p>
        </div>
    </div>
    <div class="feature-box">
        <div class="feature-icon" style="background:#fffbeb; color:#f59e0b;">📦</div>
        <div class="feature-info">
            <h4>Live Stock Tracking</h4>
            <p>Real-time database-driven inventory</p>
        </div>
    </div>
    <div class="feature-box">
        <div class="feature-icon" style="background:#f5f3ff; color:#7c3aed;">💳</div>
        <div class="feature-info">
            <h4>Simulated Checkout</h4>
            <p>Safe test payments &amp; instant tracking</p>
        </div>
    </div>
</div>

<!-- Featured Categories Section -->
<section id="categories-section" style="margin-bottom: 48px;">
    <div class="section-header">
        <div>
            <h2>Shop by Category</h2>
            <p>Explore curated product collections designed for work, style, and everyday comfort</p>
        </div>
        <a class="btn outline small" href="${pageContext.request.contextPath}/products">View All &rarr;</a>
    </div>

    <div class="categories-grid">
        <div class="category-card">
            <div class="category-icon" style="background:#eff6ff; color:#2563eb;">🎧</div>
            <h3>Electronics</h3>
            <p>High-fidelity headphones, wireless speakers, mechanical keyboards, and 4K webcams.</p>
            <a class="btn small" href="${pageContext.request.contextPath}/products?categoryId=1">Shop Electronics</a>
        </div>
        <div class="category-card">
            <div class="category-icon" style="background:#fdf2f8; color:#db2777;">👕</div>
            <h3>Fashion</h3>
            <p>Organic cotton tees, fleece hoodies, athletic sneakers, and rugged denim jackets.</p>
            <a class="btn small" href="${pageContext.request.contextPath}/products?categoryId=2">Shop Fashion</a>
        </div>
        <div class="category-card">
            <div class="category-icon" style="background:#ecfdf5; color:#059669;">🪴</div>
            <h3>Home &amp; Lifestyle</h3>
            <p>Dimmable LED desk lamps, insulated water bottles, desk caddies, and soy candles.</p>
            <a class="btn small" href="${pageContext.request.contextPath}/products?categoryId=3">Shop Lifestyle</a>
        </div>
        <div class="category-card">
            <div class="category-icon" style="background:#fff7ed; color:#ea580c;">💼</div>
            <h3>Accessories</h3>
            <p>Full-grain leather wallets, aluminum laptop risers, polarized shades, and cardholders.</p>
            <a class="btn small" href="${pageContext.request.contextPath}/products?categoryId=4">Shop Accessories</a>
        </div>
    </div>
</section>

<!-- Featured Products Section -->
<section style="margin-bottom: 48px;">
    <div class="section-header">
        <div>
            <h2>Featured Products</h2>
            <p>Top-rated selections loved by customers across India</p>
        </div>
        <a class="btn outline small" href="${pageContext.request.contextPath}/products">Browse Catalog (${totalCatalogCount}) &rarr;</a>
    </div>

    <c:choose>
        <c:when test="${empty featuredProducts}">
            <div class="card" style="text-align:center; padding:48px;">
                <p style="color:var(--text-muted); font-size:1.05rem;">No products currently found in the catalog.</p>
                <a class="btn" href="${pageContext.request.contextPath}/products">Refresh Products</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="p" items="${featuredProducts}">
                    <div class="product-card">
                        <div class="product-img-wrap">
                            <c:set var="imgSrc" value="${p.imageUrl}"/>
                            <c:choose>
                                <c:when test="${not empty imgSrc && (imgSrc.startsWith('http://') || imgSrc.startsWith('https://'))}">
                                    <img src="${imgSrc}" alt="${p.name}">
                                </c:when>
                                <c:when test="${not empty imgSrc}">
                                    <img src="${pageContext.request.contextPath}/${imgSrc}" alt="${p.name}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/images/products/elec_headphones.jpg" alt="${p.name}">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-info">
                            <span class="product-category-tag">${p.categoryName != null ? p.categoryName : 'Catalog'}</span>
                            <h3 class="product-title" title="${p.name}">${p.name}</h3>
                            <div class="product-rating">
                                <span>★★★★☆</span>
                                <span class="rating-count">(4.8)</span>
                            </div>
                            <p class="product-desc">${p.description}</p>
                            
                            <div class="price-row">
                                <span class="price-current">
                                    <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/>
                                </span>
                                <span class="price-original">
                                    <fmt:formatNumber value="${p.price * 1.25}" type="currency" currencySymbol="₹"/>
                                </span>
                                <span class="discount-badge">20% OFF</span>
                            </div>

                            <c:choose>
                                <c:when test="${p.stockQuantity == 0}">
                                    <span class="stock-status-tag out">● Out of stock</span>
                                </c:when>
                                <c:when test="${p.stockQuantity <= 10}">
                                    <span class="stock-status-tag low">● Only ${p.stockQuantity} left</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-status-tag in">● In stock (${p.stockQuantity})</span>
                                </c:otherwise>
                            </c:choose>

                            <div class="card-actions">
                                <c:choose>
                                    <c:when test="${p.stockQuantity > 0}">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:flex; gap:6px;">
                                            <input type="hidden" name="action" value="add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <button class="btn small" type="submit" style="flex:1;">🛒 Add to Cart</button>
                                            <a class="btn outline small" href="${pageContext.request.contextPath}/products?action=view&id=${p.productId}">Details</a>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="btn outline small" href="${pageContext.request.contextPath}/products?action=view&id=${p.productId}" style="width:100%;">View Details</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
