<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Booking Admin Panel - Sistem Manajemen Booking Travel">
    <title><?= esc($title ?? 'Admin') ?> | Booking Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        /* ─── CSS Reset & Variables ─────────────────────────── */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-primary: #0f1117;
            --bg-secondary: #1a1d27;
            --bg-card: #1e2130;
            --bg-hover: #252839;
            --bg-input: #252839;
            --border: #2d3148;
            --border-focus: #6366f1;
            --text-primary: #e8eaed;
            --text-secondary: #9ca3af;
            --text-muted: #6b7280;
            --accent: #6366f1;
            --accent-hover: #818cf8;
            --accent-subtle: rgba(99,102,241,0.12);
            --success: #10b981;
            --success-subtle: rgba(16,185,129,0.12);
            --warning: #f59e0b;
            --warning-subtle: rgba(245,158,11,0.12);
            --danger: #ef4444;
            --danger-subtle: rgba(239,68,68,0.12);
            --info: #3b82f6;
            --info-subtle: rgba(59,130,246,0.12);
            --sidebar-width: 272px;
            --header-height: 68px;
            --radius: 12px;
            --radius-sm: 8px;
            --shadow: 0 4px 24px rgba(0,0,0,0.3);
            --shadow-sm: 0 2px 8px rgba(0,0,0,0.2);
            --transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }

        a { text-decoration: none; color: inherit; }

        /* ─── Layout ───────────────────────────────────────── */
        .app-layout { display: flex; min-height: 100vh; }

        /* ─── Sidebar ──────────────────────────────────────── */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--bg-secondary);
            border-right: 1px solid var(--border);
            position: fixed;
            top: 0; left: 0; bottom: 0;
            z-index: 100;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s ease;
        }

        .sidebar-brand {
            padding: 24px 20px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .sidebar-brand-icon {
            width: 42px; height: 42px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border-radius: var(--radius);
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; color: #fff;
            box-shadow: 0 4px 12px rgba(99,102,241,0.3);
        }

        .sidebar-brand h1 {
            font-size: 18px; font-weight: 700;
            background: linear-gradient(135deg, #e8eaed, #9ca3af);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .sidebar-brand small { font-size: 11px; color: var(--text-muted); font-weight: 400; }

        .sidebar-nav { flex: 1; padding: 16px 12px; overflow-y: auto; }

        .nav-section {
            margin-bottom: 24px;
        }

        .nav-section-title {
            font-size: 11px; font-weight: 600; color: var(--text-muted);
            text-transform: uppercase; letter-spacing: 1.2px;
            padding: 0 12px; margin-bottom: 8px;
        }

        .nav-item {
            display: flex; align-items: center; gap: 12px;
            padding: 11px 14px;
            border-radius: var(--radius-sm);
            color: var(--text-secondary);
            font-size: 14px; font-weight: 500;
            transition: var(--transition);
            margin-bottom: 2px;
            position: relative;
        }

        .nav-item:hover { background: var(--bg-hover); color: var(--text-primary); }

        .nav-item.active {
            background: var(--accent-subtle);
            color: var(--accent-hover);
        }

        .nav-item.active::before {
            content: '';
            position: absolute; left: 0; top: 50%;
            transform: translateY(-50%);
            width: 3px; height: 24px;
            background: var(--accent);
            border-radius: 0 4px 4px 0;
        }

        .nav-item i { width: 20px; text-align: center; font-size: 15px; }

        .nav-item .badge {
            margin-left: auto;
            background: var(--accent-subtle);
            color: var(--accent-hover);
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 11px;
            font-weight: 600;
        }

        .sidebar-footer {
            padding: 16px 12px;
            border-top: 1px solid var(--border);
        }

        .sidebar-user {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 14px;
            border-radius: var(--radius-sm);
            background: var(--bg-hover);
        }

        .sidebar-user-avatar {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #ec4899);
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 14px; color: #fff;
        }

        .sidebar-user-info { flex: 1; }
        .sidebar-user-info .name { font-size: 13px; font-weight: 600; color: var(--text-primary); }
        .sidebar-user-info .role { font-size: 11px; color: var(--text-muted); text-transform: capitalize; }

        /* ─── Main Content ─────────────────────────────────── */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            min-height: 100vh;
        }

        .main-header {
            height: var(--header-height);
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            position: sticky; top: 0; z-index: 50;
            backdrop-filter: blur(12px);
        }

        .header-left { display: flex; align-items: center; gap: 16px; }

        .header-title h2 { font-size: 18px; font-weight: 700; }
        .header-breadcrumb { font-size: 12px; color: var(--text-muted); }
        .header-breadcrumb a { color: var(--accent-hover); }

        .header-right { display: flex; align-items: center; gap: 12px; }

        .btn-menu-toggle {
            display: none;
            background: none; border: none;
            color: var(--text-secondary);
            font-size: 20px;
            cursor: pointer;
            padding: 8px;
        }

        .main-body { padding: 28px 32px; }

        /* ─── Cards ────────────────────────────────────────── */
        .card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
        }

        .card-header {
            padding: 20px 24px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }

        .card-header h3 { font-size: 16px; font-weight: 700; }
        .card-body { padding: 24px; }

        /* ─── Stats Grid ───────────────────────────────────── */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 24px;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            transition: var(--transition);
        }

        .stat-card:hover {
            border-color: var(--accent);
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }

        .stat-icon {
            width: 48px; height: 48px;
            border-radius: var(--radius);
            display: flex; align-items: center; justify-content: center;
            font-size: 20px;
            flex-shrink: 0;
        }

        .stat-icon.blue { background: var(--info-subtle); color: var(--info); }
        .stat-icon.green { background: var(--success-subtle); color: var(--success); }
        .stat-icon.yellow { background: var(--warning-subtle); color: var(--warning); }
        .stat-icon.purple { background: var(--accent-subtle); color: var(--accent); }
        .stat-icon.red { background: var(--danger-subtle); color: var(--danger); }

        .stat-info { flex: 1; }
        .stat-label { font-size: 13px; color: var(--text-muted); font-weight: 500; margin-bottom: 6px; }
        .stat-value { font-size: 28px; font-weight: 800; line-height: 1; }
        .stat-change { font-size: 12px; margin-top: 6px; font-weight: 500; }
        .stat-change.up { color: var(--success); }
        .stat-change.down { color: var(--danger); }

        /* ─── Tables ───────────────────────────────────────── */
        .table-responsive { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        thead th {
            background: var(--bg-primary);
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }

        tbody td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--border);
            color: var(--text-secondary);
            vertical-align: middle;
        }

        tbody tr { transition: var(--transition); }
        tbody tr:hover { background: var(--bg-hover); }
        tbody tr:last-child td { border-bottom: none; }

        .td-bold { color: var(--text-primary); font-weight: 600; }
        .td-mono { font-family: 'JetBrains Mono', monospace; font-size: 13px; }

        /* ─── Status Badges ────────────────────────────────── */
        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
        }

        .badge-status::before {
            content: '';
            width: 6px; height: 6px;
            border-radius: 50%;
        }

        .badge-pending { background: var(--warning-subtle); color: var(--warning); }
        .badge-pending::before { background: var(--warning); }
        .badge-confirmed, .badge-active, .badge-paid { background: var(--success-subtle); color: var(--success); }
        .badge-confirmed::before, .badge-active::before, .badge-paid::before { background: var(--success); }
        .badge-cancelled, .badge-failed { background: var(--danger-subtle); color: var(--danger); }
        .badge-cancelled::before, .badge-failed::before { background: var(--danger); }
        .badge-completed, .badge-refunded { background: var(--info-subtle); color: var(--info); }
        .badge-completed::before, .badge-refunded::before { background: var(--info); }

        .badge-role {
            display: inline-flex;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: capitalize;
        }

        .badge-role.admin { background: var(--accent-subtle); color: var(--accent-hover); }
        .badge-role.operator { background: var(--success-subtle); color: var(--success); }

        /* ─── Buttons ──────────────────────────────────────── */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: var(--radius-sm);
            font-size: 14px;
            font-weight: 600;
            font-family: inherit;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            white-space: nowrap;
        }

        .btn i { font-size: 14px; }

        .btn-primary {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color: #fff;
            box-shadow: 0 4px 12px rgba(99,102,241,0.3);
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(99,102,241,0.4); }

        .btn-success { background: var(--success); color: #fff; }
        .btn-success:hover { background: #059669; }

        .btn-warning { background: var(--warning); color: #000; }
        .btn-warning:hover { background: #d97706; }

        .btn-danger { background: var(--danger); color: #fff; }
        .btn-danger:hover { background: #dc2626; }

        .btn-outline {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--text-secondary);
        }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent-hover); background: var(--accent-subtle); }

        .btn-sm { padding: 6px 12px; font-size: 13px; }
        .btn-sm i { font-size: 12px; }

        .btn-icon {
            width: 34px; height: 34px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
            background: transparent;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-icon:hover { border-color: var(--accent); color: var(--accent-hover); background: var(--accent-subtle); }
        .btn-icon.danger:hover { border-color: var(--danger); color: var(--danger); background: var(--danger-subtle); }

        .action-buttons { display: flex; gap: 6px; }

        /* ─── Forms ────────────────────────────────────────── */
        .form-group { margin-bottom: 20px; }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 11px 16px;
            background: var(--bg-input);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text-primary);
            font-size: 14px;
            font-family: inherit;
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--border-focus);
            box-shadow: 0 0 0 3px rgba(99,102,241,0.15);
        }

        .form-control::placeholder { color: var(--text-muted); }

        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%236b7280' stroke-width='2'%3E%3Cpath d='M6 9l6 6 6-6'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            padding-right: 36px;
        }

        textarea.form-control { resize: vertical; min-height: 100px; }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
        }

        .form-hint { font-size: 12px; color: var(--text-muted); margin-top: 6px; }

        /* ─── Alerts ───────────────────────────────────────── */
        .alert {
            padding: 14px 20px;
            border-radius: var(--radius-sm);
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success { background: var(--success-subtle); color: var(--success); border: 1px solid rgba(16,185,129,0.2); }
        .alert-error { background: var(--danger-subtle); color: var(--danger); border: 1px solid rgba(239,68,68,0.2); }
        .alert-warning { background: var(--warning-subtle); color: var(--warning); border: 1px solid rgba(245,158,11,0.2); }

        .alert .btn-close {
            margin-left: auto;
            background: none; border: none;
            color: inherit; cursor: pointer;
            opacity: 0.7; font-size: 16px;
        }
        .alert .btn-close:hover { opacity: 1; }

        /* ─── Filters & Search ─────────────────────────────── */
        .filter-bar {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .search-input {
            position: relative;
        }

        .search-input i {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 14px;
        }

        .search-input .form-control { padding-left: 40px; }

        /* ─── Empty State ──────────────────────────────────── */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-muted);
        }

        .empty-state i { font-size: 48px; margin-bottom: 16px; opacity: 0.4; }
        .empty-state h4 { font-size: 16px; color: var(--text-secondary); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; }

        /* ─── Detail Grid ──────────────────────────────────── */
        .detail-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .detail-item { padding: 16px 0; border-bottom: 1px solid var(--border); }
        .detail-item:last-child { border-bottom: none; }
        .detail-label { font-size: 12px; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .detail-value { font-size: 15px; color: var(--text-primary); font-weight: 500; }

        /* ─── Responsive ───────────────────────────────────── */
        @media (max-width: 1024px) {
            .sidebar { transform: translateX(-100%); }
            .sidebar.open { transform: translateX(0); box-shadow: var(--shadow); }
            .main-content { margin-left: 0; }
            .btn-menu-toggle { display: block; }
            .stats-grid { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); }
        }

        @media (max-width: 640px) {
            .main-body { padding: 16px; }
            .main-header { padding: 0 16px; }
            .card-header { padding: 16px; }
            .card-body { padding: 16px; }
            .stats-grid { grid-template-columns: 1fr; }
            .form-row { grid-template-columns: 1fr; }
            .filter-bar { flex-direction: column; align-items: stretch; }
        }

        /* ─── Overlay ──────────────────────────────────────── */
        .sidebar-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 99;
        }

        .sidebar-overlay.show { display: block; }

        /* ─── Scrollbar ────────────────────────────────────── */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: var(--border); border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: var(--text-muted); }

        /* ─── Utility ──────────────────────────────────────── */
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .mb-0 { margin-bottom: 0; }
        .mt-2 { margin-top: 8px; }
        .mt-4 { margin-top: 16px; }
        .gap-2 { gap: 8px; }
        .flex { display: flex; }
        .items-center { align-items: center; }
        .justify-between { justify-content: space-between; }
    </style>
