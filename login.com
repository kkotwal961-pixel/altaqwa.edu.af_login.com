<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - AL-TAQWA</title>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}
body {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #f5f5f5;
}
.login-container {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    padding: 32px 20px 24px 20px;
    width: 100%;
    max-width: 92%;
    margin: 0 auto;
}
@media (min-width: 768px) {
    .login-container {
        max-width: 420px;
        padding: 38px 26px 28px 26px;
    }
}
.logo {
    text-align: center;
    margin-bottom: 14px;
}
.logo img {
    max-width: 80%;
    height: auto;
}
.title {
    text-align: center;
    font-size: 22px;
    font-weight: 500;
    color: #000000;
    margin-bottom: 22px;
}
.input-group {
    margin-bottom: 16px;
}
label {
    display: block;
    font-size: 15px;
    font-weight: 500;
    color: #000000;
    margin-bottom: 6px;
}
input[type="email"],
input[type="password"] {
    width: 100%;
    height: 44px;
    padding: 0 12px;
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    font-size: 15px;
    outline: none;
}
input:focus {
    border: 1px solid #87CEEB;
    box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.2);
}
.remember-me {
    display: flex;
    align-items: center;
    margin-bottom: 22px;
    font-size: 14px;
}
.remember-me input {
    width: 16px;
    height: 16px;
    margin-right: 8px;
}
button {
    width: 100%;
    height: 44px;
    border: none;
    border-radius: 6px;
    background-color: #18c6e7;
    color: #000000;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
}
button:hover {
    background-color: #0fb6d6;
}
</style>
</head>
<body>
<div class="login-container">
    <div class="logo">
        <img src="assets/logo.png" alt="AL-TAQWA Logo">
    </div>
    <div class="title">Sign in</div>
    <div class="input-group">
        <label>Email</label>
        <input type="email" placeholder="Email">
    </div>
    <div class="input-group">
        <label>Password</label>
        <input type="password" placeholder="Password">
    </div>
    <div class="remember-me">
        <input type="checkbox">
        <label>Remember password</label>
    </div>
    <button>Login</button>
</div>
</body>
</html>
