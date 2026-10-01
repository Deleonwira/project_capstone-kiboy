<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <div class="filter-bar">
            <form action="<?= base_url('payments') ?>" method="get" class="flex gap-2">
                <select name="status" class="form-control" style="width: auto;">
                    <option value="">-- Semua Status --</option>
                    <option value="pending" <?= ($filterStatus === 'pending') ? 'selected' : '' ?>>Pending</option>
                    <option value="paid" <?= ($filterStatus === 'paid') ? 'selected' : '' ?>>Paid</option>
                    <option value="failed" <?= ($filterStatus === 'failed') ? 'selected' : '' ?>>Failed</option>
                    <option value="refunded" <?= ($filterStatus === 'refunded') ? 'selected' : '' ?>>Refunded</option>
                </select>

                <button type="submit" class="btn btn-outline btn-sm">Filter</button>
            </form>
        </div>
        <a href="<?= base_url('payments/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Catat Pembayaran
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Ref #</th>
                        <th>Kode Booking</th>
                        <th>Metode Pembayaran</th>
                        <th>Jumlah Pembayaran</th>
                        <th>Waktu Bayar</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($payments)): ?>
                        <tr><td colspan="8" class="text-center" style="padding: 24px;">Belum ada data pembayaran.</td></tr>
                    <?php else: ?>
                        <?php foreach ($payments as $p): ?>
                            <tr>
                                <td><?= esc($p['id']) ?></td>
                                <td class="td-mono td-bold"><?= esc($p['referenceNumber'] ?? '-') ?></td>
                                <td class="td-mono"><?= esc($p['booking']['bookingCode'] ?? '-') ?></td>
                                <td><?= esc($p['paymentMethod'] ?? '-') ?></td>
                                <td class="td-bold" style="color: var(--success);">Rp <?= number_format($p['amount'], 0, ',', '.') ?></td>
                                <td><?= esc($p['paidAt'] ?? '-') ?></td>
                                <td>
                                    <span class="badge-status badge-<?= strtolower($p['status'] ?? 'pending') ?>">
                                        <?= esc($p['status'] ?? 'pending') ?>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('payments/edit/' . $p['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('payments/delete/' . $p['id']) ?>', 'pembayaran ref <?= esc($p['referenceNumber']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
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
