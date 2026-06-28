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
    
    /* کارت به په دقیق ډول منځ کې وي */
    margin: 0 auto;
}

/* ============================================= */
/* === موبایل سایز (کمی کوچنی شو) === */
/* ============================================= */
@media (max-width: 767px) {
    .login-container {
        /* 416 څخه 380 ته راکم شو (کوچنی شو) */
        max-width: 380px; 
        margin: 20px auto;
    }
}

/* ============================================= */
/* === ډیسټاپ سایز (بې بارډره او کوچنی شو) === */
/* ============================================= */
@media (min-width: 768px) {
    body {
        background-color: #fafafa;
    }

    .login-container {
        /* 436 څخه 400 ته راکم شو (کوچنی شو) */
        max-width: 400px; 
        padding: 50px 30px 40px 30px;
        /* بارډر په بشپړه توګه لرې شو */
        border: none; 
    }

    .logo img {
        max-width: 55%;
    }
}

/* ============================================= */
/* === دننی توکي (خطونه تور شول) === */
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
    color: #000000; /* تور رنګ */
    margin-bottom: 28px;
}

.input-group {
    margin-bottom: 18px;
}

label {
    display: block;
    font-size: 15px;
    font-weight: 500;
    color: #000000; /* تور رنګ */
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
    color: #000000; /* تور رنګ */
    outline: none;
    transition: border-color 0.2s;
}

input[type="email"]:focus,
input[type="password"]:focus {
    border: 1px solid #87CEEB; 
    box-shadow: 0 0 0 2px rgba(135, 206, 235, 0.2);
}

input::placeholder {
    color: #999999; /* تور نه، یو څه خړ دی ترڅو توپیر وي */
}

.remember-me {
    display: flex;
    align-items: center;
    margin-bottom: 25px;
    font-size: 14px;
    color: #000000; /* تور رنګ */
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
    color: #000000; /* تڼۍ تور رنګ */
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: background 0.2
