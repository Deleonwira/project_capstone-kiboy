<?php

namespace App\Controllers;

class Routes extends BaseController
{
    public function index()
    {
        $search = $this->request->getGet('search');
        $response = $this->api->getRoutes($search);
        $data = [
            'title'  => 'Kelola Rute',
            'routes' => $response['data'] ?? [],
            'search' => $search,
        ];
        return view('routes/index', $data);
    }

    public function create()
    {
        return view('routes/form', [
            'title'  => 'Tambah Rute',
            'route'  => null,
            'action' => 'create',
        ]);
    }

    public function store()
    {
        $routeData = [
            'origin'      => $this->request->getPost('origin'),
            'destination'  => $this->request->getPost('destination'),
            'distanceKm'  => (int) $this->request->getPost('distanceKm'),
            'basePrice'   => (int) $this->request->getPost('basePrice'),
        ];

        $response = $this->api->createRoute($routeData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/routes')->with('success', 'Rute berhasil ditambahkan.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal menambahkan rute.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response = $this->api->getRoute($id);

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/routes')->with('error', 'Rute tidak ditemukan.');
        }

        return view('routes/form', [
            'title'  => 'Edit Rute',
            'route'  => $response['data'],
            'action' => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $routeData = [
            'origin'      => $this->request->getPost('origin'),
            'destination'  => $this->request->getPost('destination'),
            'distanceKm'  => (int) $this->request->getPost('distanceKm'),
            'basePrice'   => (int) $this->request->getPost('basePrice'),
        ];

        $response = $this->api->updateRoute($id, $routeData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/routes')->with('success', 'Rute berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate rute.')
            ->withInput();
    }

    public function delete(int $id)
    {
        $response = $this->api->deleteRoute($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/routes')->with('success', 'Rute berhasil dihapus.');
        }

        return redirect()->to('/routes')->with('error', $response['message'] ?? 'Gagal menghapus rute.');
    }
}
