<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="Manage Products - Admin"/>
<%@ include file="/WEB-INF/jspf/header.jspf" %>

<h1>Product & Inventory Management</h1>

<div class="card">
    <h2>${product != null ? 'Edit Product' : 'Add New Product'}</h2>
    <form action="${pageContext.request.contextPath}/admin/products" method="post">
        <input type="hidden" name="action" value="${product != null ? 'update' : 'add'}">
        <c:if test="${product != null}">
            <input type="hidden" name="productId" value="${product.productId}">
        </c:if>
        <div style="display:flex; gap:14px; flex-wrap:wrap;">
            <div class="form-group" style="flex:1; min-width:150px;">
                <label>Name</label>
                <input type="text" name="name" value="${product.name}" required>
            </div>
            <c:if test="${product == null}">
                <div class="form-group" style="flex:1; min-width:150px;">
                    <label>SKU</label>
                    <input type="text" name="sku" required>
                </div>
            </c:if>
            <div class="form-group" style="flex:1; min-width:120px;">
                <label>Price (₹)</label>
                <input type="number" step="0.01" name="price" value="${product.price}" required>
            </div>
            <div class="form-group" style="flex:1; min-width:150px;">
                <label>Category</label>
                <select name="categoryId" required>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.categoryId}" ${product.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                    </c:forEach>
                </select>
            </div>
            <c:if test="${product == null}">
                <div class="form-group" style="flex:1; min-width:120px;">
                    <label>Initial Stock</label>
                    <input type="number" name="initialStock" value="0" required>
                </div>
            </c:if>
        </div>
        <div class="form-group">
            <label>Description</label>
            <textarea name="description" rows="2">${product.description}</textarea>
        </div>
        <div class="form-group">
            <label>Image URL</label>
            <input type="text" name="imageUrl" value="${product.imageUrl}">
        </div>
        <button class="btn accent" type="submit">${product != null ? 'Update Product' : 'Add Product'}</button>
        <c:if test="${product != null}">
            <a class="btn" href="${pageContext.request.contextPath}/admin/products">Cancel</a>
        </c:if>
    </form>
</div>

<c:if test="${not empty lowStock}">
    <div class="alert error">⚠️ Low stock: <c:forEach var="e" items="${lowStock}" varStatus="s">${e.key} (${e.value})<c:if test="${!s.last}">, </c:if></c:forEach></div>
</c:if>

<div class="card">
    <h2>All Products</h2>
    <table>
        <thead><tr><th>Name</th><th>SKU</th><th>Category</th><th>Price</th><th>Stock</th><th>Actions</th></tr></thead>
        <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td>${p.name}</td>
                    <td>${p.sku}</td>
                    <td>${p.categoryName}</td>
                    <td><fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₹"/></td>
                    <td>${p.stockQuantity}</td>
                    <td style="display:flex; gap:6px; flex-wrap:wrap;">
                        <a class="btn small" href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}">Edit</a>
                        <form action="${pageContext.request.contextPath}/admin/products" method="post" style="display:flex; gap:4px;">
                            <input type="hidden" name="action" value="restock">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <input type="number" name="quantity" value="10" style="width:55px;">
                            <button class="btn small" type="submit">Restock</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/products" method="post" onsubmit="return confirm('Deactivate this product?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <button class="btn small danger" type="submit">Deactivate</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/jspf/footer.jspf" %>
