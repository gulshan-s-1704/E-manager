<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Sign In – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="auth-card">
    <div class="auth-header">
        <div class="brand-logo-icon" style="margin:0 auto 12px; width:44px; height:44px; font-size:1.3rem;">E</div>
        <h2>Welcome Back</h2>
        <p>Sign in to manage your orders, cart, and account profile</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert error">
            ⚠️ <span>${error}</span>
        </div>
    </c:if>
    <c:if test="${param.registered == 'true'}">
        <div class="alert success">
            ✓ <span>Registration successful! You may now sign in.</span>
        </div>
    </c:if>
    <c:if test="${param.admin == 'true'}">
        <div class="alert info">
            🔒 <span>Please sign in with administrator credentials to access the admin dashboard.</span>
        </div>
    </c:if>

    <!-- Demo Credentials Helper Pill -->
    <div class="demo-credentials-box">
        <strong>🔑 Quick Evaluation Demo Credentials:</strong>
        <div>Administrator: <code>admin@shop.com</code> &bull; Pass: <code>admin123</code></div>
    </div>

    <form action="${pageContext.request.contextPath}/customer" method="post">
        <input type="hidden" name="action" value="login">
        
        <div class="form-group">
            <label for="email">Email Address</label>
            <input class="form-control" type="email" id="email" name="email" required placeholder="name@example.com" value="${param.admin == 'true' ? 'admin@shop.com' : ''}">
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input class="form-control" type="password" id="password" name="password" required placeholder="••••••••" value="${param.admin == 'true' ? 'admin123' : ''}">
        </div>

        <button class="btn large accent" type="submit" style="width:100%; margin-top:10px;">
            Sign In to Account &rarr;
        </button>
    </form>

    <div style="text-align:center; margin-top:24px; padding-top:20px; border-top:1px solid var(--border); font-size:0.88rem; color:var(--text-muted);">
        Don't have an account yet? 
        <a href="${pageContext.request.contextPath}/register.jsp" style="font-weight:700;">Create an account</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
