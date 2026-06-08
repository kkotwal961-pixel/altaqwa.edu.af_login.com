<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AL-TAQWA Login</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family: Arial, sans-serif;
}

body{
    background:#f5f5f5;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;
    padding:12px;
}

/* Main Box */
.login-container{
    width:100%;
    max-width:390px;
    background:#fff;
    border:1px solid #ddd;
    border-radius:16px;
    padding:28px 22px;
}

/* Logo */
.logo{
    text-align:center;
    margin-bottom:8px;
}

.logo img{
    width:100%;
    max-width:270px;
}

/* Title */
.title{
    text-align:center;
    font-size:40px;
    font-weight:300;
    color:#333;
    margin-top:8px;
    margin-bottom:28px;
}

/* Labels */
label{
    display:block;
    font-size:16px;
    color:#444;
    margin-bottom:8px;
}

/* Inputs */
.input-box{
    margin-bottom:22px;
}

.input-box input{
    width:100%;
    height:54px;
    border:1px solid #cfcfcf;
    border-radius:8px;
    padding:0 15px;
    font-size:18px;
    outline:none;
    transition:0.3s;
}

.input-box input:focus{
    border:2px solid #9ed2ff;
    box-shadow:0 0 5px rgba(0,123,255,0.3);
}

/* Checkbox */
.remember{
    display:flex;
    align-items:center;
    margin-bottom:25px;
    font-size:16px;
    color:#555;
}

.remember input{
    width:18px;
    height:18px;
    margin-right:8px;
}

/* Button */
.login-btn{
    width:100%;
    height:54px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    color:#000;
    font-size:20px;
    cursor:pointer;
    transition:0.3s;
}

.login-btn:hover{
    background:#0fb6d6;
}

</style>
</head>

<body>

<div class="login-container">

    <!-- LOGO -->
    <div class="logo">
        <img src="Screenshot_2026-06-08-23-00-41-466_com.android.chrome~2.jpg" alt="AL-TAQWA Logo">
    </div>

    <!-- TITLE -->
    <div class="title">
        Sign in
    </div>

    <!-- FORM -->
    <form>

        <div class="input-box">
            <label>Email</label>
            <input type="email" placeholder="Email">
        </div>

        <div class="input-box">
            <label>Password</label>
            <input type="password" placeholder="Password">
        </div>

        <div class="remember">
            <input type="checkbox">
            <span>Remember password</span>
        </div>

        <button class="login-btn" type="submit">
            Login
        </button>

    </form>

</div>

</body>
</html>
