<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
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
        <img src="../assets/images/login-wallpaper.png" alt="Sign Up Wallpaper" style="width:100vw;height:100vh;object-fit:cover;filter:blur(2px);">
    </div>
    <div class="d-flex justify-content-center align-items-center vh-100">
        <div class="glass-card">
            <h3 class="text-center mb-4">Create an Account</h3>
            <form action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="signup">
                <div class="mb-2">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                <div class="mb-2">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="mb-2">
                    <label for="full_name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="full_name" name="full_name" required>
                </div>
                <div class="mb-2">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="mb-2">
                    <label for="role" class="form-label">Role</label>
                    <select class="form-control" id="role" name="role" required>
                        <option value="EMPLOYEE">Employee</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>
                <div class="d-grid mb-2">
                    <button type="submit" class="btn btn-custom btn-block">Sign Up</button>
                </div>
            </form>
            <p class="text-success text-center">
                <%= request.getAttribute("msg") != null ? request.getAttribute("msg") : "" %>
            </p>
            <div class="text-center mt-2">
                <span>Already have an account? <a href="signin.jsp"><strong> Sign In</strong></a></span>
            </div>
        </div>
    </div>

<script>
        document.querySelector("form").addEventListener("submit", function(e) {
        const username = document.getElementById("username").value.trim();
        const password = document.getElementById("password").value.trim();
        const fullName = document.getElementById("full_name").value.trim();
        const email = document.getElementById("email").value.trim();

        const usernameRegex = /^[\w\.-]+@[\w\.-]+\.\w{2,}$/;
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;
        const fullNameRegex = /^[A-Za-z\s]{3,}$/;
        const emailRegex = /^[\w\.-]+@[\w\.-]+\.\w{2,}$/;

        let message = "";

        if (!usernameRegex.test(username)) {
        message += "- Username must be email address.\n";
    }

        if (!passwordRegex.test(password)) {
        message += "- Password must be at least 6 characters and contain at least one letter and one number.\n";
    }

        if (!fullNameRegex.test(fullName)) {
        message += "- Full name must contain only letters and spaces.\n";
    }

        if (!emailRegex.test(email)) {
        message += "- Invalid email address.\n";
    }

        if (message) {
        e.preventDefault();
        alert("Please correct the following:\n\n" + message);
    }
    });
</script>
</body>
</html>
