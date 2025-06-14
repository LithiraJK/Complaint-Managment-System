<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
</head>
<body>
<h2>Create an Account</h2>

<form action="${pageContext.request.contextPath}/auth" method="post">
    <input type="hidden" name="action" value="signup">

    <label>Username:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <label>Full Name:</label><br>
    <input type="text" name="full_name" required><br><br>

    <label>Email:</label><br>
    <input type="email" name="email" required><br><br>

    <label>Role:</label><br>
    <select name="role" required>
        <option value="EMPLOYEE">Employee</option>
        <option value="ADMIN">Admin</option>
    </select><br><br>

    <button type="submit">Sign Up</button>
</form>

<p style="color: green;">
    <%= request.getAttribute("msg") != null ? request.getAttribute("msg") : "" %>
</p>

<p>Already have an account? <a href="signin.jsp">Login here</a></p>
</body>
</html>
