<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 600px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('payments') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('payments/store') : base_url('payments/update/' . $payment['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="booking_id">Pilih Booking</label>
                <select id="booking_id" name="booking_id" class="form-control" required>
                    <option value="">-- Pilih Booking --</option>
                    <?php foreach ($bookings as $b): ?>
                        <option value="<?= $b['id'] ?>" <?= (($payment['booking']['id'] ?? old('booking_id')) == $b['id']) ? 'selected' : '' ?>>
                            <?= esc($b['bookingCode']) ?> - <?= esc($b['passenger']['name'] ?? '') ?> (Rp <?= number_format($b['totalPrice'], 0, ',', '.') ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="referenceNumber">Nomor Referensi Transaksi</label>
                <input type="text" id="referenceNumber" name="referenceNumber" class="form-control" placeholder="REF-<?= time() ?>" value="<?= esc($payment['referenceNumber'] ?? old('referenceNumber', 'REF-' . time())) ?>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="paymentMethod">Metode Pembayaran</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-control" required>
                        <option value="Transfer Bank" <?= (($payment['paymentMethod'] ?? old('paymentMethod')) === 'Transfer Bank') ? 'selected' : '' ?>>Transfer Bank</option>
                        <option value="Virtual Account" <?= (($payment['paymentMethod'] ?? old('paymentMethod')) === 'Virtual Account') ? 'selected' : '' ?>>Virtual Account</option>
                        <option value="QRIS" <?= (($payment['paymentMethod'] ?? old('paymentMethod')) === 'QRIS') ? 'selected' : '' ?>>QRIS</option>
                        <option value="Tunai / Cash" <?= (($payment['paymentMethod'] ?? old('paymentMethod')) === 'Tunai / Cash') ? 'selected' : '' ?>>Tunai / Cash</option>
                        <option value="E-Wallet (OPO/Dana/GoPay)" <?= (($payment['paymentMethod'] ?? old('paymentMethod')) === 'E-Wallet (OPO/Dana/GoPay)') ? 'selected' : '' ?>>E-Wallet</option>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label" for="amount">Jumlah Pembayaran (Rp)</label>
                    <input type="number" id="amount" name="amount" class="form-control" placeholder="150000" value="<?= esc($payment['amount'] ?? old('amount')) ?>" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="status">Status Pembayaran</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="pending" <?= (($payment['status'] ?? old('status')) === 'pending') ? 'selected' : '' ?>>Pending</option>
                    <option value="paid" <?= (($payment['status'] ?? old('status')) === 'paid') ? 'selected' : '' ?>>Paid (Lunas)</option>
                    <option value="failed" <?= (($payment['status'] ?? old('status')) === 'failed') ? 'selected' : '' ?>>Failed</option>
                    <option value="refunded" <?= (($payment['status'] ?? old('status')) === 'refunded') ? 'selected' : '' ?>>Refunded</option>
                </select>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('payments') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
