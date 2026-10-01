<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 650px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('bookings') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('bookings/store') : base_url('bookings/update/' . $booking['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="schedule_id">Pilih Jadwal Perjalanan</label>
                <select id="schedule_id" name="schedule_id" class="form-control" required>
                    <option value="">-- Pilih Jadwal --</option>
                    <?php foreach ($schedules as $s): ?>
                        <option value="<?= $s['id'] ?>" <?= (($booking['schedule']['id'] ?? old('schedule_id')) == $s['id']) ? 'selected' : '' ?>>
                            [<?= esc($s['vehicleName']) ?>] <?= esc($s['route']['origin'] ?? '') ?> -> <?= esc($s['route']['destination'] ?? '') ?> (<?= esc($s['departureDate']) ?> <?= esc($s['departureTime']) ?>) - Rp <?= number_format($s['route']['basePrice'] ?? 0, 0, ',', '.') ?>/kursi
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="passenger_id">Pilih Penumpang</label>
                <select id="passenger_id" name="passenger_id" class="form-control" required>
                    <option value="">-- Pilih Penumpang --</option>
                    <?php foreach ($passengers as $p): ?>
                        <option value="<?= $p['id'] ?>" <?= (($booking['passenger']['id'] ?? old('passenger_id')) == $p['id']) ? 'selected' : '' ?>>
                            <?= esc($p['name']) ?> (<?= esc($p['phone']) ?> - KTP: <?= esc($p['idNumber']) ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="user_id">Petugas / Pembuat Booking (User)</label>
                <select id="user_id" name="user_id" class="form-control" required>
                    <option value="">-- Pilih User --</option>
                    <?php foreach ($users as $u): ?>
                        <option value="<?= $u['id'] ?>" <?= (($booking['user']['id'] ?? old('user_id', session()->get('user_id'))) == $u['id']) ? 'selected' : '' ?>>
                            <?= esc($u['username']) ?> (<?= esc($u['email']) ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="seatCount">Jumlah Kursi</label>
                    <input type="number" id="seatCount" name="seatCount" class="form-control" placeholder="1" value="<?= esc($booking['seatCount'] ?? old('seatCount', 1)) ?>" min="1" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="totalPrice">Total Harga (Rp)</label>
                    <input type="number" id="totalPrice" name="totalPrice" class="form-control" placeholder="150000" value="<?= esc($booking['totalPrice'] ?? old('totalPrice')) ?>" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="status">Status Booking</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="pending" <?= (($booking['status'] ?? old('status')) === 'pending') ? 'selected' : '' ?>>Pending</option>
                    <option value="confirmed" <?= (($booking['status'] ?? old('status')) === 'confirmed') ? 'selected' : '' ?>>Confirmed</option>
                    <option value="completed" <?= (($booking['status'] ?? old('status')) === 'completed') ? 'selected' : '' ?>>Completed</option>
                    <option value="cancelled" <?= (($booking['status'] ?? old('status')) === 'cancelled') ? 'selected' : '' ?>>Cancelled</option>
                </select>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('bookings') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
