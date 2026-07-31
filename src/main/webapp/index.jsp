<%@ page contentType="text/html;charset=UTF-8" %>
<c:set var="pageTitle" value="ShopEase - Home" xmlns:c="http://java.sun.com/jsp/jstl/core"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="text-align:center; background:linear-gradient(135deg,#1a73e8,#0d47a1); color:white;">
    <h1>Welcome to ShopEase</h1>
    <p>Your one-stop shop for electronics, clothing, books and more.</p>
    <a class="btn accent" href="${pageContext.request.contextPath}/products">Browse Products</a>
</div>

<h2>Why shop with us?</h2>
<div class="stats-grid">
    <div class="stat-box"><div class="value">🚚</div><div class="label">Fast & tracked delivery</div></div>
    <div class="stat-box"><div class="value">🔒</div><div class="label">Secure payments</div></div>
    <div class="stat-box"><div class="value">📦</div><div class="label">Live inventory tracking</div></div>
    <div class="stat-box"><div class="value">↩️</div><div class="label">Easy order management</div></div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
