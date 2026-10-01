<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <h3>Daftar Pengguna</h3>
        <a href="<?= base_url('users/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Tambah User
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($users)): ?>
                        <tr><td colspan="5" class="text-center" style="padding: 24px;">Belum ada data user.</td></tr>
                    <?php else: ?>
                        <?php foreach ($users as $u): ?>
                            <tr>
                                <td><?= esc($u['id']) ?></td>
                                <td class="td-bold"><?= esc($u['username']) ?></td>
                                <td><?= esc($u['email']) ?></td>
                                <td><span class="badge-role <?= esc($u['role'] ?? 'user') ?>"><?= esc($u['role'] ?? 'user') ?></span></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('users/edit/' . $u['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('users/delete/' . $u['id']) ?>', 'user <?= esc($u['username']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
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
