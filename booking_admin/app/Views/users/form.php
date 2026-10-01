<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card" style="max-width: 600px; margin: 0 auto;">
    <div class="card-header">
        <h3><?= esc($title) ?></h3>
        <a href="<?= base_url('users') ?>" class="btn btn-outline btn-sm"><i class="fas fa-arrow-left"></i> Kembali</a>
    </div>
    <div class="card-body">
        <form action="<?= $action === 'create' ? base_url('users/store') : base_url('users/update/' . $user['id']) ?>" method="post">
            <?= csrf_field() ?>
            <div class="form-group">
                <label class="form-label" for="username">Username</label>
                <input type="text" id="username" name="username" class="form-control" value="<?= esc($user['username'] ?? old('username')) ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email</label>
                <input type="email" id="email" name="email" class="form-control" value="<?= esc($user['email'] ?? old('email')) ?>" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password <?= $action === 'edit' ? '<small style="color:var(--text-muted);">(kosongkan jika tidak diubah)</small>' : '' ?></label>
                <input type="password" id="password" name="password" class="form-control" <?= $action === 'create' ? 'required' : '' ?>>
            </div>

            <div class="form-group">
                <label class="form-label" for="role">Role</label>
                <select id="role" name="role" class="form-control" required>
                    <option value="admin" <?= ($user['role'] ?? old('role')) === 'admin' ? 'selected' : '' ?>>Admin</option>
                    <option value="operator" <?= ($user['role'] ?? old('role')) === 'operator' ? 'selected' : '' ?>>Operator</option>
                    <option value="user" <?= ($user['role'] ?? old('role')) === 'user' ? 'selected' : '' ?>>User</option>
                </select>
            </div>

            <div class="flex justify-between items-center mt-4">
                <a href="<?= base_url('users') ?>" class="btn btn-outline">Batal</a>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan Data</button>
            </div>
        </form>
    </div>
</div>
<?= $this->endSection() ?>
