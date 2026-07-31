<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Your Cart - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Shopping Cart</h1>

<c:if test="${not empty cartError}">
    <div class="alert error">${cartError}</div>
</c:if>

<c:choose>
    <c:when test="${empty cartItems}">
        <p>Your cart is empty. <a href="${pageContext.request.contextPath}/products">Continue shopping</a></p>
    </c:when>
    <c:otherwise>
        <table>
            <thead>
                <tr><th>Product</th><th>Unit Price</th><th>Quantity</th><th>Subtotal</th><th></th></tr>
            </thead>
            <tbody>
                <c:set var="total" value="${0}"/>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>${item.productName}</td>
                        <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display:flex; gap:6px;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <input type="number" name="quantity" value="${item.quantity}" min="0" style="width:60px;">
                                <button class="btn small" type="submit">Update</button>
                            </form>
                        </td>
                        <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <button class="btn small danger" type="submit">Remove</button>
                            </form>
                        </td>
                    </tr>
                    <c:set var="total" value="${total + item.subtotal}"/>
                </c:forEach>
            </tbody>
        </table>

        <div class="card" style="margin-top:20px; text-align:right;">
            <h2>Total: <fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></h2>
            <a class="btn" href="${pageContext.request.contextPath}/checkout">Proceed to Checkout</a>
            <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                <input type="hidden" name="action" value="clear">
                <button class="btn danger" type="submit">Clear Cart</button>
            </form>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
