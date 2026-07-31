<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Track Order #${order.orderId} - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Order #${order.orderId}</h1>
<p>Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, HH:mm"/> &middot; Shipping to: ${order.shippingAddress}</p>

<c:choose>
    <c:when test="${order.status == 'CANCELLED'}">
        <div class="alert error">This order was cancelled.</div>
    </c:when>
    <c:otherwise>
        <c:set var="stageNum" value="${order.status == 'PENDING' ? 1 : order.status == 'CONFIRMED' ? 2 : order.status == 'SHIPPED' ? 3 : order.status == 'DELIVERED' ? 4 : 0}"/>
        <div class="tracker">
            <div class="step ${stageNum >= 1 ? (stageNum == 1 ? 'current' : 'done') : ''}"><div class="dot">1</div>Pending</div>
            <div class="step ${stageNum >= 2 ? (stageNum == 2 ? 'current' : 'done') : ''}"><div class="dot">2</div>Confirmed</div>
            <div class="step ${stageNum >= 3 ? (stageNum == 3 ? 'current' : 'done') : ''}"><div class="dot">3</div>Shipped</div>
            <div class="step ${stageNum >= 4 ? 'done' : ''}"><div class="dot">4</div>Delivered</div>
        </div>
    </c:otherwise>
</c:choose>

<div class="card">
    <h2>Items</h2>
    <table>
        <thead><tr><th>Product</th><th>Qty</th><th>Unit Price</th><th>Subtotal</th></tr></thead>
        <tbody>
            <c:forEach var="item" items="${order.items}">
                <tr>
                    <td>${item.productName}</td>
                    <td>${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/></td>
                    <td><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <h3 style="text-align:right;">Total: <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/></h3>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
