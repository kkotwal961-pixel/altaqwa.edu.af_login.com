<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AL-TAQWA – Sign In</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      min-height: 100vh;
      background: #f0f0f0;
      display: flex;
      align-items: center;
      justify-content: center;
      font-family: 'Segoe UI', Arial, sans-serif;
      padding: 20px;
    }

    .card {
      background: #ffffff;
      border-radius: 12px;
      box-shadow: 0 2px 16px rgba(0,0,0,0.10);
      padding: 48px 40px 40px;
      width: 100%;
      max-width: 420px;
    }

    /* ── Logo ── */
    .logo-area {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      margin-bottom: 24px;
    }

    .logo-img {
      width: 48px;
      height: 48px;
      object-fit: contain;
      display: none; /* shown when src is set */
    }

    .logo-img.loaded { display: block; }

    /* shield placeholder shown when no logo URL is provided */
    .logo-shield {
      width: 48px;
      height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .logo-shield svg { width: 44px; height: 44px; }

    .logo-text {
      line-height: 1.15;
    }

    .logo-text .name {
      font-size: 26px;
      font-weight: 800;
      color: #c8900a;
      letter-spacing: 1px;
    }

    .logo-text .sub {
      font-size: 11px;
      color: #222;
      letter-spacing: 0.3px;
    }

    /* ── Title ── */
    h1 {
      text-align: center;
      font-size: 22px;
      font-weight: 600;
      color: #111;
      margin-bottom: 28px;
    }

    /* ── Form ── */
    .field { margin-bottom: 18px; }

    label {
      display: block;
      font-size: 14px;
      color: #333;
      margin-bottom: 6px;
    }

    input[type="email"],
    input[type="password"],
    input[type="text"] {
      width: 100%;
      padding: 12px 14px;
      border: 1.5px solid #ccc;
      border-radius: 6px;
      font-size: 15px;
      color: #333;
      outline: none;
      transition: border-color 0.2s;
      background: #fff;
    }

    input[type="email"]:focus,
    input[type="password"]:focus,
    input[type="text"]:focus {
      border-color: #6bbfea;
      box-shadow: 0 0 0 3px rgba(107,191,234,0.18);
    }

    input::placeholder { color: #aaa; }

    /* ── Remember ── */
    .remember {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 24px;
    }

    .remember input[type="checkbox"] {
      width: 16px;
      height: 16px;
      accent-color: #00bcd4;
      cursor: pointer;
    }

    .remember label {
      margin: 0;
      font-size: 14px;
      color: #444;
      cursor: pointer;
    }

    /* ── Button ── */
    .btn-login {
      width: 100%;
      padding: 14px;
      background: #00bcd4;
      color: #fff;
      font-size: 16px;
      font-weight: 600;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      letter-spacing: 0.5px;
      transition: background 0.2s, transform 0.1s;
    }

    .btn-login:hover  { background: #00a5bb; }
    .btn-login:active { transform: scale(0.99); }

    /* ── Logo URL input (helper below card) ── */
    .logo-url-section {
      margin-top: 20px;
      text-align: center;
    }

    .logo-url-section p {
      font-size: 12px;
      color: #888;
      margin-bottom: 6px;
    }

    .logo-url-row {
      display: flex;
      gap: 6px;
      max-width: 420px;
      margin: 0 auto;
    }

    .logo-url-row input {
      flex: 1;
      padding: 8px 10px;
      border: 1px solid #ccc;
      border-radius: 6px;
      font-size: 13px;
      outline: none;
    }

    .logo-url-row button {
      padding: 8px 14px;
      background: #c8900a;
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 13px;
      cursor: pointer;
    }

    .logo-url-row button:hover { background: #a87208; }

    /* ── Responsive ── */
    @media (max-width: 480px) {
      .card { padding: 36px 22px 30px; }
      h1 { font-size: 20px; }
    }
  </style>
</head>
<body>

<div style="display:flex; flex-direction:column; align-items:center; width:100%;">

  <!-- Login Card -->
  <div class="card">

    <!-- Logo -->
    <div class="logo-area">
      <!-- Loaded image (hidden until URL provided) -->
      <img id="logoImg" class="logo-img" src="" alt="AL-TAQWA logo" />

      <!-- SVG Shield placeholder -->
      <div class="logo-shield" id="logoShield">
        <svg viewBox="0 0 44 50" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M22 2L4 10v14c0 10.5 7.5 20.3 18 23 10.5-2.7 18-12.5 18-23V10L22 2z"
                fill="#c8900a" stroke="#a87208" stroke-width="1.5"/>
          <text x="22" y="32" text-anchor="middle" font-size="18" font-weight="bold"
                fill="#fff" font-family="serif">ت</text>
        </svg>
      </div>

      <div class="logo-text">
        <div class="name">AL-TAQWA</div>
        <div class="sub">Institute of Higher Education</div>
      </div>
    </div>

    <h1>Sign in</h1>

    <div class="field">
      <label for="email">Email</label>
      <input type="email" id="email" placeholder="Email" autocomplete="email" />
    </div>

    <div class="field">
      <label for="password">Password</label>
      <input type="password" id="password" placeholder="Password" autocomplete="current-password" />
    </div>

    <div class="remember">
      <input type="checkbox" id="remember" />
      <label for="remember">Remember password</label>
    </div>

    <button class="btn-login" onclick="handleLogin()">Login</button>
  </div>

  <!-- Logo URL helper -->
  <div class="logo-url-section">
    <p>د لوګو د ښودلو لپاره د عکس URL دلته ولیکئ:</p>
    <div class="logo-url-row">
      <input type="text" id="logoUrlInput" placeholder="https://example.com/logo.png" />
      <button onclick="applyLogo()">لګول</button>
    </div>
  </div>

</div>

<script>
  function applyLogo() {
    const url = document.getElementById('logoUrlInput').value.trim();
    if (!url) return;
    const img = document.getElementById('logoImg');
    const shield = document.getElementById('logoShield');
    img.src = url;
    img.onload = () => {
      img.classList.add('loaded');
      shield.style.display = 'none';
    };
    img.onerror = () => {
      img.classList.remove('loaded');
      shield.style.display = 'flex';
      alert('د عکس URL سم نه دی. بل URL هڅه وکړئ.');
    };
  }

  function handleLogin() {
    const email = document.getElementById('email').value.trim();
    const pass  = document.getElementById('password').value;
    if (!email || !pass) {
      alert('مهرباني وکړئ خپل بریښنالیک او پټنوم ولیکئ.');
      return;
    }
    alert('ننوتل…');
  }

  // Allow pressing Enter to trigger login
  document.addEventListener('keydown', e => {
    if (e.key === 'Enter') handleLogin();
  });
</script>

</body>
</html>
