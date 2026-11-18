<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My Orders – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="section-header">
    <div>
        <h1>My Order History</h1>
        <p>Review and track past purchases and shipment statuses</p>
    </div>
    <a class="btn outline small" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
</div>

<c:choose>
    <c:when test="${empty orders}">
        <div class="card" style="text-align:center; padding:60px 24px;">
            <div style="font-size:3rem; margin-bottom:12px;">📦</div>
            <h2>No orders placed yet</h2>
            <p style="color:var(--text-muted); max-width:400px; margin:0 auto 20px;">
                When you place orders, they will appear here with live tracking updates.
            </p>
            <a class="btn large accent" href="${pageContext.request.contextPath}/products">Browse Catalog Now</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Order Reference</th>
                        <th>Date & Time</th>
                        <th>Current Status</th>
                        <th>Total Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>
                                <strong>#${o.orderId}</strong>
                            </td>
                            <td>
                                <fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, hh:mm a"/>
                            </td>
                            <td>
                                <span class="status-pill status-${o.status}">${o.status}</span>
                            </td>
                            <td>
                                <strong style="font-size:1.02rem; color:var(--slate-900);">
                                    <fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₹"/>
                                </strong>
                            </td>
                            <td>
                                <a class="btn small" href="${pageContext.request.contextPath}/orders?id=${o.orderId}">
                                    📍 Track Order
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
