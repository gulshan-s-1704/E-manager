<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Track Order #${order.orderId} – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="breadcrumb">
    <a href="${pageContext.request.contextPath}/">Home</a>
    <span>&rsaquo;</span>
    <a href="${pageContext.request.contextPath}/orders">My Orders</a>
    <span>&rsaquo;</span>
    <span style="color:var(--slate-900); font-weight:600;">Order #${order.orderId}</span>
</div>

<div class="card" style="padding:32px;">
    <div style="display:flex; justify-content:space-between; align-items:flex-start; flex-wrap:wrap; gap:16px; margin-bottom:28px; padding-bottom:20px; border-bottom:1px solid var(--border);">
        <div>
            <div style="font-size:0.85rem; color:var(--text-muted); text-transform:uppercase; font-weight:700; letter-spacing:0.04em;">Order Shipment Tracking</div>
            <h1 style="font-size:1.8rem; margin:4px 0 6px;">Order #${order.orderId}</h1>
            <div style="font-size:0.88rem; color:var(--slate-600);">
                Placed on <fmt:formatDate value="${order.orderDate}" pattern="dd MMMM yyyy, hh:mm a"/>
            </div>
        </div>
        <div style="text-align:right;">
            <span class="status-pill status-${order.status}" style="font-size:0.9rem; padding:6px 14px;">
                ● Current Status: ${order.status}
            </span>
            <div style="margin-top:6px; font-size:1.25rem; font-weight:800; color:var(--slate-900);">
                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₹"/>
            </div>
        </div>
    </div>

    <!-- Visual Tracking Stepper -->
    <c:choose>
        <c:when test="${order.status == 'CANCELLED'}">
            <div class="alert error" style="margin:24px 0;">
                ⚠️ <span>This order has been cancelled and inventory was returned.</span>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="stageNum" value="${order.status == 'PENDING' ? 1 : order.status == 'CONFIRMED' ? 2 : order.status == 'SHIPPED' ? 3 : order.status == 'DELIVERED' ? 4 : 0}"/>
            <div class="order-tracker">
                <div class="tracker-step ${stageNum >= 1 ? (stageNum == 1 ? 'current' : 'done') : ''}">
                    <div class="step-circle">${stageNum > 1 ? '✓' : '1'}</div>
                    <div class="step-label">Order Placed</div>
                </div>
                <div class="tracker-step ${stageNum >= 2 ? (stageNum == 2 ? 'current' : 'done') : ''}">
                    <div class="step-circle">${stageNum > 2 ? '✓' : '2'}</div>
                    <div class="step-label">Confirmed</div>
                </div>
                <div class="tracker-step ${stageNum >= 3 ? (stageNum == 3 ? 'current' : 'done') : ''}">
                    <div class="step-circle">${stageNum > 3 ? '✓' : '3'}</div>
                    <div class="step-label">Dispatched / Shipped</div>
                </div>
                <div class="tracker-step ${stageNum >= 4 ? 'done' : ''}">
                    <div class="step-circle">${stageNum >= 4 ? '✓' : '4'}</div>
                    <div class="step-label">Delivered</div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- Shipping Destination Card -->
    <div style="background:var(--slate-50); border:1px solid var(--border); border-radius:var(--radius-md); padding:16px 20px; margin:28px 0; font-size:0.9rem;">
        <strong style="display:block; margin-bottom:4px; color:var(--slate-900);">📍 Delivery Destination:</strong>
        <span style="color:var(--slate-700);">${order.shippingAddress}</span>
    </div>

    <!-- Items in Order -->
    <h3 style="margin-bottom:14px;">Items in this Shipment</h3>
    <div class="table-card" style="margin-bottom:20px;">
        <table>
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Unit Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
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
                        <td><span style="font-weight:700;">${item.quantity}</span></td>
                        <td><strong><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/></strong></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
        <a class="btn outline" href="${pageContext.request.contextPath}/orders">&larr; Back to All Orders</a>
        <a class="btn accent" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
