<?php

namespace App\Controllers;

class Payments extends BaseController
{
    public function index()
    {
        $bookingId = $this->request->getGet('bookingId');
        $status    = $this->request->getGet('status');

        $response = $this->api->getPayments(
            $bookingId ? (int)$bookingId : null,
            $status ?: null
        );

        $data = [
            'title'           => 'Kelola Pembayaran',
            'payments'        => $response['data'] ?? [],
            'filterBookingId' => $bookingId,
            'filterStatus'    => $status,
        ];
        return view('payments/index', $data);
    }

    public function create()
    {
        $bookingsResponse = $this->api->getBookings();
        return view('payments/form', [
            'title'    => 'Tambah Pembayaran',
            'payment'  => null,
            'bookings' => $bookingsResponse['data'] ?? [],
            'action'   => 'create',
        ]);
    }

    public function store()
    {
        $paymentData = [
            'booking'         => ['id' => (int) $this->request->getPost('booking_id')],
            'amount'          => (int) $this->request->getPost('amount'),
            'paymentMethod'   => $this->request->getPost('paymentMethod'),
            'referenceNumber' => $this->request->getPost('referenceNumber'),
            'status'          => $this->request->getPost('status'),
        ];

        if ($paymentData['status'] === 'paid') {
            $paymentData['paidAt'] = date('Y-m-d\TH:i:s');
        }

        $response = $this->api->createPayment($paymentData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/payments')->with('success', 'Pembayaran berhasil ditambahkan.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal menambahkan pembayaran.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response         = $this->api->getPayment($id);
        $bookingsResponse = $this->api->getBookings();

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/payments')->with('error', 'Pembayaran tidak ditemukan.');
        }

        return view('payments/form', [
            'title'    => 'Edit Pembayaran',
            'payment'  => $response['data'],
            'bookings' => $bookingsResponse['data'] ?? [],
            'action'   => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $paymentData = [
            'booking'         => ['id' => (int) $this->request->getPost('booking_id')],
            'amount'          => (int) $this->request->getPost('amount'),
            'paymentMethod'   => $this->request->getPost('paymentMethod'),
            'referenceNumber' => $this->request->getPost('referenceNumber'),
            'status'          => $this->request->getPost('status'),
        ];

        if ($paymentData['status'] === 'paid') {
            $paymentData['paidAt'] = date('Y-m-d\TH:i:s');
        }

        $response = $this->api->updatePayment($id, $paymentData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/payments')->with('success', 'Pembayaran berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate pembayaran.')
            ->withInput();
    }

    public function delete(int $id)
    {
        $response = $this->api->deletePayment($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/payments')->with('success', 'Pembayaran berhasil dihapus.');
        }

        return redirect()->to('/payments')->with('error', $response['message'] ?? 'Gagal menghapus pembayaran.');
    }
}
