<?php

namespace App\Controllers;

class Users extends BaseController
{
    public function index()
    {
        $response = $this->api->getUsers();
        $data = [
            'title' => 'Kelola Users',
            'users' => $response['data'] ?? [],
        ];
        return view('users/index', $data);
    }

    public function create()
    {
        return view('users/form', [
            'title'  => 'Tambah User',
            'user'   => null,
            'action' => 'create',
        ]);
    }

    public function store()
    {
        $userData = [
            'username' => $this->request->getPost('username'),
            'email'    => $this->request->getPost('email'),
            'password' => $this->request->getPost('password'),
            'role'     => $this->request->getPost('role'),
        ];

        $response = $this->api->createUser($userData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/users')->with('success', 'User berhasil ditambahkan.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal menambahkan user.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response = $this->api->getUser($id);

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/users')->with('error', 'User tidak ditemukan.');
        }

        return view('users/form', [
            'title'  => 'Edit User',
            'user'   => $response['data'],
            'action' => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $userData = [
            'username' => $this->request->getPost('username'),
            'email'    => $this->request->getPost('email'),
            'role'     => $this->request->getPost('role'),
        ];

        $password = $this->request->getPost('password');
        if (!empty($password)) {
            $userData['password'] = $password;
        }

        $response = $this->api->updateUser($id, $userData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/users')->with('success', 'User berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate user.')
            ->withInput();
    }

    public function delete(int $id)
    {
        $response = $this->api->deleteUser($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/users')->with('success', 'User berhasil dihapus.');
        }

        return redirect()->to('/users')->with('error', $response['message'] ?? 'Gagal menghapus user.');
    }
}
