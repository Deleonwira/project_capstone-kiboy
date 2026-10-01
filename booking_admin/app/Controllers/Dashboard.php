<?php

namespace App\Controllers;

class Dashboard extends BaseController
{
    public function index()
    {
        // Fetch summary data from all endpoints
        $usersResponse      = $this->api->getUsers();
        $routesResponse     = $this->api->getRoutes();
        $schedulesResponse  = $this->api->getSchedules();
        $passengersResponse = $this->api->getPassengers();
        $bookingsResponse   = $this->api->getBookings();
        $paymentsResponse   = $this->api->getPayments();

        $users      = $usersResponse['data'] ?? [];
        $routes     = $routesResponse['data'] ?? [];
        $schedules  = $schedulesResponse['data'] ?? [];
        $passengers = $passengersResponse['data'] ?? [];
        $bookings   = $bookingsResponse['data'] ?? [];
        $payments   = $paymentsResponse['data'] ?? [];

        // Calculate statistics
        $totalRevenue = 0;
        $paidPayments = 0;
        foreach ($payments as $payment) {
            if (($payment['status'] ?? '') === 'paid') {
                $totalRevenue += $payment['amount'] ?? 0;
                $paidPayments++;
            }
        }

        // Booking status counts
        $bookingStats = ['pending' => 0, 'confirmed' => 0, 'cancelled' => 0, 'completed' => 0];
        foreach ($bookings as $booking) {
            $status = $booking['status'] ?? 'pending';
            if (isset($bookingStats[$status])) {
                $bookingStats[$status]++;
            }
        }

        // Recent bookings (last 5)
        $recentBookings = array_slice($bookings, -5);
        $recentBookings = array_reverse($recentBookings);

        // Recent payments (last 5)
        $recentPayments = array_slice($payments, -5);
        $recentPayments = array_reverse($recentPayments);

        $data = [
            'title'          => 'Dashboard',
            'totalUsers'     => count($users),
            'totalRoutes'    => count($routes),
            'totalSchedules' => count($schedules),
            'totalPassengers'=> count($passengers),
            'totalBookings'  => count($bookings),
            'totalPayments'  => count($payments),
            'totalRevenue'   => $totalRevenue,
            'paidPayments'   => $paidPayments,
            'bookingStats'   => $bookingStats,
            'recentBookings' => $recentBookings,
            'recentPayments' => $recentPayments,
        ];

        return view('dashboard/index', $data);
    }
}
