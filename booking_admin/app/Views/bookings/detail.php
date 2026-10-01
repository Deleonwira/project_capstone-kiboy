<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 800px; margin: 0 auto;">
    <div class="card-header">
        <div>
            <h3>Detail Booking: <span class="td-mono" style="color: var(--accent);"><?= esc($booking['bookingCode']) ?></span></h3>
            <span class="badge-status badge-<?= strtolower($booking['status'] ?? 'pending') ?> mt-2">
                <?= esc($booking['status'] ?? 'pending') ?>
            </span>
        </div>
        <div class="flex gap-2">
            <a href="<?= base_url('bookings/edit/' . $booking['id']) ?>" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
            <a href="<?= base_url('bookings') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
        </div>
    </div>
    <div class="card-body">
        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Kode Booking</div>
                <div class="detail-value td-mono td-bold"><?= esc($booking['bookingCode']) ?></div>
            </div>

            <div class="detail-item">
                <div class="detail-label">Tanggal Booking</div>
                <div class="detail-value"><?= esc($booking['bookingDate'] ?? '-') ?></div>
            </div>

            <div class="detail-item">
                <div class="detail-label">Jumlah Kursi</div>
                <div class="detail-value"><?= esc($booking['seatCount']) ?> Kursi</div>
            </div>

            <div class="detail-item">
                <div class="detail-label">Total Harga</div>
                <div class="detail-value td-bold" style="color: var(--success); font-size: 18px;">
                    Rp <?= number_format($booking['totalPrice'], 0, ',', '.') ?>
                </div>
            </div>
        </div>

        <h4 style="margin: 28px 0 16px; font-size: 15px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
            <i class="fas fa-user" style="color: var(--accent); margin-right: 8px;"></i>Informasi Penumpang
        </h4>
        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Nama Penumpang</div>
                <div class="detail-value td-bold"><?= esc($booking['passenger']['name'] ?? '-') ?></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">No. Identitas / KTP</div>
                <div class="detail-value td-mono"><?= esc($booking['passenger']['idNumber'] ?? '-') ?></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">No. Telepon / WA</div>
                <div class="detail-value"><?= esc($booking['passenger']['phone'] ?? '-') ?></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Email</div>
                <div class="detail-value"><?= esc($booking['passenger']['email'] ?? '-') ?></div>
            </div>
        </div>

        <h4 style="margin: 28px 0 16px; font-size: 15px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
            <i class="fas fa-bus" style="color: var(--info); margin-right: 8px;"></i>Informasi Rute & Jadwal
        </h4>
        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Rute</div>
                <div class="detail-value td-bold">
                    <?= esc($booking['schedule']['route']['origin'] ?? '-') ?> <i class="fas fa-arrow-right" style="font-size:12px;"></i> <?= esc($booking['schedule']['route']['destination'] ?? '-') ?>
                </div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Nama Kendaraan</div>
                <div class="detail-value"><?= esc($booking['schedule']['vehicleName'] ?? '-') ?></div>
            </div>
            <div class="detail-item">
                <div class="detail-label">Tgl & Waktu Keberangkatan</div>
                <div class="detail-value"><?= esc($booking['schedule']['departureDate'] ?? '-') ?> - <?= esc($booking['schedule']['departureTime'] ?? '-') ?></div>
            </div>
        </div>

        <h4 style="margin: 28px 0 16px; font-size: 15px; border-bottom: 1px solid var(--border); padding-bottom: 8px;">
            <i class="fas fa-user-cog" style="color: var(--warning); margin-right: 8px;"></i>Dibuat Oleh
        </h4>
        <div class="detail-grid">
            <div class="detail-item">
                <div class="detail-label">Username Admin/Petugas</div>
                <div class="detail-value"><?= esc($booking['user']['username'] ?? '-') ?> (<?= esc($booking['user']['email'] ?? '-') ?>)</div>
            </div>
        </div>
    </div>
</div>
<?= $this->endSection() ?>
