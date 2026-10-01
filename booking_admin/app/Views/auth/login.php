<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Booking Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            background: #0f1117;
            color: #e8eaed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            background: #1a1d27;
            border: 1px solid #2d3148;
            border-radius: 16px;
            padding: 40px 32px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.5);
        }
        .brand {
            text-align: center;
            margin-bottom: 32px;
        }
        .brand-icon {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: 16px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px; color: #fff;
            margin: 0 auto 16px;
            box-shadow: 0 6px 20px rgba(99,102,241,0.3);
        }
        .brand h1 { font-size: 22px; font-weight: 700; color: #fff; }
        .brand p { font-size: 13px; color: #9ca3af; margin-top: 4px; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 13px; font-weight: 600; color: #9ca3af; margin-bottom: 8px; }
        .input-icon-wrapper { position: relative; }
        .input-icon-wrapper i {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%);
            color: #6b7280; font-size: 15px;
        }
        .form-control {
            width: 100%;
            padding: 12px 16px 12px 42px;
            background: #252839;
            border: 1px solid #2d3148;
            border-radius: 10px;
            color: #fff;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(99,102,241,0.3);
            margin-top: 8px;
        }
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99,102,241,0.4);
        }
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-error { background: rgba(239,68,68,0.12); color: #ef4444; border: 1px solid rgba(239,68,68,0.2); }
        .alert-success { background: rgba(16,185,129,0.12); color: #10b981; border: 1px solid rgba(16,185,129,0.2); }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="brand">
            <div class="brand-icon">
                <i class="fas fa-bus"></i>
            </div>
            <h1>BookingAdmin</h1>
            <p>Sistem Manajemen Travel & Booking</p>
        </div>

        <?php if (session()->getFlashdata('error')): ?>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <?= session()->getFlashdata('error') ?>
            </div>
        <?php endif; ?>

        <?php if (session()->getFlashdata('success')): ?>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <?= session()->getFlashdata('success') ?>
            </div>
        <?php endif; ?>

        <form action="<?= base_url('login') ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <div class="input-icon-wrapper">
                    <i class="fas fa-user"></i>
                    <input type="text" id="username" name="username" class="form-control" placeholder="Masukkan username" value="<?= old('username') ?>" required autofocus>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-icon-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Masukkan password" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                <i class="fas fa-sign-in-alt"></i> Masuk Ke Panel Admin
            </button>
        </form>
    </div>
</body>
</html>
