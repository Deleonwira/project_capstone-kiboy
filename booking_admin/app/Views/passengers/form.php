<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 650px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('passengers') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('passengers/store') : base_url('passengers/update/' . $passenger['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="name">Nama Lengkap</label>
                <input type="text" id="name" name="name" class="form-control" placeholder="Contoh: Budi Santoso" value="<?= esc($passenger['name'] ?? old('name')) ?>" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="idNumber">No. Identitas (KTP / SIM / Passport)</label>
                    <input type="text" id="idNumber" name="idNumber" class="form-control" placeholder="3271234567890001" value="<?= esc($passenger['idNumber'] ?? old('idNumber')) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="gender">Jenis Kelamin</label>
                    <select id="gender" name="gender" class="form-control" required>
                        <option value="L" <?= (($passenger['gender'] ?? old('gender')) === 'L') ? 'selected' : '' ?>>Laki-laki</option>
                        <option value="P" <?= (($passenger['gender'] ?? old('gender')) === 'P') ? 'selected' : '' ?>>Perempuan</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="phone">No. Telepon / WhatsApp</label>
                    <input type="text" id="phone" name="phone" class="form-control" placeholder="081234567890" value="<?= esc($passenger['phone'] ?? old('phone')) ?>" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="budi@example.com" value="<?= esc($passenger['email'] ?? old('email')) ?>" required>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="address">Alamat Lengkap</label>
                <textarea id="address" name="address" class="form-control" placeholder="Masukkan alamat lengkap penumpang..."><?= esc($passenger['address'] ?? old('address')) ?></textarea>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('passengers') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
