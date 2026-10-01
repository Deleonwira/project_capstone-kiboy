<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <div class="filter-bar">
            <form action="<?= base_url('routes') ?>" method="get" class="flex gap-2">
                <div class="search-input">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" class="form-control" placeholder="Cari kota asal / tujuan..." value="<?= esc($search) ?>">
                </div>
                <button type="submit" class="btn btn-outline btn-sm">Cari</button>
            </form>
        </div>
        <a href="<?= base_url('routes/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Tambah Rute
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Kota Asal (Origin)</th>
                        <th>Kota Tujuan (Destination)</th>
                        <th>Jarak (KM)</th>
                        <th>Harga Dasar (Base Price)</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($routes)): ?>
                        <tr><td colspan="6" class="text-center" style="padding: 24px;">Belum ada data rute.</td></tr>
                    <?php else: ?>
                        <?php foreach ($routes as $r): ?>
                            <tr>
                                <td><?= esc($r['id']) ?></td>
                                <td class="td-bold"><i class="fas fa-map-marker-alt" style="color: var(--danger); margin-right: 6px;"></i><?= esc($r['origin']) ?></td>
                                <td class="td-bold"><i class="fas fa-flag-checkered" style="color: var(--success); margin-right: 6px;"></i><?= esc($r['destination']) ?></td>
                                <td><?= esc($r['distanceKm']) ?> km</td>
                                <td class="td-bold">Rp <?= number_format($r['basePrice'], 0, ',', '.') ?></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('routes/edit/' . $r['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('routes/delete/' . $r['id']) ?>', 'rute <?= esc($r['origin']) ?> - <?= esc($r['destination']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
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
