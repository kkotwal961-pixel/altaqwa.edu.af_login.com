<!DOCTYPE html>
<html lang="ps">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ال تقوا - لاګ ان</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
        }
        body {
            background: linear-gradient(135deg, #0b3b2f 0%, #1a5d4a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .card {
            background-color: white;
            max-width: 450px;
            width: 100%;
            padding: 40px 35px 45px;
            border-radius: 32px;
            box-shadow: 0 25px 45px rgba(0,0,0,0.2);
            text-align: center;
            transition: all 0.2s;
        }
        .logo-area h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1e4a3b;
            letter-spacing: -0.3px;
        }
        .logo-area p {
            font-size: 14px;
            color: #5a6e65;
            margin-top: 6px;
            margin-bottom: 10px;
        }
        .institute {
            font-size: 15px;
            font-weight: 500;
            color: #2c7a5e;
            border-top: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            display: inline-block;
            padding: 6px 18px;
            margin: 12px 0 24px;
        }
        .input-group {
            text-align: left;
            margin-bottom: 20px;
        }
        .input-group label {
            display: block;
            font-weight: 600;
            font-size: 14px;
            color: #2d3e35;
            margin-bottom: 6px;
        }
        .input-group input {
            width: 100%;
            padding: 14px 16px;
            font-size: 15px;
            border: 1.5px solid #d1d9d4;
            border-radius: 18px;
            outline: none;
            transition: 0.2s;
            background-color: #fefef7;
        }
        .input-group input:focus {
            border-color: #2c7a5e;
            box-shadow: 0 0 0 3px rgba(44,122,94,0.2);
        }
        .checkbox {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 15px 0 25px;
            font-size: 14px;
            color: #3b5c4f;
        }
        button {
            width: 100%;
            background-color: #1f6e55;
            color: white;
            font-size: 17px;
            font-weight: 600;
            padding: 14px;
            border: none;
            border-radius: 40px;
            cursor: pointer;
            transition: 0.2s;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }
        button:hover {
            background-color: #0f5541;
            transform: scale(0.98);
        }
        .error-msg {
            background-color: #fee2e2;
            color: #b91c1c;
            padding: 10px;
            border-radius: 40px;
            font-size: 13px;
            margin-top: 18px;
            font-weight: 500;
        }
        .success-msg {
            background-color: #dff9e6;
            color: #166534;
        }
        hr {
            margin: 25px 0 10px;
            border-color: #e9ecef;
        }
        .demo-note {
            font-size: 12px;
            color: #7d8f86;
            background: #f0f5f2;
            padding: 10px;
            border-radius: 24px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="logo-area">
        <h1>AL-TAQWA</h1>
        <p>Institute of Higher Education</p>
        <div class="institute">Sign in</div>
    </div>

    <form id="loginForm">
        <div class="input-group">
            <label>Email</label>
            <input type="email" id="email" placeholder="your@example.com" required>
        </div>
        <div class="input-group">
            <label>Password</label>
            <input type="password" id="password" placeholder="••••••••" required>
        </div>
        <div class="checkbox">
            <input type="checkbox" id="rememberCheckbox">
            <label for="rememberCheckbox">Remember password</label>
        </div>
        <button type="submit" id="loginBtn">Login</button>
    </form>

    <div id="messageArea"></div>
    <div class="demo-note">
        ⚡ د ازمېښت لپاره: په لومړیو دوو هڅو کې هر څه ولیکئ (غلط پټورډ/ایمیل)<br>
        په <strong>دریمه هڅه</strong> کې بریالی لاګ ان: <strong style="color:#1e4a3b;">demo@altaqwa.edu.af</strong> او پټورډ: <strong style="color:#1e4a3b;">success123</strong>
    </div>
</div>

<script>
    // د هڅو شمېر ساتل (په session کې)
    let attemptCount = parseInt(sessionStorage.getItem('loginAttempts')) || 0;
    
    // بریالی ایمیل او پاسورډ (د ښوونې لپاره)
    const VALID_EMAIL = "demo@altaqwa.edu.af";
    const VALID_PASSWORD = "success123";

    function showMessage(text, isError = true) {
        const msgDiv = document.getElementById('messageArea');
        msgDiv.innerHTML = `<div class="error-msg ${!isError ? 'success-msg' : ''}">${text}</div>`;
        if (!isError) {
            // بریالیتوب – سره زر
            setTimeout(() => {
                // لاګ ان شوی ، د خوشحالۍ پیغام او مخ بیا بارول (اختیاري)
                if (confirm("✅ بریالی لاګ ان! \nتاسو اوس سیسټم ته ننوتلئ. غواړئ صفحه تازه کړئ؟")) {
                    sessionStorage.removeItem('loginAttempts');   // د هڅو شمېر پاکول
                    window.location.reload(); 
                }
            }, 200);
        }
    }

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const emailInput = document.getElementById('email').value.trim();
        const passwordInput = document.getElementById('password').value;
        const rememberChecked = document.getElementById('rememberCheckbox').checked;
        
        // د Remember Password اختیار (یوازې UI لپاره)
        if (rememberChecked) {
            localStorage.setItem('remEmail', emailInput);
        } else {
            localStorage.removeItem('remEmail');
        }
        
        // اوس د هڅو منطق: 
        // که چیرې دریمه هڅه ده (attemptCount === 2، ځکه 0,1,2 درې ځله)
        const isThirdAttempt = (attemptCount === 2);
        
        // د اعتبار تایید: که دریمه هڅه وي او صحیح معلومات وي
        if (isThirdAttempt && emailInput === VALID_EMAIL && passwordInput === VALID_PASSWORD) {
            // بریالی لاګ ان
            showMessage("🎉 بریالیتوب! تاسو په دریمه هڅه کې ننوتلئ.", false);
            sessionStorage.removeItem('loginAttempts');  // پاکول
            return;
        }
        
        // که دریمه هڅه وي خو معلومات ناسم وي => بیا هم ناکامي + بلاک نه کړو مګر هڅه پاتې نشي (د بیا هڅه لپاره ریسیټ)
        if (isThirdAttempt && (emailInput !== VALID_EMAIL || passwordInput !== VALID_PASSWORD)) {
            showMessage("❌ دریمه هڅه هم ناکامه شوه. مهرباني وکړئ صفحه تازه کړئ او بیا هڅه وکړئ.", true);
            sessionStorage.setItem('loginAttempts', 3); // لا نورو هڅو ته اجازه نه ورکوي
            document.getElementById('loginBtn').disabled = true;
            setTimeout(() => {
                sessionStorage.removeItem('loginAttempts');
                window.location.reload();
            }, 2000);
            return;
        }
        
        // که لومړی یا دویمه هڅه وي (attemptCount 0 یا 1) -> تل ناکامه ښکاره کړئ
        if (!isThirdAttempt) {
            // ناسم معلومات یا هر څه – ناکامي
            showMessage(`⚠️ ننوتل ناکام شو! تاسو ${attemptCount+1}/2 ناکامې هڅې وکړې. دریمه هڅه به بريالی شي (که صحیح معلومات وکاروئ).`);
            // د هڅو شمېر زیاتول
            attemptCount++;
            sessionStorage.setItem('loginAttempts', attemptCount);
            
            // که دوه هڅې شوي وي (attemptCount === 2 پدې حالت کې د دې فانکشن وروسته به دریم ځل)
            return;
        }
    });
    
    // د مخ له پیل څخه که چیرې لا دمخه 3 هڅې شوې وي بټن غیرفعال کړئ
    window.addEventListener('DOMContentLoaded', () => {
        if (sessionStorage.getItem('loginAttempts') >= 3) {
            document.getElementById('loginBtn').disabled = true;
            showMessage("ډېرې ناکامې هڅې، مهرباني وکړئ صفحه تازه کړئ.", true);
        }
        
        // د یادولو اختیار: که مخکې LocalStorage کې ایمیل خوندي وي
        const savedEmail = localStorage.getItem('remEmail');
        if (savedEmail) {
            document.getElementById('email').value = savedEmail;
            document.getElementById('rememberCheckbox').checked = true;
        }
    });
</script>
</body>
</html>
