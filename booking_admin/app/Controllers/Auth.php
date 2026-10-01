<?php

namespace App\Controllers;

class Auth extends BaseController
{
    public function login()
    {
        if (session()->get('logged_in')) {
            return redirect()->to('/dashboard');
        }

        return view('auth/login');
    }

    public function attemptLogin()
    {
        $username = $this->request->getPost('username');
        $password = $this->request->getPost('password');

        if (empty($username) || empty($password)) {
            return redirect()->back()->with('error', 'Username dan password wajib diisi.');
        }

        $response = $this->api->login($username, $password);

        if (isset($response['success']) && $response['success'] === true) {
            $data = $response['data'];
            session()->set([
                'logged_in'  => true,
                'jwt_token'  => $data['token'],
                'user_id'    => $data['id'],
                'username'   => $data['username'],
                'email'      => $data['email'],
                'role'       => $data['role'],
            ]);

            return redirect()->to('/dashboard')->with('success', 'Selamat datang, ' . $data['username'] . '!');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Login gagal. Periksa username dan password.')
            ->withInput();
    }

    public function logout()
    {
        session()->destroy();
        return redirect()->to('/login')->with('success', 'Berhasil logout.');
    }
}
