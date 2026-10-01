<?php

namespace App\Controllers;

class Schedules extends BaseController
{
    public function index()
    {
        $routeId = $this->request->getGet('routeId');
        $status  = $this->request->getGet('status');

        $response = $this->api->getSchedules(
            $routeId ? (int)$routeId : null,
            $status ?: null
        );

        $routesResponse = $this->api->getRoutes();

        $data = [
            'title'     => 'Kelola Jadwal',
            'schedules' => $response['data'] ?? [],
            'routes'    => $routesResponse['data'] ?? [],
            'filterRouteId' => $routeId,
            'filterStatus'  => $status,
        ];
        return view('schedules/index', $data);
    }

    public function create()
    {
        $routesResponse = $this->api->getRoutes();
        return view('schedules/form', [
            'title'    => 'Tambah Jadwal',
            'schedule' => null,
            'routes'   => $routesResponse['data'] ?? [],
            'action'   => 'create',
        ]);
    }

    public function store()
    {
        $scheduleData = [
            'route'          => ['id' => (int) $this->request->getPost('route_id')],
            'departureDate'  => $this->request->getPost('departureDate'),
            'departureTime'  => $this->request->getPost('departureTime'),
            'vehicleName'    => $this->request->getPost('vehicleName'),
            'seatCapacity'   => (int) $this->request->getPost('seatCapacity'),
            'availableSeats' => (int) $this->request->getPost('availableSeats'),
            'status'         => $this->request->getPost('status'),
        ];

        $response = $this->api->createSchedule($scheduleData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/schedules')->with('success', 'Jadwal berhasil ditambahkan.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal menambahkan jadwal.')
            ->withInput();
    }

    public function edit(int $id)
    {
        $response = $this->api->getSchedule($id);
        $routesResponse = $this->api->getRoutes();

        if (!isset($response['success']) || !$response['success']) {
            return redirect()->to('/schedules')->with('error', 'Jadwal tidak ditemukan.');
        }

        return view('schedules/form', [
            'title'    => 'Edit Jadwal',
            'schedule' => $response['data'],
            'routes'   => $routesResponse['data'] ?? [],
            'action'   => 'edit',
        ]);
    }

    public function update(int $id)
    {
        $scheduleData = [
            'route'          => ['id' => (int) $this->request->getPost('route_id')],
            'departureDate'  => $this->request->getPost('departureDate'),
            'departureTime'  => $this->request->getPost('departureTime'),
            'vehicleName'    => $this->request->getPost('vehicleName'),
            'seatCapacity'   => (int) $this->request->getPost('seatCapacity'),
            'availableSeats' => (int) $this->request->getPost('availableSeats'),
            'status'         => $this->request->getPost('status'),
        ];

        $response = $this->api->updateSchedule($id, $scheduleData);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/schedules')->with('success', 'Jadwal berhasil diupdate.');
        }

        return redirect()->back()
            ->with('error', $response['message'] ?? 'Gagal mengupdate jadwal.')
            ->withInput();
    }

    public function delete(int $id)
    {
        $response = $this->api->deleteSchedule($id);

        if (isset($response['success']) && $response['success']) {
            return redirect()->to('/schedules')->with('success', 'Jadwal berhasil dihapus.');
        }

        return redirect()->to('/schedules')->with('error', $response['message'] ?? 'Gagal menghapus jadwal.');
    }
}
