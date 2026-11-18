<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${product.name} – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<!-- Breadcrumb Navigation -->
<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/">Home</a>
    <span>&rsaquo;</span>
    <a href="${pageContext.request.contextPath}/products">Products</a>
    <span>&rsaquo;</span>
    <a href="${pageContext.request.contextPath}/products?categoryId=${product.categoryId}">${product.categoryName}</a>
    <span>&rsaquo;</span>
    <span style="color:var(--slate-900); font-weight:600;">${product.name}</span>
</div>

<div class="detail-layout">
    <!-- Product Image Showcase -->
    <div class="detail-img-box">
        <c:set var="imgSrc" value="${product.imageUrl}"/>
        <c:choose>
            <c:when test="${not empty imgSrc && (imgSrc.startsWith('http://') || imgSrc.startsWith('https://'))}">
                <img src="${imgSrc}" alt="${product.name}">
            </c:when>
            <c:when test="${not empty imgSrc}">
                <img src="${pageContext.request.contextPath}/${imgSrc}" alt="${product.name}">
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/images/products/elec_headphones.jpg" alt="${product.name}">
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Product Metadata & Purchase Section -->
    <div class="detail-meta-box">
        <span class="product-category-tag">${product.categoryName}</span>
        <h1>${product.name}</h1>
        
        <div style="display:flex; align-items:center; gap:12px; margin-bottom:16px;">
            <span class="detail-sku-badge">SKU: ${product.sku}</span>
            <div class="product-rating" style="margin:0;">
                <span>★★★★★</span>
                <span class="rating-count">4.9 (128 customer ratings)</span>
            </div>
        </div>

        <div class="price-row" style="margin-bottom:20px;">
            <span class="price-current" style="font-size:2rem;">
                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₹"/>
            </span>
            <span class="price-original" style="font-size:1.1rem;">
                <fmt:formatNumber value="${product.price * 1.25}" type="currency" currencySymbol="₹"/>
            </span>
            <span class="discount-badge" style="font-size:0.85rem; padding:3px 8px;">20% OFF</span>
        </div>

        <c:choose>
            <c:when test="${product.stockQuantity == 0}">
                <span class="stock-status-tag out" style="margin-bottom:20px;">● Out of stock</span>
            </c:when>
            <c:when test="${product.stockQuantity <= 10}">
                <span class="stock-status-tag low" style="margin-bottom:20px;">● Hurry! Only ${product.stockQuantity} units left in stock</span>
            </c:when>
            <c:otherwise>
                <span class="stock-status-tag in" style="margin-bottom:20px;">● In Stock & Ready to Ship (${product.stockQuantity} available)</span>
            </c:otherwise>
        </c:choose>

        <p class="detail-desc">${product.description}</p>

        <!-- Technical / Product Specs -->
        <div class="detail-specs">
            <div class="spec-item">
                <span class="spec-label">Category</span>
                <span class="spec-val">${product.categoryName}</span>
            </div>
            <div class="spec-item">
                <span class="spec-label">Catalog Reference</span>
                <span class="spec-val">${product.sku}</span>
            </div>
            <div class="spec-item">
                <span class="spec-label">Dispatch Time</span>
                <span class="spec-val">Within 24 Hours</span>
            </div>
            <div class="spec-item">
                <span class="spec-label">Warranty / Guarantee</span>
                <span class="spec-val">1 Year Brand Warranty</span>
            </div>
        </div>

        <!-- Add to Cart Form -->
        <c:choose>
            <c:when test="${product.stockQuantity > 0}">
                <form action="${pageContext.request.contextPath}/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.productId}">
                    
                    <div class="detail-qty-form">
                        <label for="quantity" style="font-weight:700; font-size:0.92rem; color:var(--slate-700);">Quantity:</label>
                        <input class="qty-input" type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stockQuantity}">
                        <button class="btn large accent" type="submit" style="flex:1;">
                            🛒 Add to Cart &bull; <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₹"/>
                        </button>
                    </div>
                </form>
            </c:when>
            <c:otherwise>
                <div class="alert error" style="margin-top:16px;">
                    This item is currently sold out. Please check back later or explore alternative products.
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Trust Badges -->
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-top:28px; padding-top:20px; border-top:1px solid var(--border);">
            <div style="display:flex; align-items:center; gap:8px; font-size:0.82rem; color:var(--slate-600);">
                <span>🚚</span>
                <span><strong>Free Standard Delivery</strong> across all regions</span>
            </div>
            <div style="display:flex; align-items:center; gap:8px; font-size:0.82rem; color:var(--slate-600);">
                <span>🔒</span>
                <span><strong>Simulated Secure Payment</strong> with instant confirmation</span>
            </div>
        </div>
    </div>
</div>

<div style="margin-top:32px;">
    <a class="btn outline" href="${pageContext.request.contextPath}/products">&larr; Back to Products Catalog</a>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
