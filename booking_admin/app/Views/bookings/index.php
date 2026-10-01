<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <div class="filter-bar">
            <form action="<?= base_url('bookings') ?>" method="get" class="flex gap-2">
                <select name="status" class="form-control" style="width: auto;">
                    <option value="">-- Semua Status --</option>
                    <option value="pending" <?= ($filterStatus === 'pending') ? 'selected' : '' ?>>Pending</option>
                    <option value="confirmed" <?= ($filterStatus === 'confirmed') ? 'selected' : '' ?>>Confirmed</option>
                    <option value="completed" <?= ($filterStatus === 'completed') ? 'selected' : '' ?>>Completed</option>
                    <option value="cancelled" <?= ($filterStatus === 'cancelled') ? 'selected' : '' ?>>Cancelled</option>
                </select>

                <button type="submit" class="btn btn-outline btn-sm">Filter</button>
            </form>
        </div>
        <a href="<?= base_url('bookings/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Buat Booking
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>Kode Booking</th>
                        <th>Penumpang</th>
                        <th>Rute & Jadwal</th>
                        <th>Jumlah Kursi</th>
                        <th>Total Harga</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($bookings)): ?>
                        <tr><td colspan="7" class="text-center" style="padding: 24px;">Belum ada data booking.</td></tr>
                    <?php else: ?>
                        <?php foreach ($bookings as $b): ?>
                            <tr>
                                <td class="td-mono td-bold"><?= esc($b['bookingCode'] ?? '-') ?></td>
                                <td>
                                    <div class="td-bold"><?= esc($b['passenger']['name'] ?? '-') ?></div>
                                    <small style="color: var(--text-muted);"><?= esc($b['passenger']['phone'] ?? '-') ?></small>
                                </td>
                                <td>
                                    <div><?= esc($b['schedule']['route']['origin'] ?? '-') ?> <i class="fas fa-arrow-right" style="font-size:10px;"></i> <?= esc($b['schedule']['route']['destination'] ?? '-') ?></div>
                                    <small style="color: var(--text-muted);"><?= esc($b['schedule']['vehicleName'] ?? '-') ?> (<?= esc($b['schedule']['departureDate'] ?? '-') ?>)</small>
                                </td>
                                <td><?= esc($b['seatCount']) ?> kursi</td>
                                <td class="td-bold">Rp <?= number_format($b['totalPrice'], 0, ',', '.') ?></td>
                                <td>
                                    <span class="badge-status badge-<?= strtolower($b['status'] ?? 'pending') ?>">
                                        <?= esc($b['status'] ?? 'pending') ?>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('bookings/detail/' . $b['id']) ?>" class="btn-icon" title="Detail"><i class="fas fa-eye"></i></a>
                                        <a href="<?= base_url('bookings/edit/' . $b['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('bookings/delete/' . $b['id']) ?>', 'booking <?= esc($b['bookingCode']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        <?php endforeach; ?>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>
<?= $this->endSection() ?>
