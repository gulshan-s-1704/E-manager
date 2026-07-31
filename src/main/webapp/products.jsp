<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Products - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Product Catalog</h1>

<form class="search-bar" action="${pageContext.request.contextPath}/products" method="get">
    <input type="text" name="keyword" placeholder="Search products..." value="${keyword}">
    <select name="categoryId">
        <option value="">All Categories</option>
        <c:forEach var="cat" items="${categories}">
            <option value="${cat.categoryId}" ${selectedCategoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
        </c:forEach>
    </select>
    <button type="submit">Search</button>
</form>

<c:choose>
    <c:when test="${empty products}">
        <p>No products found.</p>
    </c:when>
    <c:otherwise>
        <div class="product-grid">
            <c:forEach var="p" items="${products}">
                <div class="product-card">
                    <img src="https://via.placeholder.com/230x150?text=${p.name}" alt="${p.name}">
                    <h3>${p.name}</h3>
                    <div class="price"><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/></div>
                    <c:choose>
                        <c:when test="${p.stockQuantity == 0}">
                            <span class="stock-badge out">Out of stock</span>
                        </c:when>
                        <c:when test="${p.stockQuantity <= 10}">
                            <span class="stock-badge low">Only ${p.stockQuantity} left</span>
                        </c:when>
                        <c:otherwise>
                            <span class="stock-badge in">In stock</span>
                        </c:otherwise>
                    </c:choose>
                    <br><br>
                    <a class="btn small" href="${pageContext.request.contextPath}/products?action=view&id=${p.productId}">View Details</a>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
