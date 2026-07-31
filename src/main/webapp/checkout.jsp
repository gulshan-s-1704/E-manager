<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Checkout - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Checkout</h1>

<c:if test="${not empty checkoutError}">
    <div class="alert error">${checkoutError}</div>
</c:if>

<div style="display:flex; gap:24px; flex-wrap:wrap;">
    <div class="card" style="flex:2; min-width:320px;">
        <h2>Order Summary</h2>
        <table>
            <thead><tr><th>Product</th><th>Qty</th><th>Subtotal</th></tr></thead>
            <tbody>
                <c:set var="total" value="${0}"/>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.quantity}</td>
                        <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/></td>
                    </tr>
                    <c:set var="total" value="${total + item.subtotal}"/>
                </c:forEach>
            </tbody>
        </table>
        <h3 style="text-align:right;">Total: <fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></h3>
    </div>

    <div class="card" style="flex:1; min-width:280px;">
        <h2>Shipping & Payment</h2>
        <form action="${pageContext.request.contextPath}/checkout" method="post">
            <div class="form-group">
                <label>Shipping Address</label>
                <textarea name="shippingAddress" rows="3" required>${customer.address}</textarea>
            </div>
            <div class="form-group">
                <label>Payment Method</label>
                <select name="paymentMethod" required>
                    <option value="CARD">Credit / Debit Card</option>
                    <option value="UPI">UPI</option>
                    <option value="NET_BANKING">Net Banking</option>
                    <option value="COD">Cash on Delivery</option>
                </select>
            </div>
            <button class="btn accent" type="submit" style="width:100%;">Place Order</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
