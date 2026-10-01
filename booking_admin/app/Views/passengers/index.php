<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <div class="filter-bar">
            <form action="<?= base_url('passengers') ?>" method="get" class="flex gap-2">
                <div class="search-input">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" class="form-control" placeholder="Cari nama penumpang..." value="<?= esc($search) ?>">
                </div>
                <button type="submit" class="btn btn-outline btn-sm">Cari</button>
            </form>
        </div>
        <a href="<?= base_url('passengers/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Tambah Penumpang
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nama Lengkap</th>
                        <th>No. Identitas (KTP/NIK)</th>
                        <th>No. Telepon</th>
                        <th>Email</th>
                        <th>Jenis Kelamin</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($passengers)): ?>
                        <tr><td colspan="7" class="text-center" style="padding: 24px;">Belum ada data penumpang.</td></tr>
                    <?php else: ?>
                        <?php foreach ($passengers as $p): ?>
                            <tr>
                                <td><?= esc($p['id']) ?></td>
                                <td class="td-bold"><?= esc($p['name']) ?></td>
                                <td class="td-mono"><?= esc($p['idNumber']) ?></td>
                                <td><?= esc($p['phone']) ?></td>
                                <td><?= esc($p['email']) ?></td>
                                <td><?= esc($p['gender'] === 'L' ? 'Laki-laki' : ($p['gender'] === 'P' ? 'Perempuan' : $p['gender'])) ?></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('passengers/edit/' . $p['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('passengers/delete/' . $p['id']) ?>', 'penumpang <?= esc($p['name']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
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
