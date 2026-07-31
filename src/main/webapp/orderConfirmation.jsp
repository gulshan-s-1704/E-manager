<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Order Confirmed - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="text-align:center;">
    <h1 style="color:var(--success);">✅ Order Placed Successfully!</h1>
    <p>Your order <strong>#${orderId}</strong> has been confirmed and payment was processed.</p>
    <a class="btn" href="${pageContext.request.contextPath}/orders?id=${orderId}">Track this order</a>
    <a class="btn accent" href="${pageContext.request.contextPath}/products">Continue Shopping</a>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
