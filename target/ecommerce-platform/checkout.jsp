<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Secure Checkout – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="section-header">
    <div>
        <h1>Secure Checkout</h1>
        <p>Complete your shipping details and choose a simulated payment option</p>
    </div>
    <a class="btn outline small" href="${pageContext.request.contextPath}/cart">&larr; Back to Cart</a>
</div>

<c:if test="${not empty checkoutError}">
    <div class="alert error">
        ⚠️ <span>${checkoutError}</span>
    </div>
</c:if>

<div class="cart-layout">
    <!-- Left: Shipping & Payment Form -->
    <div class="card">
        <h2 style="font-size:1.3rem; margin-bottom:16px;">1. Shipping Information</h2>
        
        <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                <div class="form-group" style="margin:0;">
                    <label>Recipient Full Name</label>
                    <input class="form-control" type="text" value="${customer.fullName}" readonly style="background:#f1f5f9;">
                </div>
                <div class="form-group" style="margin:0;">
                    <label>Contact Email</label>
                    <input class="form-control" type="text" value="${customer.email}" readonly style="background:#f1f5f9;">
                </div>
            </div>

            <div class="form-group">
                <label>Contact Phone Number</label>
                <input class="form-control" type="text" value="${customer.phone}" readonly style="background:#f1f5f9;">
            </div>

            <div class="form-group">
                <label for="shippingAddress">Delivery Street Address & Pin Code *</label>
                <textarea class="form-control" id="shippingAddress" name="shippingAddress" rows="3" required placeholder="Enter street, apartment/house number, city, state, pin code">${customer.address}</textarea>
                <small style="color:var(--text-muted); font-size:0.75rem;">Orders will be dispatched to this physical address.</small>
            </div>

            <h2 style="font-size:1.3rem; margin:28px 0 16px;">2. Payment Method (Simulated Gateway)</h2>
            
            <div class="alert info" style="margin-bottom:16px;">
                💳 <span><strong>Demonstration Mode:</strong> Transactions are safely simulated in MySQL. No real debit/credit card charges will occur.</span>
            </div>

            <div class="form-group">
                <label>Select Payment Option *</label>
                <select class="form-control" name="paymentMethod" required style="font-weight:600;">
                    <option value="CARD">💳 Credit / Debit Card (Simulated)</option>
                    <option value="UPI">📱 Instant UPI / QR Code (Simulated)</option>
                    <option value="NET_BANKING">🏦 Net Banking (Simulated)</option>
                    <option value="COD">💵 Cash on Delivery (COD)</option>
                </select>
            </div>

            <div style="margin-top:24px;">
                <button class="btn large accent" type="submit" style="width:100%; font-size:1.05rem;">
                    🔒 Confirm & Place Order Now
                </button>
            </div>
        </form>
    </div>

    <!-- Right: Order Summary Preview -->
    <div class="order-summary-card">
        <h3>Order Items</h3>
        <div style="max-height:300px; overflow-y:auto; margin-bottom:16px; padding-right:6px;">
            <c:set var="total" value="${0}"/>
            <c:forEach var="item" items="${cartItems}">
                <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:12px; font-size:0.88rem; padding-bottom:10px; border-bottom:1px solid var(--border);">
                    <div>
                        <div style="font-weight:700; color:var(--slate-900);">${item.productName}</div>
                        <div style="color:var(--text-muted); font-size:0.75rem;">Qty: ${item.quantity} &times; <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/></div>
                    </div>
                    <div style="font-weight:700;">
                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/>
                    </div>
                </div>
                <c:set var="total" value="${total + item.subtotal}"/>
            </c:forEach>
        </div>

        <div class="summary-row">
            <span>Subtotal</span>
            <span style="font-weight:600;"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></span>
        </div>
        <div class="summary-row">
            <span>Standard Shipping</span>
            <span style="color:var(--success); font-weight:700;">FREE</span>
        </div>
        <div class="summary-row">
            <span>Taxes & Duties</span>
            <span>₹0.00</span>
        </div>

        <div class="summary-row total">
            <span>Total to Pay</span>
            <span><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></span>
        </div>

        <div style="margin-top:20px; font-size:0.8rem; color:var(--slate-500); text-align:center;">
            By placing an order, stock is automatically allocated and deducted in real time.
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
