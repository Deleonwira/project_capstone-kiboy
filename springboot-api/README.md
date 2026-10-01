# 🚌 Booking Admin API - Spring Boot

REST API untuk sistem manajemen booking travel menggunakan Spring Boot 3.2, Spring Security + JWT, dan MySQL/MariaDB.

---

## 🛠️ Teknologi

| Teknologi | Versi |
|---|---|
| Java | 17 |
| Spring Boot | 3.2.5 |
| Spring Security | 6.x |
| Spring Data JPA | 3.x |
| MySQL Connector | Latest |
| JJWT | 0.12.6 |
| Lombok | Latest |

---

## ⚙️ Setup & Konfigurasi

### 1. Buka database
Pastikan MySQL/MariaDB sudah berjalan dan import database:
```sql
mysql -u root -p < ../database/booking_admin.sql
```

### 2. Sesuaikan konfigurasi database
Edit file `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/booking_admin
spring.datasource.username=root
spring.datasource.password=        # Sesuaikan password Anda
```

### 3. Jalankan project
```bash
# Compile
mvn clean install

# Jalankan
mvn spring-boot:run
```

Server akan berjalan di: `http://localhost:8080`

---

## 🔐 Autentikasi

API menggunakan **JWT Bearer Token**.

### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "admin",
  "password": "password_admin"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "tokenType": "Bearer",
    "username": "admin",
    "role": "admin"
  }
}
```

### Gunakan Token
Tambahkan header di setiap request:
```
Authorization: Bearer <token>
```

---

## 📋 Endpoints

### 🔑 Auth
| Method | Endpoint | Deskripsi |
|---|---|---|
| POST | `/api/auth/login` | Login & dapatkan JWT token |

### 👤 Users
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/users` | Get semua users |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Buat user baru |
| PUT | `/api/users/{id}` | Update user |
| DELETE | `/api/users/{id}` | Hapus user |

### 🗺️ Routes
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/routes` | Get semua routes |
| GET | `/api/routes?search=Jakarta` | Cari route |
| GET | `/api/routes/{id}` | Get route by ID |
| POST | `/api/routes` | Buat route baru |
| PUT | `/api/routes/{id}` | Update route |
| DELETE | `/api/routes/{id}` | Hapus route |

### 📅 Schedules
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/schedules` | Get semua schedules |
| GET | `/api/schedules?routeId=1` | Filter by route |
| GET | `/api/schedules?status=active` | Filter by status |
| GET | `/api/schedules/{id}` | Get schedule by ID |
| POST | `/api/schedules` | Buat schedule baru |
| PUT | `/api/schedules/{id}` | Update schedule |
| DELETE | `/api/schedules/{id}` | Hapus schedule |

### 👥 Passengers
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/passengers` | Get semua passengers |
| GET | `/api/passengers?search=Budi` | Cari by nama |
| GET | `/api/passengers/{id}` | Get passenger by ID |
| POST | `/api/passengers` | Buat passenger baru |
| PUT | `/api/passengers/{id}` | Update passenger |
| DELETE | `/api/passengers/{id}` | Hapus passenger |

### 🎫 Bookings
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/bookings` | Get semua bookings |
| GET | `/api/bookings?userId=1` | Filter by user |
| GET | `/api/bookings?status=pending` | Filter by status |
| GET | `/api/bookings/{id}` | Get booking by ID |
| GET | `/api/bookings/code/BK-00000001` | Get by booking code |
| POST | `/api/bookings` | Buat booking baru |
| PUT | `/api/bookings/{id}` | Update booking |
| DELETE | `/api/bookings/{id}` | Hapus booking |

### 💳 Payments
| Method | Endpoint | Deskripsi |
|---|---|---|
| GET | `/api/payments` | Get semua payments |
| GET | `/api/payments?bookingId=1` | Filter by booking |
| GET | `/api/payments?status=paid` | Filter by status |
| GET | `/api/payments/{id}` | Get payment by ID |
| POST | `/api/payments` | Buat payment baru |
| PUT | `/api/payments/{id}` | Update payment |
| DELETE | `/api/payments/{id}` | Hapus payment |

---

## 📦 Contoh Request Body

### Buat Booking Baru
```json
POST /api/bookings
Authorization: Bearer <token>

{
  "schedule": { "id": 1 },
  "passenger": { "id": 1 },
  "user": { "id": 1 },
  "seatCount": 2,
  "totalPrice": 300000,
  "status": "pending"
}
```

### Buat Schedule Baru
```json
POST /api/schedules
Authorization: Bearer <token>

{
  "route": { "id": 1 },
  "departureDate": "2026-07-01",
  "departureTime": "08:00:00",
  "vehicleName": "Bus Eksekutif A3",
  "seatCapacity": 40,
  "availableSeats": 40,
  "status": "active"
}
```

---

## 📁 Struktur Project

```
src/main/java/com/bookingadmin/api/
├── BookingAdminApplication.java
├── config/
│   ├── SecurityConfig.java
│   ├── JwtUtil.java
│   └── JwtFilter.java
├── entity/
│   ├── User.java
│   ├── Route.java
│   ├── Schedule.java
│   ├── Passenger.java
│   ├── Booking.java
│   └── Payment.java
├── repository/
│   ├── UserRepository.java
│   ├── RouteRepository.java
│   ├── ScheduleRepository.java
│   ├── PassengerRepository.java
│   ├── BookingRepository.java
│   └── PaymentRepository.java
├── service/
│   ├── UserService.java
│   ├── RouteService.java
│   ├── ScheduleService.java
│   ├── PassengerService.java
│   ├── BookingService.java
│   └── PaymentService.java
├── controller/
│   ├── AuthController.java
│   ├── UserController.java
│   ├── RouteController.java
│   ├── ScheduleController.java
│   ├── PassengerController.java
│   ├── BookingController.java
│   └── PaymentController.java
└── dto/
    ├── ApiResponse.java
    ├── LoginRequest.java
    └── LoginResponse.java
```
