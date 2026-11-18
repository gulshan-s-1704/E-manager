<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.ecommerce.dao.ProductDAO, com.ecommerce.dao.CategoryDAO, com.ecommerce.model.Product, com.ecommerce.model.Category, java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Safety fallback if accessed directly at /products.jsp instead of /products servlet
    if (request.getAttribute("products") == null) {
        try {
            ProductDAO pDao = new ProductDAO();
            CategoryDAO cDao = new CategoryDAO();
            request.setAttribute("products", pDao.getAllProducts());
            request.setAttribute("categories", cDao.getAllCategories());
        } catch (Exception ignored) {}
    }
%>

<c:set var="pageTitle" value="Products Catalog – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="section-header" style="margin-bottom:24px;">
    <div>
        <h1 style="font-size:2rem; font-weight:800; margin-bottom:6px;">All Products Catalog</h1>
        <p style="color:var(--text-muted);">Explore our complete collection of ${products != null ? products.size() : 0} items across Electronics, Fashion, Home &amp; Living, and Accessories.</p>
    </div>
</div>

<!-- Search & Filtering Toolbar -->
<div class="catalog-toolbar">
    <form class="search-form" action="${pageContext.request.contextPath}/products" method="get">
        <input type="text" name="keyword" placeholder="Search by product name, features, or brand..." value="${keyword}">
        <select name="categoryId">
            <option value="">All Categories</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryId}" ${selectedCategoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
            </c:forEach>
        </select>
        <button class="btn" type="submit">🔍 Search</button>
        <c:if test="${not empty keyword || not empty selectedCategoryId}">
            <a class="btn outline" href="${pageContext.request.contextPath}/products">Reset</a>
        </c:if>
    </form>
</div>

<!-- Quick Category Filter Pills -->
<div style="display:flex; gap:8px; flex-wrap:wrap; margin-bottom:28px;">
    <a class="btn small ${empty selectedCategoryId ? 'accent' : 'outline'}" href="${pageContext.request.contextPath}/products">All Categories</a>
    <c:forEach var="cat" items="${categories}">
        <a class="btn small ${selectedCategoryId == cat.categoryId ? 'accent' : 'outline'}" 
           href="${pageContext.request.contextPath}/products?categoryId=${cat.categoryId}">
            ${cat.name}
        </a>
    </c:forEach>
</div>

<c:choose>
    <c:when test="${empty products}">
        <div class="card" style="text-align:center; padding:60px 20px;">
            <div style="font-size:3rem; margin-bottom:12px;">🔍</div>
            <h3>No products found</h3>
            <p style="color:var(--text-muted); margin-bottom:20px;">We couldn't find any items matching your search criteria. Try a different search term or clear the filter.</p>
            <a class="btn" href="${pageContext.request.contextPath}/products">View All Products</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="product-grid">
            <c:forEach var="p" items="${products}">
                <div class="product-card">
                    <div class="product-img-wrap">
                        <c:set var="imgSrc" value="${p.imageUrl}"/>
                        <c:choose>
                            <c:when test="${not empty imgSrc && (imgSrc.startsWith('http://') || imgSrc.startsWith('https://'))}">
                                <img src="${imgSrc}" alt="${p.name}" loading="lazy">
                            </c:when>
                            <c:when test="${not empty imgSrc}">
                                <img src="${pageContext.request.contextPath}/${imgSrc}" alt="${p.name}" loading="lazy">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/images/products/elec_headphones.jpg" alt="${p.name}" loading="lazy">
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

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
