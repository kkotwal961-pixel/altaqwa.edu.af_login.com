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
    padding:10px;
}

/* LOGIN BOX */
.login-container{
    width:100%;
    max-width:360px;
    background:#fff;
    border:1px solid #ddd;
    border-radius:16px;
    padding:22px 18px;
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:8px;
}

.logo img{
    width:100%;
    max-width:250px;
}

/* SIGN IN */
.title{
    text-align:center;
    font-size:24px;
    font-weight:bold;
    color:#333;
    margin-top:5px;
    margin-bottom:22px;
}

/* LABEL */
label{
    display:block;
    font-size:15px;
    color:#444;
    margin-bottom:7px;
}

/* INPUT */
.input-box{
    margin-bottom:18px;
}

.input-box input{
    width:100%;
    height:50px;
    border:1px solid #cfcfcf;
    border-radius:7px;
    padding:0 14px;
    font-size:17px;
    outline:none;
    transition:0.3s;
}

.input-box input:focus{
    border:2px solid #9ed2ff;
    box-shadow:0 0 5px rgba(0,123,255,0.3);
}

/* REMEMBER */
.remember{
    display:flex;
    align-items:center;
    margin-bottom:22px;
    font-size:15px;
    color:#555;
}

.remember input{
    width:18px;
    height:18px;
    margin-right:8px;
}

/* BUTTON */
.login-btn{
    width:100%;
    height:50px;
    border:none;
    border-radius:7px;
    background:#18c6e7;
    color:#000;
    font-size:19px;
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
