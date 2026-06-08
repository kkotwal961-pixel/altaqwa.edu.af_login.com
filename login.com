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
    padding:15px;
}

/* Main Box */
.login-container{
    width:100%;
    max-width:430px;
    background:#fff;
    border:1px solid #ddd;
    border-radius:18px;
    padding:35px 28px;
}

/* Logo */
.logo{
    text-align:center;
    margin-bottom:10px;
}

.logo img{
    width:100%;
    max-width:320px;
}

/* Sign in text */
.title{
    text-align:center;
    font-size:50px;
    font-weight:300;
    color:#333;
    margin-top:10px;
    margin-bottom:35px;
}

/* Labels */
label{
    display:block;
    font-size:18px;
    color:#444;
    margin-bottom:10px;
}

/* Inputs */
.input-box{
    margin-bottom:28px;
}

.input-box input{
    width:100%;
    height:60px;
    border:1px solid #cfcfcf;
    border-radius:8px;
    padding:0 18px;
    font-size:20px;
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
    margin-bottom:30px;
    font-size:18px;
    color:#555;
}

.remember input{
    width:20px;
    height:20px;
    margin-right:10px;
}

/* Button */
.login-btn{
    width:100%;
    height:58px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    color:#000;
    font-size:22px;
    cursor:pointer;
    transition:0.3s;
}

.login-btn:hover{
    background:#0fb6d6;
}

/* Mobile */
@media(max-width:480px){

    .title{
        font-size:42px;
    }

    .login-container{
        padding:30px 20px;
    }

}

</style>
</head>

<body>

<div class="login-container">

    <!-- LOGO -->
    <div class="logo">
        <img src="https://github.com/kkotwal961-pixel/altaqwa.edu.af-login/blob/main/Screenshot_2026-06-08-23-00-41-466_com.android.chrome~2.jpg" alt="AL-TAQWA Logo">
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
