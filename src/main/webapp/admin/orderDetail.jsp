<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Order #${order.orderId} - Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<a href="${pageContext.request.contextPath}/admin/orders">&larr; Back to all orders</a>

<div class="card">
    <h1>Order #${order.orderId}</h1>
    <p><strong>Customer:</strong> ${order.customerName}</p>
    <p><strong>Placed:</strong> <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, HH:mm"/></p>
    <p><strong>Shipping Address:</strong> ${order.shippingAddress}</p>
    <p><strong>Current Status:</strong> <span class="status-pill status-${order.status}">${order.status}</span></p>

    <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:flex; gap:10px; align-items:center; margin-top:16px;">
        <input type="hidden" name="orderId" value="${order.orderId}">
        <input type="hidden" name="action" value="updateStatus">
        <label>Update Status:</label>
        <select name="status">
            <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>Pending</option>
            <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
            <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
            <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
            <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
        </select>
        <button class="btn accent" type="submit">Update</button>
    </form>
</div>

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
