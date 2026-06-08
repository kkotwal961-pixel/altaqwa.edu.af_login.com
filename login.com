<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family: Arial, sans-serif;
}

/* FULL CENTER */
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f3f3f3;
}

/* BIG LOGIN BOX (HEX STYLE) */
.login-container{
    width:410px; /* لږ غټ شو */
    background:#fff;
    border-radius:16px;
    padding:34px 30px;
    border:1px solid #e0e0e0;
    box-shadow:0 3px 12px rgba(0,0,0,0.08);
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:12px;
}

.logo img{
    width:260px;
}

/* TITLE */
.title{
    text-align:center;
    font-size:22px;
    font-weight:700;
    margin-bottom:25px;
    color:#222;
}

/* INPUT */
.input-box{
    margin-bottom:18px;
}

label{
    display:block;
    font-size:15px;
    margin-bottom:6px;
    color:#444;
}

input{
    width:100%;
    height:52px;
    border-radius:8px;
    border:1px solid #ccc;
    padding:0 14px;
    font-size:15px;
}

input:focus{
    border:2px solid #18c6e7;
    outline:none;
}

/* REMEMBER */
.remember{
    display:flex;
    align-items:center;
    margin:12px 0 20px;
    font-size:14px;
}

.remember input{
    width:16px;
    height:16px;
    margin-right:8px;
}

/* BUTTON */
button{
    width:100%;
    height:52px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    font-size:16px;
    font-weight:bold;
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
