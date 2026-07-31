<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Login - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="max-width:400px; margin:0 auto;">
    <h1>Login</h1>

    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>
    <c:if test="${param.registered == 'true'}">
        <div class="alert success">Registration successful! Please log in.</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/customer" method="post">
        <input type="hidden" name="action" value="login">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required>
        </div>
        <button class="btn accent" type="submit" style="width:100%;">Login</button>
    </form>
    <p style="margin-top:14px;">Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a></p>
    <p style="color:var(--muted); font-size:0.85rem;">Demo admin: admin@shop.com / admin123</p>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
