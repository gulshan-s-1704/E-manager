<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ecommerce.dao.ProductDAO, com.ecommerce.dao.CategoryDAO, com.ecommerce.dao.InventoryDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    // Safety fallback if accessed directly
    if (request.getAttribute("products") == null) {
        try {
            ProductDAO pDao = new ProductDAO();
            CategoryDAO cDao = new CategoryDAO();
            InventoryDAO iDao = new InventoryDAO();
            request.setAttribute("products", pDao.getAllProducts());
            request.setAttribute("categories", cDao.getAllCategories());
            request.setAttribute("lowStock", iDao.getLowStockProducts());
        } catch (Throwable ignored) {}
    }
%>

<c:set var="pageTitle" value="Product & Inventory Management – Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<div class="admin-header-row">
    <div>
        <div style="font-size:0.82rem; font-weight:700; text-transform:uppercase; color:var(--primary); letter-spacing:0.06em; margin-bottom:4px;">
            Inventory & Catalog Management
        </div>
        <h1 style="margin:0; font-size:2rem;">Products Management</h1>
    </div>
    <div style="display:flex; gap:10px;">
        <a class="btn small outline" href="${pageContext.request.contextPath}/admin/dashboard">📊 Dashboard</a>
        <a class="btn small outline" href="${pageContext.request.contextPath}/admin/orders">📋 Orders</a>
    </div>
</div>

<!-- Admin Sub-Navigation -->
<div class="admin-nav-tabs">
    <a href="${pageContext.request.contextPath}/admin/dashboard">📊 Overview Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products" class="active">📦 Products & Stock (${products != null ? products.size() : 0})</a>
    <a href="${pageContext.request.contextPath}/admin/orders">📋 Orders Management</a>
</div>

