<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login</title>

<style>
*{
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: #f3f3f3;
    padding: 12px; /* د موبایل په حالت کې له سکرین څخه لږ فاصله ساتي */
}

/* ==================== د موبایل لپاره سټایل (Default) ==================== */
/* دا سټایل کټ مټ ستاسو د دوهم عکس غوندې بکس په موبایل کې غټ او پوره ښیي */
.login-container {
    width: 100%; 
    max-width: 100%; 
    background: #fff;
    border-radius: 16px;
    padding: 30px 20px;
    border: 1px solid #e0e0e0;
    box-shadow: 0 4px 14px rgba(0,0,0,0.08);
}

/* ==================== د ډیسکټاپ لپاره سټایل (Media Query) ==================== */
/* کله چې سکرین له 480px څخه غټ شي (یا Desktop Site فعاله شي)، دا سټایل کار پیلوي */
/* دا کټ مټ ستاسو د لومړي عکس غوندې بکس په منځ کې محدود او منظم ساتي */
@media (min-width: 480px) {
    .login-container {
        width: 450px; /* د بکس سور په کمپیوټر کې ثابتیږي */
        padding: 40px 30px;
    }
}

.title {
    text-align: center;
    font-size: 22px;
    font-weight: 700;
    margin-bottom: 26px;
    color: #222;
}

.input-box {
    margin-bottom: 18px;
}

label {
    display: block;
    font-size: 15px;
    margin-bottom: 6px;
    color: #444;
}

input {
    width: 100%;
    height: 50px;
    border-radius: 8px;
    border: 1px solid #ccc;
    padding: 0 14px;
    font-size: 15px;
}

input:focus {
    border: 2px solid #18c6e7;
    outline: none;
}

.remember {
    display: flex;
    align-items: center;
    margin: 14px 0 22px;
    font-size: 14px;
}

.remember input {
    width: 16px;
    height: 16px;
    margin-right: 8px;
}

button {
    width: 100%;
    height: 50px;
    border: none;
    border-radius: 8px;
    background: #18c6e7;
    color: white;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

button:hover {
    background: #0fb6d6;
}
</style>
</head>
<body>

<div class="login-container">
    <div class="title">Sign in</div>

    <div class="input-box">
        <label>Email</label>
        <input type="email" placeholder="Email">
    </div>

    <div class="input-box">
        <label>Password</label>
        <input type="password" placeholder="Password">
    </div>

    <div class="remember">
        <input type="checkbox" id="rememberCheck">
        <label for="rememberCheck" style="margin:0 0 0 5px; font-weight:normal; color:#555;">Remember password</label>
    </div>

    <button>Login</button>
</div>

</body>
</html>
