<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Shopping Cart – E-Manager"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="section-header">
    <div>
        <h1>Your Shopping Cart</h1>
        <p>Review and modify the items in your order before proceeding to checkout</p>
    </div>
    <a class="btn outline small" href="${pageContext.request.contextPath}/products">&larr; Continue Shopping</a>
</div>

<c:if test="${not empty cartError}">
    <div class="alert error">
        ⚠️ <span>${cartError}</span>
    </div>
</c:if>

<c:choose>
    <c:when test="${empty cartItems}">
        <div class="card" style="text-align:center; padding:72px 24px;">
            <div style="font-size:3.5rem; margin-bottom:16px;">🛒</div>
            <h2>Your cart is currently empty</h2>
            <p style="color:var(--text-muted); max-width:440px; margin:0 auto 24px;">
                Looks like you haven't added anything to your cart yet. Explore our 30+ top products across Electronics, Fashion, and Home!
            </p>
            <a class="btn large accent" href="${pageContext.request.contextPath}/products">Start Shopping Now</a>
        </div>
    </c:when>
    <c:otherwise>
        <div class="cart-layout">
            <!-- Left: Table of Items -->
            <div class="table-card">
                <table>
                    <thead>
                        <tr>
                            <th>Product Details</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="total" value="${0}"/>
                        <c:forEach var="item" items="${cartItems}">
                            <tr>
                                <td>
                                    <div class="cart-item-info">
                                        <div style="width:54px; height:54px; border-radius:var(--radius-md); background:#f1f5f9; display:flex; align-items:center; justify-content:center; font-size:1.4rem;">
                                            📦
                                        </div>
                                        <div>
                                            <a href="${pageContext.request.contextPath}/products?action=view&id=${item.productId}" style="font-weight:700; color:var(--slate-900);">
                                                ${item.productName}
                                            </a>
                                            <div style="font-size:0.75rem; color:var(--text-muted);">Item #${item.productId}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span style="font-weight:600;">
                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₹"/>
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="display:flex; gap:6px; align-items:center;">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <input class="form-control" type="number" name="quantity" value="${item.quantity}" min="1" max="99" style="width:65px; padding:6px; text-align:center;">
                                        <button class="btn outline small" type="submit" title="Update Quantity">Update</button>
                                    </form>
                                </td>
                                <td>
                                    <span style="font-weight:700; color:var(--slate-900);">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="₹"/>
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/cart" method="post" onsubmit="return confirm('Remove this item from your cart?');">
                                        <input type="hidden" name="action" value="remove">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <button class="btn danger small" type="submit">Remove</button>
                                    </form>
                                </td>
                            </tr>
                            <c:set var="total" value="${total + item.subtotal}"/>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Right: Order Summary -->
            <div class="order-summary-card">
                <h3>Order Summary</h3>
                <div class="summary-row">
                    <span>Items Subtotal (${cartItems.size()} items)</span>
                    <span style="font-weight:600;"><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></span>
                </div>
                <div class="summary-row">
                    <span>Estimated Shipping</span>
                    <span style="color:var(--success); font-weight:700;">FREE</span>
                </div>
                <div class="summary-row">
                    <span>Estimated Taxes (Included)</span>
                    <span>₹0.00</span>
                </div>
                
                <div class="summary-row total">
                    <span>Grand Total</span>
                    <span><fmt:formatNumber value="${total}" type="currency" currencySymbol="₹"/></span>
                </div>

                <div style="margin-top:24px; display:flex; flex-direction:column; gap:10px;">
                    <a class="btn large accent" href="${pageContext.request.contextPath}/checkout" style="width:100%;">
                        Proceed to Secure Checkout &rarr;
                    </a>
                    <form action="${pageContext.request.contextPath}/cart" method="post" onsubmit="return confirm('Clear all items from your cart?');">
                        <input type="hidden" name="action" value="clear">
                        <button class="btn outline small" type="submit" style="width:100%;">Clear Shopping Cart</button>
                    </form>
                </div>

                <div style="margin-top:20px; padding:12px; background:var(--slate-50); border-radius:var(--radius-md); font-size:0.78rem; color:var(--slate-600); border:1px solid var(--border);">
                    🔒 <strong>Safe Simulation:</strong> No real payment charges will occur. Orders deduct real stock from inventory.
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
