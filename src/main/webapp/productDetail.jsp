<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${product.name} - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<a href="${pageContext.request.contextPath}/products">&larr; Back to products</a>

<div class="card" style="display:flex; gap:30px; flex-wrap:wrap; margin-top:16px;">
    <img src="https://via.placeholder.com/320x240?text=${product.name}" style="border-radius:8px;">
    <div style="flex:1; min-width:250px;">
        <h1>${product.name}</h1>
        <p style="color:var(--muted);">Category: ${product.categoryName} | SKU: ${product.sku}</p>
        <p>${product.description}</p>
        <div class="price" style="font-size:1.6rem;"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="₹"/></div>

        <c:choose>
            <c:when test="${product.stockQuantity == 0}">
                <p class="stock-badge out">Out of stock</p>
            </c:when>
            <c:otherwise>
                <p class="stock-badge in">${product.stockQuantity} in stock</p>
                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin-top:16px; display:flex; gap:10px; align-items:center;">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <label>Qty:</label>
                    <input type="number" name="quantity" value="1" min="1" max="${product.stockQuantity}" style="width:70px;">
                    <button class="btn accent" type="submit">Add to Cart</button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
