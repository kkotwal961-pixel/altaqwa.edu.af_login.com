<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>AL-TAQWA Login</title>

  <style>
    *{
      margin:0;
      padding:0;
      box-sizing:border-box;
      font-family: Arial, sans-serif;
    }

    body{
      background:#f5f5f5;
      display:flex;
      justify-content:center;
      align-items:center;
      min-height:100vh;
      padding:20px;
    }

    .login-box{
      width:100%;
      max-width:420px;
      background:white;
      border:1px solid #ddd;
      border-radius:18px;
      padding:40px 30px;
      box-shadow:0 2px 10px rgba(0,0,0,0.05);
    }

    .logo{
      text-align:center;
      margin-bottom:10px;
    }

    .logo img{
      width:220px;
      max-width:100%;
    }

    h2{
      text-align:center;
      font-size:45px;
      font-weight:300;
      margin-bottom:35px;
      color:#333;
    }

    .input-group{
      margin-bottom:25px;
    }

    .input-group label{
      display:block;
      margin-bottom:10px;
      font-size:18px;
      color:#444;
    }

    .input-group input{
      width:100%;
      height:58px;
      border:1px solid #ccc;
      border-radius:8px;
      padding:0 15px;
      font-size:18px;
      outline:none;
      transition:0.3s;
    }

    .input-group input:focus{
      border:2px solid #90caf9;
      box-shadow:0 0 5px rgba(100,181,246,0.5);
    }

    .remember{
      display:flex;
      align-items:center;
      margin-bottom:30px;
      color:#555;
      font-size:18px;
    }

    .remember input{
      width:20px;
      height:20px;
      margin-right:10px;
    }

    .login-btn{
      width:100%;
      height:58px;
      border:none;
      border-radius:8px;
      background:#16c6e8;
      color:white;
      font-size:22px;
      cursor:pointer;
      transition:0.3s;
    }

    .login-btn:hover{
      background:#08b6d8;
    }

    @media(max-width:480px){
      h2{
        font-size:38px;
      }

      .login-box{
        padding:30px 20px;
      }
    }

  </style>
</head>
<body>

  <div class="login-box">

    <div class="logo">
      <!-- خپل لوګو دلته واچوه -->
      <img src="logo.png" alt="AL-TAQWA Logo">
    </div>

    <h2>Sign in</h2>

    <form>

      <div class="input-group">
        <label>Email</label>
        <input type="email" placeholder="Email">
      </div>

      <div class="input-group">
        <label>Password</label>
        <input type="password" placeholder="Password">
      </div>

      <div class="remember">
        <input type="checkbox">
        <span>Remember password</span>
      </div>

      <button class="login-btn" type="submit">
        Login
      </button>

    </form>

  </div>

</body>
</html>
