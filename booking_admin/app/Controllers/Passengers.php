<?php

namespace App\Controllers;

class Passengers extends BaseController
{
    public function index()
    {
        $search = $this->request->getGet('search');
        $response = $this->api->getPassengers($search);
        $data = [
            'title'      => 'Kelola Penumpang',
            'passengers' => $response['data'] ?? [],
            'search'     => $search,
        ];
        return view('passengers/index', $data);
    }

    public function create()
    {
        return view('passengers/form', [
            'title'     => 'Tambah Penumpang',
            'passenger' => null,
            'action'    => 'create',
        ]);
    }

    public function store()
    {
        $passengerData = [
            'name'     => $this->request->getPost('name'),
            'phone'    => $this->request->getPost('phone'),
            'email'    => $this->request->getPost('email'),
            'idNumber' => $this->request->getPost('idNumber'),
            'gender'   => $this->request->getPost('gender'),
            'address'  => $this->request->getPost('address'),
        ];

        $response = $this->api->createPassenger($passengerData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/passengers')->with('success', 'Penumpang berhasil ditambahkan.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal menambahkan penumpang.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response = $this->api->getPassenger($id);

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/passengers')->with('error', 'Penumpang tidak ditemukan.');
        }

        return view('passengers/form', [
            'title'     => 'Edit Penumpang',
            'passenger' => $response['data'],
            'action'    => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $passengerData = [
            'name'     => $this->request->getPost('name'),
            'phone'    => $this->request->getPost('phone'),
            'email'    => $this->request->getPost('email'),
            'idNumber' => $this->request->getPost('idNumber'),
            'gender'   => $this->request->getPost('gender'),
            'address'  => $this->request->getPost('address'),
        ];

        $response = $this->api->updatePassenger($id, $passengerData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/passengers')->with('success', 'Penumpang berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate penumpang.')
            ->withInput();
    }

    public function delete(int $id)
    {
        $response = $this->api->deletePassenger($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/passengers')->with('success', 'Penumpang berhasil dihapus.');
        }

        return redirect()->to('/passengers')->with('error', $response['message'] ?? 'Gagal menghapus penumpang.');
    }
}
