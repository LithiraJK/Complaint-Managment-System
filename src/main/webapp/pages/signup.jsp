<%--
  Created by IntelliJ IDEA.
  User: Lithira Jayanaka
  Date: 6/13/2025
  Time: 1:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
</head>
<body>
<h2>Register New Account</h2>
<form method="post" action="signup">
    <label>Username:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <label>Full Name:</label><br>
    <input type="text" name="fullName" required><br><br>

    <label>Email:</label><br>
    <input type="email" name="email" required><br><br>

    <label>Role:</label><br>
    <select name="role" required>
        <option value="EMPLOYEE">Employee</option>
        <option value="ADMIN">Admin</option>
    </select><br><br>

    <button type="submit">Sign Up</button>
</form>
</body>
</html>
