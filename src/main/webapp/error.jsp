<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Error – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="text-align:center; max-width:600px; margin:40px auto; padding:48px 32px;">
    <div style="font-size:3.5rem; margin-bottom:16px;">⚠️</div>
    <h1 style="font-size:1.8rem; margin-bottom:8px;">Oops! Something Went Wrong</h1>
    <p style="color:var(--text-muted); font-size:1rem; margin-bottom:24px;">
        The requested resource was not found or an unexpected error occurred while processing your request.
    </p>

    <div style="display:flex; gap:12px; justify-content:center;">
        <a class="btn large" href="${pageContext.request.contextPath}/">Return to Home</a>
        <a class="btn large outline" href="${pageContext.request.contextPath}/products">Browse Catalog</a>
    </div>

    <% if (exception != null) { %>
        <div style="margin-top:32px; text-align:left; background:#fef2f2; border:1px solid #fecaca; border-radius:var(--radius-md); padding:16px; font-family:monospace; font-size:0.78rem; color:#991b1b; overflow-x:auto;">
            <strong>Details:</strong> <%= exception.getMessage() != null ? exception.getMessage() : exception.toString() %>
        </div>
    <% } %>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
