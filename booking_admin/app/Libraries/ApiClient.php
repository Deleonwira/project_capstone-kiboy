<?php

namespace App\Libraries;

class ApiClient
{
    protected string $baseUrl;
    protected ?string $token;

    public function __construct()
    {
        $this->baseUrl = env('API_BASE_URL', 'http://localhost:8080/api');
        $this->token = session()->get('jwt_token');
    }

    /**
     * Set the JWT token for authenticated requests
     */
    public function setToken(string $token): self
    {
        $this->token = $token;
        return $this;
    }

    /**
     * Build headers for the request
     */
    protected function buildHeaders(): array
    {
        $headers = [
            'Content-Type: application/json',
            'Accept: application/json',
        ];

        if ($this->token) {
            $headers[] = 'Authorization: Bearer ' . $this->token;
        }

        return $headers;
    }

    /**
     * Execute a cURL request
     */
    protected function request(string $method, string $endpoint, ?array $data = null, array $queryParams = []): array
    {
        $url = $this->baseUrl . $endpoint;

        if (!empty($queryParams)) {
            $url .= '?' . http_build_query($queryParams);
        }

        $ch = curl_init();

        curl_setopt_array($ch, [
            CURLOPT_URL            => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_TIMEOUT        => 30,
            CURLOPT_HTTPHEADER     => $this->buildHeaders(),
            CURLOPT_SSL_VERIFYPEER => false,
        ]);

        switch (strtoupper($method)) {
            case 'POST':
                curl_setopt($ch, CURLOPT_POST, true);
                if ($data !== null) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
                }
                break;
            case 'PUT':
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
                if ($data !== null) {
                    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
                }
                break;
            case 'DELETE':
                curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
                break;
            case 'GET':
            default:
                break;
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $error    = curl_error($ch);
        curl_close($ch);

        if ($error) {
            return [
                'success' => false,
                'message' => 'Koneksi ke API gagal: ' . $error,
                'data'    => null,
            ];
        }

        $decoded = json_decode($response, true);

        if ($decoded === null) {
            return [
                'success' => false,
                'message' => 'Response API tidak valid (HTTP ' . $httpCode . ')',
                'data'    => null,
            ];
        }

        return $decoded;
    }

    // ─── Auth ─────────────────────────────────────────────
    public function login(string $username, string $password): array
    {
        return $this->request('POST', '/auth/login', [
            'username' => $username,
            'password' => $password,
        ]);
    }

    // ─── Users ────────────────────────────────────────────
    public function getUsers(): array
    {
        return $this->request('GET', '/users');
    }

    public function getUser(int $id): array
    {
        return $this->request('GET', '/users/' . $id);
    }

    public function createUser(array $data): array
    {
        return $this->request('POST', '/users', $data);
    }

    public function updateUser(int $id, array $data): array
    {
        return $this->request('PUT', '/users/' . $id, $data);
    }

    public function deleteUser(int $id): array
    {
        return $this->request('DELETE', '/users/' . $id);
    }

    // ─── Routes ───────────────────────────────────────────
    public function getRoutes(?string $search = null): array
    {
        $params = [];
        if ($search) {
            $params['search'] = $search;
        }
        return $this->request('GET', '/routes', null, $params);
    }

    public function getRoute(int $id): array
    {
        return $this->request('GET', '/routes/' . $id);
    }

    public function createRoute(array $data): array
    {
        return $this->request('POST', '/routes', $data);
    }

    public function updateRoute(int $id, array $data): array
    {
        return $this->request('PUT', '/routes/' . $id, $data);
    }

    public function deleteRoute(int $id): array
    {
        return $this->request('DELETE', '/routes/' . $id);
    }

    // ─── Schedules ────────────────────────────────────────
    public function getSchedules(?int $routeId = null, ?string $status = null): array
    {
        $params = [];
        if ($routeId) {
            $params['routeId'] = $routeId;
        }
        if ($status) {
            $params['status'] = $status;
        }
        return $this->request('GET', '/schedules', null, $params);
    }

    public function getSchedule(int $id): array
    {
        return $this->request('GET', '/schedules/' . $id);
    }

    public function createSchedule(array $data): array
    {
        return $this->request('POST', '/schedules', $data);
    }

    public function updateSchedule(int $id, array $data): array
    {
        return $this->request('PUT', '/schedules/' . $id, $data);
    }

    public function deleteSchedule(int $id): array
    {
        return $this->request('DELETE', '/schedules/' . $id);
    }

    // ─── Passengers ───────────────────────────────────────
    public function getPassengers(?string $search = null): array
    {
        $params = [];
        if ($search) {
            $params['search'] = $search;
        }
        return $this->request('GET', '/passengers', null, $params);
    }

    public function getPassenger(int $id): array
    {
        return $this->request('GET', '/passengers/' . $id);
    }

    public function createPassenger(array $data): array
    {
        return $this->request('POST', '/passengers', $data);
    }

    public function updatePassenger(int $id, array $data): array
    {
        return $this->request('PUT', '/passengers/' . $id, $data);
    }

    public function deletePassenger(int $id): array
    {
        return $this->request('DELETE', '/passengers/' . $id);
    }

    // ─── Bookings ─────────────────────────────────────────
    public function getBookings(?int $userId = null, ?string $status = null): array
    {
        $params = [];
        if ($userId) {
            $params['userId'] = $userId;
        }
        if ($status) {
            $params['status'] = $status;
        }
        return $this->request('GET', '/bookings', null, $params);
    }

    public function getBooking(int $id): array
    {
        return $this->request('GET', '/bookings/' . $id);
    }

    public function getBookingByCode(string $code): array
    {
        return $this->request('GET', '/bookings/code/' . $code);
    }

    public function createBooking(array $data): array
    {
        return $this->request('POST', '/bookings', $data);
    }

    public function updateBooking(int $id, array $data): array
    {
        return $this->request('PUT', '/bookings/' . $id, $data);
    }

    public function deleteBooking(int $id): array
    {
        return $this->request('DELETE', '/bookings/' . $id);
    }

    // ─── Payments ─────────────────────────────────────────
    public function getPayments(?int $bookingId = null, ?string $status = null): array
    {
        $params = [];
        if ($bookingId) {
            $params['bookingId'] = $bookingId;
        }
        if ($status) {
            $params['status'] = $status;
        }
        return $this->request('GET', '/payments', null, $params);
    }

    public function getPayment(int $id): array
    {
        return $this->request('GET', '/payments/' . $id);
    }

    public function createPayment(array $data): array
    {
        return $this->request('POST', '/payments', $data);
    }

    public function updatePayment(int $id, array $data): array
    {
        return $this->request('PUT', '/payments/' . $id, $data);
    }

    public function deletePayment(int $id): array
    {
        return $this->request('DELETE', '/payments/' . $id);
    }
}
