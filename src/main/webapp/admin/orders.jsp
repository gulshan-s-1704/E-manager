<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ecommerce.dao.OrderDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Safety fallback if accessed directly
    if (request.getAttribute("orders") == null) {
        try {
            OrderDAO oDao = new OrderDAO();
            request.setAttribute("orders", oDao.getAllOrders());
        } catch (Throwable ignored) {}
    }
%>

<c:set var="pageTitle" value="Orders Management – Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="admin-header-row">
    <div>
        <div style="font-size:0.82rem; font-weight:700; text-transform:uppercase; color:var(--primary); letter-spacing:0.06em; margin-bottom:4px;">
            Order Processing & Fulfillment
        </div>
        <h1 style="margin:0; font-size:2rem;">Customer Orders Dashboard</h1>
    </div>
    <div style="display:flex; gap:10px;">
        <a class="btn small outline" href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
        <a class="btn small outline" href="${pageContext.request.contextPath}/admin/products">📦 Products</a>
    </div>
</div>

<!-- Admin Sub-Navigation -->
<div class="admin-nav-tabs">
    <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Overview Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products">📦 Products & Stock</a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="active">📋 Orders Management (${orders != null ? orders.size() : 0})</a>
</div>

<div class="card">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
        <h2 style="font-size:1.35rem; margin:0;">All Orders in Database (${orders != null ? orders.size() : 0})</h2>
        <div style="font-size:0.85rem; color:var(--text-muted);">
            Manage status advancement (PENDING &rarr; CONFIRMED &rarr; SHIPPED &rarr; DELIVERED)
        </div>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>Order #</th>
                    <th>Customer Name</th>
                    <th>Placed Date</th>
                    <th>Status</th>
                    <th>Total Amount</th>
                    <th style="text-align:right;">Fulfillment Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>
                            <strong>#${o.orderId}</strong>
                        </td>
                        <td>
                            <strong style="color:var(--slate-900);">${o.customerName}</strong>
                            <div style="font-size:0.75rem; color:var(--text-muted);">Customer ID: #${o.customerId}</div>
                        </td>
                        <td>
                            <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                        </td>
                        <td>
                            <span class="status-pill status-${o.status}">● ${o.status}</span>
                        </td>
                        <td>
                            <strong style="font-size:1.02rem; color:var(--slate-900);">
                                <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₹"/>
                            </strong>
                        </td>
                        <td style="text-align:right;">
                            <a class="btn small" href="${pageContext.request.contextPath}/admin/orders?id=${o.orderId}">
                                🔍 Inspect & Update &rarr;
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="6" style="text-align:center; padding:48px; color:var(--text-muted);">
                            <div style="font-size:2rem; margin-bottom:8px;">📋</div>
                            No customer orders found in the database yet. Place a test order via the storefront to verify.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
