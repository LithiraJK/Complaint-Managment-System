<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body, html {
            height: 100%;
            margin: 0;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            padding: 1.5rem;
            width: 100%;
            max-width: 400px;
            color: white;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
        }

        .btn-custom {
            background: linear-gradient(30deg, #0b5ed7,#003465);
            border: none;
            color: #f8f9fa ;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

        }

        .btn-custom:hover {
            background: linear-gradient(30deg, #003465,#0b5ed7);
            color: #f8f9fa;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

        }

        a {
            color: #fff;
        }

        a:hover {
            color: #dcdcdc;
        }
    </style>
</head>
<body>
    <div style="position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:-1;overflow:hidden;">
        <img src="${pageContext.request.contextPath}/assets/images/login-wallpaper.png" alt="Login Wallpaper" style="width:100vw;height:100vh;object-fit:cover;filter:blur(2px);">
    </div>
<div class="d-flex justify-content-center align-items-center vh-100">
    <div class="glass-card">
        <h3 class="text-center mb-4">Login</h3>

        <form action="${pageContext.request.contextPath}/auth" method="post">
            <input type="hidden" name="action" value="signin"/>

            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" placeholder="username@gmail.com" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
            </div>

            <div class="mb-3 text-end">
                <a href="#">Forgot Password?</a>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-custom btn-block">Sign In</button>
            </div>

            <p class="text-danger text-center">
                <%= request.getAttribute("error") != null ? request.getAttribute("error") : "" %>
            </p>

            <div class="text-center mt-3">
                <span>Don't have an account ? <a href="signup.jsp"><strong> Sign Up</strong></a></span>
            </div>
        </form>
    </div>
</div>
    <script>
        document.querySelector("form").addEventListener("submit", function(e) {
            const username = document.getElementById("username").value.trim();
            const password = document.getElementById("password").value.trim();

            const emailRegex = /^[\w\.-]+@[\w\.-]+\.\w{2,}$/;
            const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;

            let errorMsg = "";

            if (!emailRegex.test(username)) {
                errorMsg += "- Enter a valid email address.\n";
            }

            if (!passwordRegex.test(password)) {
                errorMsg += "- Password must be at least 6 characters long and include at least one letter and one number.\n";
            }

            if (errorMsg) {
                e.preventDefault();
                alert("Please fix the following:\n\n" + errorMsg);
            }
        });
    </script>
</body>
</html>
