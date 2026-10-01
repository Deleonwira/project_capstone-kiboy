<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<!-- Stats Grid -->
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon purple">
            <i class="fas fa-ticket-alt"></i>
        </div>
        <div class="stat-info">
            <div class="stat-label">Total Booking</div>
            <div class="stat-value"><?= number_format($totalBookings) ?></div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon green">
            <i class="fas fa-wallet"></i>
        </div>
        <div class="stat-info">
            <div class="stat-label">Total Pendapatan</div>
            <div class="stat-value" style="font-size: 20px;">Rp <?= number_format($totalRevenue, 0, ',', '.') ?></div>
            <div class="stat-change up"><?= $paidPayments ?> transaksi sukses</div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon blue">
            <i class="fas fa-route"></i>
        </div>
        <div class="stat-info">
            <div class="stat-label">Rute Aktif</div>
            <div class="stat-value"><?= number_format($totalRoutes) ?></div>
        </div>
    </div>

    <div class="stat-card">
        <div class="stat-icon yellow">
            <i class="fas fa-calendar-alt"></i>
        </div>
        <div class="stat-info">
            <div class="stat-label">Jadwal Perjalanan</div>
            <div class="stat-value"><?= number_format($totalSchedules) ?></div>
        </div>
    </div>
</div>

<!-- Extra Stats -->
<div class="stats-grid" style="grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); margin-bottom: 28px;">
    <div class="stat-card">
        <div class="stat-icon blue"><i class="fas fa-users"></i></div>
        <div class="stat-info">
            <div class="stat-label">Penumpang</div>
            <div class="stat-value"><?= number_format($totalPassengers) ?></div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon purple"><i class="fas fa-user-shield"></i></div>
        <div class="stat-info">
            <div class="stat-label">Pengguna/User</div>
            <div class="stat-value"><?= number_format($totalUsers) ?></div>
        </div>
    </div>
    <div class="stat-card">
        <div class="stat-icon green"><i class="fas fa-credit-card"></i></div>
        <div class="stat-info">
            <div class="stat-label">Total Pembayaran</div>
            <div class="stat-value"><?= number_format($totalPayments) ?></div>
        </div>
    </div>
</div>

<!-- Tables Grid -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(450px, 1fr)); gap: 24px;">
    <!-- Recent Bookings -->
    <div class="card">
        <div class="card-header">
            <h3><i class="fas fa-history" style="color: var(--accent); margin-right: 8px;"></i>Booking Terbaru</h3>
            <a href="<?= base_url('bookings') ?>" class="btn btn-outline btn-sm">Lihat Semua</a>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Kode</th>
                            <th>Penumpang</th>
                            <th>Total</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (empty($recentBookings)): ?>
                            <tr><td colspan="4" class="text-center" style="padding: 24px;">Belum ada data booking.</td></tr>
                        <?php else: ?>
                            <?php foreach ($recentBookings as $b): ?>
                                <tr>
                                    <td class="td-mono td-bold"><?= esc($b['bookingCode'] ?? '-') ?></td>
                                    <td><?= esc($b['passenger']['name'] ?? '-') ?></td>
                                    <td class="td-bold">Rp <?= number_format($b['totalPrice'] ?? 0, 0, ',', '.') ?></td>
                                    <td>
                                        <span class="badge-status badge-<?= strtolower($b['status'] ?? 'pending') ?>">
                                            <?= esc($b['status'] ?? 'pending') ?>
                                        </span>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Recent Payments -->
    <div class="card">
        <div class="card-header">
            <h3><i class="fas fa-money-bill-wave" style="color: var(--success); margin-right: 8px;"></i>Pembayaran Terbaru</h3>
            <a href="<?= base_url('payments') ?>" class="btn btn-outline btn-sm">Lihat Semua</a>
        </div>
        <div class="card-body" style="padding: 0;">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Ref #</th>
                            <th>Metode</th>
                            <th>Jumlah</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if (empty($recentPayments)): ?>
                            <tr><td colspan="4" class="text-center" style="padding: 24px;">Belum ada data pembayaran.</td></tr>
                        <?php else: ?>
                            <?php foreach ($recentPayments as $p): ?>
                                <tr>
                                    <td class="td-mono td-bold"><?= esc($p['referenceNumber'] ?? '-') ?></td>
                                    <td><?= esc($p['paymentMethod'] ?? '-') ?></td>
                                    <td class="td-bold">Rp <?= number_format($p['amount'] ?? 0, 0, ',', '.') ?></td>
                                    <td>
                                        <span class="badge-status badge-<?= strtolower($p['status'] ?? 'pending') ?>">
                                            <?= esc($p['status'] ?? 'pending') ?>
                                        </span>
                                    </td>
                                </tr>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<?= $this->endSection() ?>
