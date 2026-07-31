<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Register - ShopEase"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="max-width:450px; margin:0 auto;">
    <h1>Create an Account</h1>

    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/customer" method="post">
        <input type="hidden" name="action" value="register">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required minlength="6">
        </div>
        <div class="form-group">
            <label>Phone</label>
            <input type="text" name="phone">
        </div>
        <div class="form-group">
            <label>Address</label>
            <textarea name="address" rows="3"></textarea>
        </div>
        <button class="btn accent" type="submit" style="width:100%;">Register</button>
    </form>
    <p style="margin-top:14px;">Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here</a></p>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
