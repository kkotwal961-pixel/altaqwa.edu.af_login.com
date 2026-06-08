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

/* CENTER PAGE */
body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f5f5f5;
}

/* LOGIN BOX */
.login-container{
    width:378px;   /* ستا غوښتل شوی سایز */
    background:#fff;
    border:1px solid #ddd;
    border-radius:18px;
    padding:28px 24px;
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:12px;
}

.logo img{
    width:240px;
}

/* TITLE */
.title{
    text-align:center;
    font-size:20px;
    font-weight:700;
    margin-bottom:22px;
}

/* INPUTS */
.input-box{
    margin-bottom:16px;
}

label{
    display:block;
    font-size:14px;
    margin-bottom:6px;
    color:#444;
}

input{
    width:100%;
    height:48px;
    border:1px solid #ccc;
    border-radius:8px;
    padding:0 12px;
    font-size:15px;
}

input:focus{
    border:2px solid #18c6e7;
    outline:none;
}

/* CHECKBOX */
.remember{
    display:flex;
    align-items:center;
    font-size:14px;
    margin:12px 0 18px;
}

.remember input{
    width:16px;
    height:16px;
    margin-right:8px;
}

/* BUTTON */
button{
    width:100%;
    height:48px;
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
