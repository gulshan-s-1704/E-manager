<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="My Orders - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>My Orders</h1>

<c:choose>
    <c:when test="${empty orders}">
        <p>You haven't placed any orders yet.</p>
    </c:when>
    <c:otherwise>
        <table>
            <thead><tr><th>Order #</th><th>Date</th><th>Status</th><th>Total</th><th></th></tr></thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td>#${o.orderId}</td>
                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd MMM yyyy, HH:mm"/></td>
                        <td><span class="status-pill status-${o.status}">${o.status}</span></td>
                        <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₹"/></td>
                        <td><a class="btn small" href="${pageContext.request.contextPath}/orders?id=${o.orderId}">Track</a></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
