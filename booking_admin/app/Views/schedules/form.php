<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 600px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('schedules') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('schedules/store') : base_url('schedules/update/' . $schedule['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="route_id">Pilih Rute Perjalanan</label>
                <select id="route_id" name="route_id" class="form-control" required>
                    <option value="">-- Pilih Rute --</option>
                    <?php foreach ($routes as $r): ?>
                        <option value="<?= $r['id'] ?>" <?= (($schedule['route']['id'] ?? old('route_id')) == $r['id']) ? 'selected' : '' ?>>
                            <?= esc($r['origin']) ?> - <?= esc($r['destination']) ?> (Rp <?= number_format($r['basePrice'], 0, ',', '.') ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label" for="vehicleName">Nama/Tipe Kendaraan</label>
                <input type="text" id="vehicleName" name="vehicleName" class="form-control" placeholder="Contoh: Bus Eksekutif A3" value="<?= esc($schedule['vehicleName'] ?? old('vehicleName')) ?>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="departureDate">Tanggal Keberangkatan</label>
                    <input type="date" id="departureDate" name="departureDate" class="form-control" value="<?= esc($schedule['departureDate'] ?? old('departureDate')) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="departureTime">Waktu Keberangkatan</label>
                    <input type="time" id="departureTime" name="departureTime" class="form-control" value="<?= esc($schedule['departureTime'] ?? old('departureTime')) ?>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="seatCapacity">Kapasitas Kursi</label>
                    <input type="number" id="seatCapacity" name="seatCapacity" class="form-control" placeholder="40" value="<?= esc($schedule['seatCapacity'] ?? old('seatCapacity', 40)) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="availableSeats">Kursi Tersedia</label>
                    <input type="number" id="availableSeats" name="availableSeats" class="form-control" placeholder="40" value="<?= esc($schedule['availableSeats'] ?? old('availableSeats', 40)) ?>" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="status">Status</label>
                <select id="status" name="status" class="form-control" required>
                    <option value="active" <?= (($schedule['status'] ?? old('status')) === 'active') ? 'selected' : '' ?>>Active</option>
                    <option value="completed" <?= (($schedule['status'] ?? old('status')) === 'completed') ? 'selected' : '' ?>>Completed</option>
                    <option value="cancelled" <?= (($schedule['status'] ?? old('status')) === 'cancelled') ? 'selected' : '' ?>>Cancelled</option>
                </select>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('schedules') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