</head>
<body>
    <div class="app-layout">
        <!-- Sidebar Overlay (mobile) -->
        <div class="sidebar-overlay" id="sidebarOverlay" onclick="toggleSidebar()"></div>

        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-brand">
                <div class="sidebar-brand-icon">
                    <i class="fas fa-bus"></i>
                </div>
                <div>
                    <h1>BookingAdmin</h1>
                    <small>Travel Management</small>
                </div>
            </div>

            <nav class="sidebar-nav">
                <div class="nav-section">
                    <div class="nav-section-title">Menu Utama</div>
                    <a href="<?= base_url('dashboard') ?>" class="nav-item <?= (uri_string() === 'dashboard') ? 'active' : '' ?>">
                        <i class="fas fa-th-large"></i>
                        Dashboard
                    </a>
                </div>

                <div class="nav-section">
                    <div class="nav-section-title">Manajemen Data</div>
                    <a href="<?= base_url('routes') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'routes')) ? 'active' : '' ?>">
                        <i class="fas fa-route"></i>
                        Rute Perjalanan
                    </a>
                    <a href="<?= base_url('schedules') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'schedules')) ? 'active' : '' ?>">
                        <i class="fas fa-calendar-alt"></i>
                        Jadwal
                    </a>
                    <a href="<?= base_url('passengers') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'passengers')) ? 'active' : '' ?>">
                        <i class="fas fa-users"></i>
                        Penumpang
                    </a>
                </div>

                <div class="nav-section">
                    <div class="nav-section-title">Transaksi</div>
                    <a href="<?= base_url('bookings') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'bookings')) ? 'active' : '' ?>">
                        <i class="fas fa-ticket-alt"></i>
                        Booking
                    </a>
                    <a href="<?= base_url('payments') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'payments')) ? 'active' : '' ?>">
                        <i class="fas fa-credit-card"></i>
                        Pembayaran
                    </a>
                </div>

                <div class="nav-section">
                    <div class="nav-section-title">Pengaturan</div>
                    <a href="<?= base_url('users') ?>" class="nav-item <?= (str_starts_with(uri_string(), 'users')) ? 'active' : '' ?>">
                        <i class="fas fa-user-cog"></i>
                        Kelola User
                    </a>
                </div>
            </nav>

            <div class="sidebar-footer">
                <div class="sidebar-user">
                    <div class="sidebar-user-avatar">
                        <?= strtoupper(substr(session()->get('username') ?? 'A', 0, 1)) ?>
                    </div>
                    <div class="sidebar-user-info">
                        <div class="name"><?= esc(session()->get('username') ?? 'Admin') ?></div>
                        <div class="role"><?= esc(session()->get('role') ?? 'admin') ?></div>
                    </div>
                    <a href="<?= base_url('logout') ?>" title="Logout" style="color: var(--text-muted); margin-left: auto;">
                        <i class="fas fa-sign-out-alt"></i>
                    </a>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <header class="main-header">
                <div class="header-left">
                    <button class="btn-menu-toggle" onclick="toggleSidebar()">
                        <i class="fas fa-bars"></i>
                    </button>
                    <div class="header-title">
                        <h2><?= esc($title ?? 'Dashboard') ?></h2>
                    </div>
                </div>
                <div class="header-right">
                    <span style="font-size: 13px; color: var(--text-muted);">
                        <i class="fas fa-clock" style="margin-right: 4px;"></i>
                        <span id="headerClock"></span>
                    </span>
                </div>
            </header>

            <div class="main-body">
                <!-- Flash Messages -->
                <?php if (session()->getFlashdata('success')): ?>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <?= session()->getFlashdata('success') ?>
                        <button class="btn-close" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
                    </div>
                <?php endif; ?>

                <?php if (session()->getFlashdata('error')): ?>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <?= session()->getFlashdata('error') ?>
                        <button class="btn-close" onclick="this.parentElement.remove()"><i class="fas fa-times"></i></button>
                    </div>
                <?php endif; ?>

                <!-- Page Content -->
                <?= $this->renderSection('content') ?>
            </div>
        </main>
    </div>

    <script>
        // Sidebar toggle
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('open');
            document.getElementById('sidebarOverlay').classList.toggle('show');
        }

        // Live clock
        function updateClock() {
            const now = new Date();
            const options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' };
            document.getElementById('headerClock').textContent = now.toLocaleDateString('id-ID', options);
        }
        updateClock();
        setInterval(updateClock, 30000);

        // Auto-hide alerts after 5s
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(el => {
                el.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
                el.style.opacity = '0';
                el.style.transform = 'translateY(-10px)';
                setTimeout(() => el.remove(), 300);
            });
        }, 5000);

        // Confirm delete
        function confirmDelete(url, itemName) {
            if (confirm('Apakah Anda yakin ingin menghapus ' + itemName + '? Tindakan ini tidak dapat dibatalkan.')) {
                window.location.href = url;
            }
        }

        // Format currency
        function formatRupiah(number) {
            return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(number);
        }
    </script>
</body>
</html>
