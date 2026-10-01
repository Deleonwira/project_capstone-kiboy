<?php

namespace App\Controllers;

class Bookings extends BaseController
{
    public function index()
    {
        $userId = $this->request->getGet('userId');
        $status = $this->request->getGet('status');

        $response = $this->api->getBookings(
            $userId ? (int)$userId : null,
            $status ?: null
        );

        $data = [
            'title'        => 'Kelola Booking',
            'bookings'     => $response['data'] ?? [],
            'filterUserId' => $userId,
            'filterStatus' => $status,
        ];
        return view('bookings/index', $data);
    }

    public function create()
    {
        $schedulesResponse  = $this->api->getSchedules();
        $passengersResponse = $this->api->getPassengers();
        $usersResponse      = $this->api->getUsers();

        return view('bookings/form', [
            'title'      => 'Tambah Booking',
            'booking'    => null,
            'schedules'  => $schedulesResponse['data'] ?? [],
            'passengers' => $passengersResponse['data'] ?? [],
            'users'      => $usersResponse['data'] ?? [],
            'action'     => 'create',
        ]);
    }

    public function store()
    {
        $bookingData = [
            'schedule'   => ['id' => (int) $this->request->getPost('schedule_id')],
            'passenger'  => ['id' => (int) $this->request->getPost('passenger_id')],
            'user'       => ['id' => (int) $this->request->getPost('user_id')],
            'seatCount'  => (int) $this->request->getPost('seatCount'),
            'totalPrice' => (int) $this->request->getPost('totalPrice'),
            'status'     => $this->request->getPost('status'),
        ];

        $response = $this->api->createBooking($bookingData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/bookings')->with('success', 'Booking berhasil dibuat.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal membuat booking.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response           = $this->api->getBooking($id);
        $schedulesResponse  = $this->api->getSchedules();
        $passengersResponse = $this->api->getPassengers();
        $usersResponse      = $this->api->getUsers();

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/bookings')->with('error', 'Booking tidak ditemukan.');
        }

        return view('bookings/form', [
            'title'      => 'Edit Booking',
            'booking'    => $response['data'],
            'schedules'  => $schedulesResponse['data'] ?? [],
            'passengers' => $passengersResponse['data'] ?? [],
            'users'      => $usersResponse['data'] ?? [],
            'action'     => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $bookingData = [
            'schedule'   => ['id' => (int) $this->request->getPost('schedule_id')],
            'passenger'  => ['id' => (int) $this->request->getPost('passenger_id')],
            'user'       => ['id' => (int) $this->request->getPost('user_id')],
            'seatCount'  => (int) $this->request->getPost('seatCount'),
            'totalPrice' => (int) $this->request->getPost('totalPrice'),
            'status'     => $this->request->getPost('status'),
        ];

        $response = $this->api->updateBooking($id, $bookingData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/bookings')->with('success', 'Booking berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate booking.')
            ->withInput();
    }

    public function detail(int $id)
    {
        $response = $this->api->getBooking($id);

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/bookings')->with('error', 'Booking tidak ditemukan.');
        }

        return view('bookings/detail', [
            'title'   => 'Detail Booking',
            'booking' => $response['data'],
        ]);
    }

    public function delete(int $id)
    {
        $response = $this->api->deleteBooking($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/bookings')->with('success', 'Booking berhasil dihapus.');
        }

        return redirect()->to('/bookings')->with('error', $response['message'] ?? 'Gagal menghapus booking.');
    }
}
