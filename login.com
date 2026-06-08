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

/* FULL CENTER PAGE */
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f3f3f3;
}

/* LOGIN CARD */
.login-container{
    width:378px;
    background:#fff;
    border-radius:14px;
    border:1px solid #e0e0e0;
    padding:30px 26px;
    box-shadow:0 2px 8px rgba(0,0,0,0.06);
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:10px;
}

.logo img{
    width:230px;
}

/* TITLE (Sign in) */
.title{
    text-align:center;
    font-size:18px;
    font-weight:700;
    color:#222;
    margin-bottom:22px;
}

/* INPUT GROUP */
.input-box{
    margin-bottom:14px;
}

label{
    display:block;
    font-size:13px;
    color:#555;
    margin-bottom:6px;
}

input{
    width:100%;
    height:44px;
    border:1px solid #cfcfcf;
    border-radius:7px;
    padding:0 12px;
    font-size:14px;
    outline:none;
}

input:focus{
    border:2px solid #18c6e7;
}

/* REMEMBER */
.remember{
    display:flex;
    align-items:center;
    font-size:13px;
    margin:10px 0 18px;
    color:#444;
}

.remember input{
    width:15px;
    height:15px;
    margin-right:8px;
}

/* BUTTON */
button{
    width:100%;
    height:44px;
    border:none;
    border-radius:7px;
    background:#18c6e7;
    color:#000;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
}

button:hover{
    background:#0fb6d6;
}

</style>
</head>

<body>

<div class="login-container">

    <div class="logo">
        <img src="Screenshot_2026-06-08-23-00-41-466_com.android.chrome~2.jpg">
    </div>

    <div class="title">Sign in</div>

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

        <button>Login</button>

    </form>

</div>

</body>
</html>
