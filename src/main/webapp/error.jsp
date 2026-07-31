<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error - ShopEase</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <div class="card" style="text-align:center; margin-top:60px;">
        <h1 style="color:var(--danger);">⚠️ Something went wrong</h1>
        <p>We're sorry, an unexpected error occurred while processing your request.</p>
        <a class="btn" href="${pageContext.request.contextPath}/index.jsp">Return Home</a>
    </div>
</div>
</body>
</html>
