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

/* BODY */
body{
    background:#f5f5f5;
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:100vh;
    padding:20px;
}

/* LOGIN BOX */
.login-container{
    width:100%;
    max-width:460px; /* 460 شو */
    background:#fff;
    border:1px solid #ddd;
    border-radius:20px;
    padding:38px 34px;
    box-shadow:0 2px 10px rgba(0,0,0,0.05);
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:15px;
}

.logo img{
    width:100%;
    max-width:340px;
}

/* SIGN IN */
.title{
    text-align:center;
    font-size:28px;
    font-weight:700;
    color:#333;
    margin-top:10px;
    margin-bottom:30px;
}

/* LABEL */
label{
    display:block;
    font-size:19px;
    color:#444;
    margin-bottom:10px;
}

/* INPUT BOX */
.input-box{
    margin-bottom:26px;
}

/* INPUT */
.input-box input{
    width:100%;
    height:62px;
    border:1px solid #cfcfcf;
    border-radius:10px;
    padding:0 18px;
    font-size:19px;
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
    margin-bottom:28px;
    font-size:17px;
    color:#555;
}

.remember input{
    width:22px;
    height:22px;
    margin-right:10px;
}

/* BUTTON */
.login-btn{
    width:100%;
    height:60px;
    border:none;
    border-radius:10px;
    background:#18c6e7;
    color:#000;
    font-size:22px;
    font-weight:bold;
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

        <!-- EMAIL -->
        <div class="input-box">
            <label>Email</label>
            <input type="email" placeholder="Email">
        </div>

        <!-- PASSWORD -->
        <div class="input-box">
            <label>Password</label>
            <input type="password" placeholder="Password">
        </div>

        <!-- REMEMBER -->
        <div class="remember">
            <input type="checkbox">
            <span>Remember password</span>
        </div>

        <!-- BUTTON -->
        <button class="login-btn" type="submit">
            Login
        </button>

    </form>

</div>

</body>
</html>
