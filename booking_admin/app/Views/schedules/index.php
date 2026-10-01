<?= $this->extend('layouts/main') ?>

<?= $this->section('content') ?>
<div class="card">
    <div class="card-header">
        <div class="filter-bar">
            <form action="<?= base_url('schedules') ?>" method="get" class="flex gap-2">
                <select name="routeId" class="form-control" style="width: auto;">
                    <option value="">-- Semua Rute --</option>
                    <?php foreach ($routes as $r): ?>
                        <option value="<?= $r['id'] ?>" <?= ($filterRouteId == $r['id']) ? 'selected' : '' ?>>
                            <?= esc($r['origin']) ?> - <?= esc($r['destination']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>

                <select name="status" class="form-control" style="width: auto;">
                    <option value="">-- Semua Status --</option>
                    <option value="active" <?= ($filterStatus === 'active') ? 'selected' : '' ?>>Active</option>
                    <option value="completed" <?= ($filterStatus === 'completed') ? 'selected' : '' ?>>Completed</option>
                    <option value="cancelled" <?= ($filterStatus === 'cancelled') ? 'selected' : '' ?>>Cancelled</option>
                </select>

                <button type="submit" class="btn btn-outline btn-sm">Filter</button>
            </form>
        </div>
        <a href="<?= base_url('schedules/create') ?>" class="btn btn-primary btn-sm">
            <i class="fas fa-plus"></i> Tambah Jadwal
        </a>
    </div>
    <div class="card-body" style="padding: 0;">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Rute</th>
                        <th>Kendaraan</th>
                        <th>Tgl & Waktu Keberangkatan</th>
                        <th>Kapasitas Kursi</th>
                        <th>Kursi Tersedia</th>
                        <th>Status</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php if (empty($schedules)): ?>
                        <tr><td colspan="8" class="text-center" style="padding: 24px;">Belum ada data jadwal.</td></tr>
                    <?php else: ?>
                        <?php foreach ($schedules as $s): ?>
                            <tr>
                                <td><?= esc($s['id']) ?></td>
                                <td class="td-bold">
                                    <?= esc($s['route']['origin'] ?? '-') ?> <i class="fas fa-arrow-right" style="font-size:11px; color:var(--text-muted);"></i> <?= esc($s['route']['destination'] ?? '-') ?>
                                </td>
                                <td><i class="fas fa-bus" style="color:var(--accent); margin-right:6px;"></i><?= esc($s['vehicleName']) ?></td>
                                <td>
                                    <div><strong><?= esc($s['departureDate']) ?></strong></div>
                                    <small style="color:var(--text-muted);"><?= esc($s['departureTime']) ?></small>
                                </td>
                                <td><?= esc($s['seatCapacity']) ?> kursi</td>
                                <td class="td-bold" style="color: <?= ($s['availableSeats'] > 0) ? 'var(--success)' : 'var(--danger)' ?>;">
                                    <?= esc($s['availableSeats']) ?> sisa
                                </td>
                                <td>
                                    <span class="badge-status badge-<?= strtolower($s['status'] ?? 'active') ?>">
                                        <?= esc($s['status'] ?? 'active') ?>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="<?= base_url('schedules/edit/' . $s['id']) ?>" class="btn-icon" title="Edit"><i class="fas fa-edit"></i></a>
                                        <button onclick="confirmDelete('<?= base_url('schedules/delete/' . $s['id']) ?>', 'jadwal <?= esc($s['vehicleName']) ?>')" class="btn-icon danger" title="Hapus"><i class="fas fa-trash"></i></button>
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
