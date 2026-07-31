<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Manage Orders - Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Order Tracking Dashboard</h1>

<div class="card">
    <table>
        <thead><tr><th>Order #</th><th>Customer</th><th>Date</th><th>Status</th><th>Total</th><th></th></tr></thead>
        <tbody>
            <c:forEach var="o" items="${orders}">
                <tr>
                    <td>#${o.orderId}</td>
                    <td>${o.customerName}</td>
                    <td><fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, HH:mm"/></td>
                    <td><span class="status-pill status-${o.status}">${o.status}</span></td>
                    <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₹"/></td>
                    <td><a class="btn small" href="${pageContext.request.contextPath}/admin/orders?id=${o.orderId}">View</a></td>
                </tr>
            </c:forEach>
            <c:if test="${empty orders}"><tr><td colspan="6">No orders yet.</td></tr></c:if>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
