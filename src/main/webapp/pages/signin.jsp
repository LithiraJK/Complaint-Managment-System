<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>User Login</h2>

<form action="${pageContext.request.contextPath}/auth" method="post">
    <input type="hidden" name="action" value="signin" />

    <label>Username:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <button type="submit">Login</button>
</form>

<p style="color: red;">
    <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
</p>

<p>Don't have an account? <a href="signup.jsp">Create one</a></p>
</body>
</html>
