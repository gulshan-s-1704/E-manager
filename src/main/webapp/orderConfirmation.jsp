<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Order Confirmed – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="card" style="text-align:center; max-width:640px; margin:40px auto; padding:48px 32px;">
    <div style="width:72px; height:72px; border-radius:var(--radius-full); background:var(--success-bg); color:var(--success); font-size:2.4rem; display:flex; align-items:center; justify-content:center; margin:0 auto 20px;">
        ✓
    </div>
    <h1 style="font-size:1.9rem; margin-bottom:8px;">Order Placed Successfully!</h1>
    <p style="color:var(--text-muted); font-size:1.02rem; margin-bottom:24px;">
        Thank you for your purchase. Your order reference is <strong style="color:var(--slate-900);">#${orderId}</strong>.
    </p>

    <div style="background:var(--slate-50); border:1px solid var(--border); border-radius:var(--radius-md); padding:16px; margin-bottom:28px; text-align:left; font-size:0.88rem; color:var(--slate-700);">
        <div>📦 <strong>Inventory Status:</strong> Quantities deducted automatically from database.</div>
        <div style="margin-top:6px;">💳 <strong>Simulated Payment:</strong> Transaction approved & recorded.</div>
        <div style="margin-top:6px;">🚚 <strong>Dispatch:</strong> Preparing for shipment within 24 hours.</div>
    </div>

    <div style="display:flex; gap:12px; justify-content:center; flex-wrap:wrap;">
        <a class="btn large" href="${pageContext.request.contextPath}/orders?id=${orderId}">
            📍 Track Order #${orderId}
        </a>
        <a class="btn large outline" href="${pageContext.request.contextPath}/products">
            🛍️ Continue Shopping
        </a>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
