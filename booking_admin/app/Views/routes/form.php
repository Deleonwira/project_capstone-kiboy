<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 600px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('routes') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('routes/store') : base_url('routes/update/' . $route['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="origin">Kota Asal (Origin)</label>
                    <input type="text" id="origin" name="origin" class="form-control" placeholder="Contoh: Jakarta" value="<?= esc($route['origin'] ?? old('origin')) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="destination">Kota Tujuan (Destination)</label>
                    <input type="text" id="destination" name="destination" class="form-control" placeholder="Contoh: Bandung" value="<?= esc($route['destination'] ?? old('destination')) ?>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="distanceKm">Jarak (KM)</label>
                    <input type="number" id="distanceKm" name="distanceKm" class="form-control" placeholder="150" value="<?= esc($route['distanceKm'] ?? old('distanceKm')) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="basePrice">Harga Dasar (Rp)</label>
                    <input type="number" id="basePrice" name="basePrice" class="form-control" placeholder="150000" value="<?= esc($route['basePrice'] ?? old('basePrice')) ?>" required>
                </div>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('routes') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
