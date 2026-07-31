<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Admin Dashboard - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Admin Dashboard</h1>
<div class="links" style="margin-bottom:20px;">
    <a class="btn small" href="${pageContext.request.contextPath}/admin/products">Manage Products</a>
    <a class="btn small" href="${pageContext.request.contextPath}/admin/orders">Manage Orders</a>
</div>

<div class="stats-grid">
    <div class="stat-box">
        <div class="value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₹"/></div>
        <div class="label">Total Revenue</div>
    </div>
    <div class="stat-box">
        <div class="value">${totalOrders}</div>
        <div class="label">Total Orders</div>
    </div>
    <div class="stat-box">
        <div class="value">${totalCustomers}</div>
        <div class="label">Registered Customers</div>
    </div>
    <div class="stat-box">
        <div class="value">${lowStock.size()}</div>
        <div class="label">Low Stock Alerts</div>
    </div>
</div>

<div style="display:flex; gap:20px; flex-wrap:wrap;">
    <div class="card" style="flex:1; min-width:300px;">
        <h2>Top Selling Products</h2>
        <table>
            <thead><tr><th>Product</th><th>Units Sold</th></tr></thead>
            <tbody>
                <c:forEach var="entry" items="${topProducts}">
                    <tr><td>${entry.key}</td><td>${entry.value}</td></tr>
                </c:forEach>
                <c:if test="${empty topProducts}"><tr><td colspan="2">No sales yet.</td></tr></c:if>
            </tbody>
        </table>
    </div>

    <div class="card" style="flex:1; min-width:300px;">
        <h2>Order Status Breakdown</h2>
        <table>
            <thead><tr><th>Status</th><th>Count</th></tr></thead>
            <tbody>
                <c:forEach var="entry" items="${statusBreakdown}">
                    <tr><td><span class="status-pill status-${entry.key}">${entry.key}</span></td><td>${entry.value}</td></tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<div class="card">
    <h2>Daily Revenue (Last 14 Days)</h2>
    <table>
        <thead><tr><th>Date</th><th>Revenue</th></tr></thead>
        <tbody>
            <c:forEach var="entry" items="${dailyRevenue}">
                <tr><td>${entry.key}</td><td><fmt:formatNumber value="${entry.value}" type="currency" currencySymbol="₹"/></td></tr>
            </c:forEach>
            <c:if test="${empty dailyRevenue}"><tr><td colspan="2">No revenue recorded in this period.</td></tr></c:if>
        </tbody>
    </table>
</div>

<c:if test="${not empty lowStock}">
    <div class="card">
        <h2>⚠️ Low Stock Alerts</h2>
        <table>
            <thead><tr><th>Product</th><th>Remaining Qty</th></tr></thead>
            <tbody>
                <c:forEach var="entry" items="${lowStock}">
                    <tr><td>${entry.key}</td><td>${entry.value}</td></tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</c:if>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