<!-- Add or Edit Product Card -->
<div class="card" id="productFormCard" style="${product != null ? 'border-color:var(--primary); box-shadow:var(--shadow-md);' : ''}">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
        <h2 style="font-size:1.35rem; margin:0;">
            ${product != null ? '✏️ Edit Product Information' : '➕ Add New Product to Catalog'}
        </h2>
        <c:if test="${product != null}">
            <span class="status-pill status-CONFIRMED">Editing SKU: ${product.sku}</span>
        </c:if>
    </div>

    <form action="${pageContext.request.contextPath}/admin/products" method="post">
        <input type="hidden" name="action" value="${product != null ? 'update' : 'add'}">
        <c:if test="${product != null}">
            <input type="hidden" name="productId" value="${product.productId}">
        </c:if>

        <div style="display:grid; grid-template-columns:2fr 1fr 1fr; gap:16px; margin-bottom:16px;">
            <div class="form-group" style="margin:0;">
                <label for="name">Product Name *</label>
                <input class="form-control" type="text" id="name" name="name" value="${product.name}" required placeholder="e.g. Wireless Noise-Cancelling Headphones">
            </div>

            <c:choose>
                <c:when test="${product == null}">
                    <div class="form-group" style="margin:0;">
                        <label for="sku">SKU Code * (Unique)</label>
                        <input class="form-control" type="text" id="sku" name="sku" required placeholder="e.g. ELEC-009">
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="form-group" style="margin:0;">
                        <label>SKU (Locked)</label>
                        <input class="form-control" type="text" value="${product.sku}" readonly style="background:#f1f5f9;">
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="form-group" style="margin:0;">
                <label for="price">Price (₹) *</label>
                <input class="form-control" type="number" step="0.01" id="price" name="price" value="${product.price}" required placeholder="2499.00">
            </div>
        </div>

        <div style="display:grid; grid-template-columns:1fr 1fr ${product == null ? '1fr' : ''}; gap:16px; margin-bottom:16px;">
            <div class="form-group" style="margin:0;">
                <label for="categoryId">Category *</label>
                <select class="form-control" id="categoryId" name="categoryId" required>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" ${product != null && product.categoryId == cat.categoryId ? 'selected' : ''}>
                            ${cat.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group" style="margin:0;">
                <label for="imageUrl">Image Asset Path / URL</label>
                <input class="form-control" type="text" id="imageUrl" name="imageUrl" value="${product != null ? product.imageUrl : 'images/products/elec_headphones.jpg'}" placeholder="images/products/name.jpg or https://...">
            </div>

            <c:if test="${product == null}">
                <div class="form-group" style="margin:0;">
                    <label for="initialStock">Initial Inventory Qty *</label>
                    <input class="form-control" type="number" id="initialStock" name="initialStock" value="25" min="0" required>
                </div>
            </c:if>
        </div>

        <div class="form-group">
            <label for="description">Detailed Description</label>
            <textarea class="form-control" id="description" name="description" rows="2" placeholder="Key product features, dimensions, technical specs...">${product.description}</textarea>
        </div>

        <div style="display:flex; gap:10px; align-items:center;">
            <button class="btn accent" type="submit">
                ${product != null ? '💾 Update Product' : '➕ Save & Add Product'}
            </button>
            <c:if test="${product != null}">
                <a class="btn outline" href="${pageContext.request.contextPath}/admin/products">Cancel Editing</a>
            </c:if>
        </div>
    </form>
</div>

<!-- Products Table Card -->
<div class="card">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px; flex-wrap:wrap; gap:12px;">
        <h2 style="font-size:1.35rem; margin:0;">All Active Catalog Products (${products.size()})</h2>
        <div style="font-size:0.85rem; color:var(--text-muted);">
            Real-time stock synced with MySQL <code>inventory</code> table
        </div>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th style="width:70px;">Image</th>
                    <th>Product Title & SKU</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th style="text-align:right;">Actions & Inventory Restock</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td>
                            <c:set var="imgSrc" value="${p.imageUrl}"/>
                            <c:choose>
                                <c:when test="${not empty imgSrc && (imgSrc.startsWith('http://') || imgSrc.startsWith('https://'))}">
                                    <img src="${imgSrc}" alt="${p.name}" style="width:48px; height:48px; object-fit:cover; border-radius:var(--radius-sm); border:1px solid var(--border);">
                                </c:when>
                                <c:when test="${not empty imgSrc}">
                                    <img src="${pageContext.request.contextPath}/${imgSrc}" alt="${p.name}" style="width:48px; height:48px; object-fit:cover; border-radius:var(--radius-sm); border:1px solid var(--border);">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:48px; height:48px; background:#f1f5f9; display:flex; align-items:center; justify-content:center; border-radius:var(--radius-sm); font-size:1.2rem;">📦</div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <strong style="color:var(--slate-900); display:block;">${p.name}</strong>
                            <span style="font-size:0.75rem; color:var(--text-muted); font-family:monospace;">${p.sku} &bull; ID: #${p.productId}</span>
                        </td>
                        <td>
                            <span class="product-category-tag">${p.categoryName}</span>
                        </td>
                        <td>
                            <strong style="color:var(--slate-900);">
                                <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/>
                            </strong>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.stockQuantity == 0}">
                                    <span class="stock-status-tag out">0 Out</span>
                                </c:when>
                                <c:when test="${p.stockQuantity <= 10}">
                                    <span class="stock-status-tag low">${p.stockQuantity} Low</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-status-tag in">${p.stockQuantity} In</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div style="display:flex; gap:8px; justify-content:flex-end; align-items:center;">
                                <a class="btn outline small" href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}#productFormCard">
                                    ✏️ Edit
                                </a>

                                <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:flex; gap:4px; align-items:center; margin:0;">
                                    <input type="hidden" name="action" value="restock">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <input class="form-control" type="number" name="quantity" value="15" min="1" max="999" style="width:58px; padding:4px 6px; font-size:0.82rem; text-align:center;">
                                    <button class="btn small" type="submit" title="Add stock quantity">+Stock</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/admin/products" method="post" onsubmit="return confirm('Deactivate ${p.name}?');" style="margin:0;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button class="btn danger small" type="submit" title="Soft delete">✕</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
