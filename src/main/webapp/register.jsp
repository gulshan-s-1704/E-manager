<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Register Account – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="auth-card" style="max-width:480px;">
    <div class="auth-header">
        <div class="brand-logo-icon" style="margin:0 auto 12px; width:44px; height:44px; font-size:1.3rem;">E</div>
        <h2>Create an Account</h2>
        <p>Join E-Manager to order, track shipments, and access your profile</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert error">
            ⚠️ <span>${error}</span>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/customer" method="post">
        <input type="hidden" name="action" value="register">
        
        <div class="form-group">
            <label for="fullName">Full Name *</label>
            <input class="form-control" type="text" id="fullName" name="fullName" required placeholder="e.g. John Doe">
        </div>

        <div class="form-group">
            <label for="email">Email Address *</label>
            <input class="form-control" type="email" id="email" name="email" required placeholder="john@example.com">
        </div>

        <div class="form-group">
            <label for="password">Create Password *</label>
            <input class="form-control" type="password" id="password" name="password" required minlength="6" placeholder="At least 6 characters">
        </div>

        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input class="form-control" type="tel" id="phone" name="phone" placeholder="+91 98765 43210">
        </div>

        <div class="form-group">
            <label for="address">Shipping Delivery Address</label>
            <textarea class="form-control" id="address" name="address" rows="3" placeholder="Apartment / Flat, Street, City, State, PIN code"></textarea>
        </div>

        <button class="btn large accent" type="submit" style="width:100%; margin-top:10px;">
            Complete Registration &rarr;
        </button>
    </form>

    <div style="text-align:center; margin-top:24px; padding-top:20px; border-top:1px solid var(--border); font-size:0.88rem; color:var(--text-muted);">
        Already registered with us? 
        <a href="${pageContext.request.contextPath}/login.jsp" style="font-weight:700;">Sign in here</a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
