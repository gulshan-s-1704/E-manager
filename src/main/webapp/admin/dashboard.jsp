<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ecommerce.dao.AnalyticsDAO, com.ecommerce.dao.InventoryDAO, com.ecommerce.dao.ProductDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Safety fallback if accessed directly
    if (request.getAttribute("totalRevenue") == null) {
        try {
            AnalyticsDAO analyticsDAO = new AnalyticsDAO();
            InventoryDAO inventoryDAO = new InventoryDAO();
            ProductDAO productDAO = new ProductDAO();
            request.setAttribute("totalRevenue", analyticsDAO.getTotalRevenue());
            request.setAttribute("totalOrders", analyticsDAO.getTotalOrderCount());
            request.setAttribute("totalCustomers", analyticsDAO.getTotalCustomerCount());
            request.setAttribute("topProducts", analyticsDAO.getTopSellingProducts(5));
            request.setAttribute("dailyRevenue", analyticsDAO.getDailyRevenue(14));
            request.setAttribute("statusBreakdown", analyticsDAO.getOrderStatusBreakdown());
            request.setAttribute("lowStock", inventoryDAO.getLowStockProducts());
            request.setAttribute("catalogCount", productDAO.getAllProducts().size());
        } catch (Exception ignored) {}
    }
%>

<c:set var="pageTitle" value="Administrator Dashboard – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="admin-header-row">
    <div>
        <div style="font-size:0.82rem; font-weight:700; text-transform:uppercase; color:var(--primary); letter-spacing:0.06em; margin-bottom:4px;">
            Administrator Console
        </div>
        <h1 style="margin:0; font-size:2rem;">Platform Overview & Analytics</h1>
    </div>
    <div style="display:flex; gap:10px;">
        <a class="btn small" href="${pageContext.request.contextPath}/admin/products">📦 Manage Products</a>
        <a class="btn small outline" href="${pageContext.request.contextPath}/admin/orders">📋 Manage Orders</a>
        <a class="btn small outline" href="${pageContext.request.contextPath}/products" target="_blank">↗ Live Store</a>
    </div>
</div>

<!-- Admin Navigation Sub-Tabs -->
<div class="admin-nav-tabs">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">📊 Overview Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products">📦 Products & Stock (${catalogCount != null ? catalogCount : 32})</a>
    <a href="${pageContext.request.contextPath}/admin/orders">📋 Orders Management (${totalOrders != null ? totalOrders : 0})</a>
</div>

<!-- KPI Summary Cards -->
<div class="kpi-grid">
    <div class="kpi-card">
        <div>
            <div class="kpi-label">Gross Revenue</div>
            <div class="kpi-value">
                <fmt:formatNumber value="${totalRevenue != null ? totalRevenue : 0}" type="currency" currencySymbol="₹"/>
            </div>
            <div style="font-size:0.75rem; color:var(--success); margin-top:4px; font-weight:600;">
                ● Real-time database metrics
            </div>
        </div>
        <div class="kpi-icon">💰</div>
    </div>

    <div class="kpi-card">
        <div>
            <div class="kpi-label">Completed Orders</div>
            <div class="kpi-value">${totalOrders != null ? totalOrders : 0}</div>
            <div style="font-size:0.75rem; color:var(--info); margin-top:4px; font-weight:600;">
                ● Transaction-safe orders
            </div>
        </div>
        <div class="kpi-icon">📋</div>
    </div>

    <div class="kpi-card">
        <div>
            <div class="kpi-label">Registered Customers</div>
            <div class="kpi-value">${totalCustomers != null ? totalCustomers : 0}</div>
            <div style="font-size:0.75rem; color:var(--primary); margin-top:4px; font-weight:600;">
                ● Active customer accounts
            </div>
        </div>
        <div class="kpi-icon">👥</div>
    </div>

    <div class="kpi-card">
        <div>
            <div class="kpi-label">Low Stock Warnings</div>
            <div class="kpi-value" style="color:${not empty lowStock && lowStock.size() > 0 ? 'var(--danger)' : 'var(--success)'};">
                ${lowStock != null ? lowStock.size() : 0}
            </div>
            <div style="font-size:0.75rem; color:var(--slate-500); margin-top:4px; font-weight:600;">
                ● Items below reorder level
            </div>
        </div>
        <div class="kpi-icon">⚠️</div>
    </div>
</div>

<!-- Top Selling Products & Order Breakdown Grid -->
<div style="display:grid; grid-template-columns:1fr 1fr; gap:24px; margin-bottom:28px;">
    <!-- Top Sellers -->
    <div class="card" style="margin:0;">
        <h3 style="margin-bottom:16px;">🔥 Top Selling Products</h3>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Product Title</th>
                        <th style="text-align:right;">Units Sold</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${topProducts}">
                        <tr>
                            <td><strong>${entry.key}</strong></td>
                            <td style="text-align:right; font-weight:700; color:var(--primary);">${entry.value}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topProducts}">
                        <tr>
                            <td colspan="2" style="text-align:center; color:var(--text-muted); padding:24px;">
                                No order transactions recorded yet. Place an order to see live analytics.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Order Status Breakdown -->
    <div class="card" style="margin:0;">
        <h3 style="margin-bottom:16px;">📊 Order Status Breakdown</h3>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Fulfillment Stage</th>
                        <th style="text-align:right;">Order Count</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${statusBreakdown}">
                        <tr>
                            <td>
                                <span class="status-pill status-${entry.key}">${entry.key}</span>
                            </td>
                            <td style="text-align:right; font-weight:700;">${entry.value}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty statusBreakdown}">
                        <tr>
                            <td colspan="2" style="text-align:center; color:var(--text-muted); padding:24px;">
                                No orders currently in the system.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Low Stock Alerts Section -->
<c:if test="${not empty lowStock}">
    <div class="card" style="border-color:#fecaca;">
        <h3 style="color:#b91c1c; margin-bottom:14px;">⚠️ Low Stock Inventory Alerts</h3>
        <p style="font-size:0.88rem; color:var(--slate-600); margin-bottom:16px;">
            The following catalog items are running low and need restocking to prevent fulfillment delays:
        </p>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Remaining Stock</th>
                        <th>Recommendation</th>
                        <th>Quick Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="entry" items="${lowStock}">
                        <tr>
                            <td><strong>${entry.key}</strong></td>
                            <td>
                                <span class="stock-status-tag low">Only ${entry.value} left</span>
                            </td>
                            <td style="font-size:0.85rem; color:var(--slate-600);">Restock recommended (+20 units)</td>
                            <td>
                                <a class="btn small" href="${pageContext.request.contextPath}/admin/products">
                                    Restock in Products Panel &rarr;
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
