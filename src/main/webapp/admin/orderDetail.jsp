<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Order #${order.orderId} Details – Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
    <span>&rsaquo;</span>
    <a href="${pageContext.request.contextPath}/admin/orders">All Orders</a>
    <span>&rsaquo;</span>
    <span style="color:var(--slate-900); font-weight:600;">Order #${order.orderId}</span>
</div>

<div class="card" style="padding:32px;">
    <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:16px; margin-bottom:28px; padding-bottom:20px; border-bottom:1px solid var(--border);">
        <div>
            <div style="font-size:0.82rem; font-weight:700; text-transform:uppercase; color:var(--primary); letter-spacing:0.04em;">Order Fulfillment Inspector</div>
            <h1 style="font-size:1.8rem; margin:4px 0 6px;">Order #${order.orderId}</h1>
            <div style="font-size:0.88rem; color:var(--slate-600);">
                Customer: <strong>${order.customerName}</strong> (ID: #${order.customerId}) &bull; Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
            </div>
        </div>
        <div style="text-align:right;">
            <span class="status-pill status-${order.status}" style="font-size:0.9rem; padding:6px 14px;">
                ● Current Status: ${order.status}
            </span>
            <div style="margin-top:6px; font-size:1.35rem; font-weight:800; color:var(--slate-900);">
                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/>
            </div>
        </div>
    </div>

    <!-- Status Transition Control Form -->
    <div style="background:var(--slate-50); border:1px solid var(--border); border-radius:var(--radius-lg); padding:20px; margin-bottom:28px;">
        <h3 style="font-size:1.05rem; margin:0 0 12px;">Advance Fulfillment Status</h3>
        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="action" value="updateStatus">
            
            <label for="status" style="font-weight:700; font-size:0.9rem; color:var(--slate-700);">Change Stage to:</label>
            <select class="form-control" id="status" name="status" style="width:auto; min-width:180px; font-weight:600;">
                <option value="PENDING" ${order.status == 'PENDING' ? 'selected' : ''}>⏳ Pending</option>
                <option value="CONFIRMED" ${order.status == 'CONFIRMED' ? 'selected' : ''}>✓ Confirmed</option>
                <option value="SHIPPED" ${order.status == 'SHIPPED' ? 'selected' : ''}>🚚 Shipped</option>
                <option value="DELIVERED" ${order.status == 'DELIVERED' ? 'selected' : ''}>📦 Delivered</option>
                <option value="CANCELLED" ${order.status == 'CANCELLED' ? 'selected' : ''}>✕ Cancelled</option>
            </select>

            <button class="btn accent" type="submit">
                💾 Save Status Update
            </button>
        </form>
    </div>

    <!-- Shipping Destination Info -->
    <div style="background:white; border:1px solid var(--border); border-radius:var(--radius-md); padding:16px 20px; margin-bottom:24px;">
        <strong style="display:block; margin-bottom:4px; color:var(--slate-900);">📍 Shipping Address:</strong>
        <span style="color:var(--slate-700);">${order.shippingAddress}</span>
    </div>

    <!-- Order Items Table -->
    <h3 style="margin-bottom:14px;">Order Line Items (${order.items.size()})</h3>
    <div class="table-card" style="margin-bottom:24px;">
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Unit Price</th>
                    <th>Ordered Quantity</th>
                    <th style="text-align:right;">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${order.items}">
                    <tr>
                        <td>
                            <strong style="color:var(--slate-900);">${item.productName}</strong>
                            <div style="font-size:0.75rem; color:var(--text-muted);">Product ID: #${item.productId}</div>
                        </td>
                        <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/></td>
                        <td><strong style="font-weight:700;">${item.quantity}</strong></td>
                        <td style="text-align:right; font-weight:700; color:var(--slate-900);">
                            <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div style="display:flex; justify-content:space-between; align-items:center;">
        <a class="btn outline" href="${pageContext.request.contextPath}/admin/orders">&larr; Back to All Orders</a>
        <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Return to Dashboard</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
