-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 16 Jun 2026 pada 20.48
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking_admin`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) UNSIGNED NOT NULL,
  `booking_code` varchar(20) NOT NULL,
  `schedule_id` int(11) UNSIGNED NOT NULL,
  `passenger_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `seat_count` int(11) UNSIGNED NOT NULL DEFAULT 1,
  `total_price` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` enum('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'pending',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bookings`
--

INSERT INTO `bookings` (`id`, `booking_code`, `schedule_id`, `passenger_id`, `user_id`, `seat_count`, `total_price`, `status`, `created_at`, `updated_at`) VALUES
(1, 'BK-00000001', 1, 1, 1, 1, 150000, 'confirmed', '2026-03-02 12:47:24', '2026-03-03 07:13:49'),
(2, 'BK-00000002', 1, 2, 1, 1, 150000, 'confirmed', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(3, 'BK-00000003', 3, 3, 2, 2, 150000, 'pending', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(4, 'BK-00000004', 4, 4, 1, 2, 200000, 'completed', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(5, 'BK-F5F1C530', 1, 4, 1, 4, 600000, 'pending', '2026-03-02 13:43:22', '2026-03-02 13:43:22'),
(6, 'BK-4762BA54', 3, 1, 1, 5, 375000, 'confirmed', '2026-03-02 13:46:02', '2026-03-02 15:34:06'),
(7, 'BK-8182DBFD', 2, 1, 1, 3, 450000, 'pending', '2026-03-02 15:33:39', '2026-03-02 15:33:39');

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `version`, `class`, `group`, `namespace`, `time`, `batch`) VALUES
(1, '2026-02-25-031900', 'App\\Database\\Migrations\\CreateUsersTable', 'default', 'App', 1772455642, 1),
(2, '2026-02-25-032000', 'App\\Database\\Migrations\\CreateRoutesTable', 'default', 'App', 1772455642, 1),
(3, '2026-02-25-032100', 'App\\Database\\Migrations\\CreateSchedulesTable', 'default', 'App', 1772455642, 1),
(4, '2026-02-25-032200', 'App\\Database\\Migrations\\CreatePassengersTable', 'default', 'App', 1772455642, 1),
(5, '2026-02-25-032300', 'App\\Database\\Migrations\\CreateBookingsTable', 'default', 'App', 1772455642, 1),
(6, '2026-02-25-032400', 'App\\Database\\Migrations\\CreatePaymentsTable', 'default', 'App', 1772455642, 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `passengers`
--

CREATE TABLE `passengers` (
  `id` int(11) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `id_number` varchar(30) DEFAULT NULL,
  `gender` enum('L','P') NOT NULL DEFAULT 'L',
  `address` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `passengers`
--

INSERT INTO `passengers` (`id`, `name`, `phone`, `email`, `id_number`, `gender`, `address`, `created_at`, `updated_at`) VALUES
(1, 'Budi Santoso', '081234567890', 'budi@email.com', '3201234567890001', 'L', 'Jl. Merdeka No. 10, Jakarta', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(2, 'Siti Nurhaliza', '082345678901', 'siti@email.com', '3201234567890002', 'P', 'Jl. Sudirman No. 25, Bandung', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(3, 'Ahmad Fauzi', '083456789012', 'ahmad@email.com', '3201234567890003', 'L', 'Jl. Diponegoro No. 5, Surabaya', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(4, 'Dewi Lestari', '084567890123', 'dewi@email.com', '3201234567890004', 'P', 'Jl. Malioboro No. 15, Yogyakarta', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(5, 'Rizky Pratama', '085678901234', 'rizky@email.com', '3201234567890005', 'L', 'Jl. Ahmad Yani No. 30, Semarang', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(6, 'Boazoma Surung', '085281242452', 'batubaraboaz@gmail.com', '20250421', 'L', 'Kijang Kencana', '2026-03-02 15:35:35', '2026-03-02 15:35:35'),
(7, 'Budi', '87 827 337 250', 'batubaraboaz@gmail.com', '123456', 'L', 'jl kijang', '2026-03-03 06:30:02', '2026-03-03 06:30:02');

-- --------------------------------------------------------

--
-- Struktur dari tabel `payments`
--

CREATE TABLE `payments` (
  `id` int(11) UNSIGNED NOT NULL,
  `booking_id` int(11) UNSIGNED NOT NULL,
  `amount` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `payment_method` varchar(50) NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `status` enum('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  `paid_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `payments`
--

INSERT INTO `payments` (`id`, `booking_id`, `amount`, `payment_method`, `reference_number`, `status`, `paid_at`, `created_at`, `updated_at`) VALUES
(1, 1, 150000, 'Transfer Bank', 'TRF-20260225-001', 'paid', '2026-03-02 12:47:24', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(2, 2, 150000, 'E-Wallet', 'EW-20260225-002', 'paid', '2026-03-02 12:47:24', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(3, 3, 150000, 'Cash', '', 'paid', '2026-03-02 13:43:48', '2026-03-02 12:47:24', '2026-03-02 13:43:48'),
(4, 4, 200000, 'Transfer Bank', 'TRF-20260225-003', 'paid', '2026-03-02 12:47:24', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(5, 6, 375000, 'E-Wallet', '', 'paid', '2026-03-02 13:46:32', '2026-03-02 13:46:32', '2026-03-02 13:46:32'),
(6, 6, 375000, 'E-Wallet', '', 'paid', '2026-03-02 15:34:06', '2026-03-02 15:34:06', '2026-03-02 15:34:06'),
(7, 1, 150000, 'E-Wallet', '', 'paid', '2026-03-03 06:30:38', '2026-03-03 06:30:38', '2026-03-03 06:30:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `routes`
--

CREATE TABLE `routes` (
  `id` int(11) UNSIGNED NOT NULL,
  `origin` varchar(100) NOT NULL,
  `destination` varchar(100) NOT NULL,
  `distance_km` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `base_price` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `routes`
--

INSERT INTO `routes` (`id`, `origin`, `destination`, `distance_km`, `base_price`, `created_at`, `updated_at`) VALUES
(1, 'Jakarta', 'Bandung', 150, 150000, '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(2, 'Surabaya', 'Malang', 90, 75000, '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(3, 'Yogyakarta', 'Semarang', 120, 100000, '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(4, 'Jakarta', 'Semarang', 450, 300000, '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(5, 'Bandung', 'Garut', 65, 50000, '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(6, 'Malang', 'Bali', 200, 500000, '2026-03-02 15:34:58', '2026-03-02 15:34:58'),
(7, 'Jakarta', 'Pontianak', 300, 500000, '2026-03-03 06:31:38', '2026-03-03 06:31:38'),
(9, 'Jakarta', 'Bali', 222, 222222, '2026-03-03 07:14:52', '2026-03-03 07:14:52');

-- --------------------------------------------------------

--
-- Struktur dari tabel `schedules`
--

CREATE TABLE `schedules` (
  `id` int(11) UNSIGNED NOT NULL,
  `route_id` int(11) UNSIGNED NOT NULL,
  `departure_date` date NOT NULL,
  `departure_time` time NOT NULL,
  `vehicle_name` varchar(100) NOT NULL,
  `seat_capacity` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `available_seats` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `status` enum('active','cancelled','completed') NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `schedules`
--

INSERT INTO `schedules` (`id`, `route_id`, `departure_date`, `departure_time`, `vehicle_name`, `seat_capacity`, `available_seats`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, '2026-03-01', '07:00:00', 'Bus Eksekutif A1', 40, 35, 'active', '2026-03-02 12:47:24', '2026-03-09 14:41:02'),
(2, 1, '2026-03-01', '14:00:00', 'Bus Eksekutif A2', 40, 37, 'active', '2026-03-02 12:47:24', '2026-03-03 07:43:51'),
(3, 2, '2026-03-02', '08:30:00', 'Minibus B1', 15, 8, 'active', '2026-03-02 12:47:24', '2026-03-02 13:46:02'),
(4, 3, '2026-03-03', '06:00:00', 'Bus VIP C1', 30, 28, 'active', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(5, 4, '2026-03-01', '20:00:00', 'Bus Sleeper D1', 25, 25, 'active', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(6, 2, '2026-03-02', '12:00:00', 'Bus Eksekutif', 40, 39, 'active', '2026-03-03 07:32:07', '2026-03-03 07:32:42'),
(7, 9, '2026-03-02', '12:00:00', 'Bus Eksekutif', 40, 40, 'active', '2026-03-03 07:41:40', '2026-03-03 07:41:40');

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) UNSIGNED NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','operator') NOT NULL DEFAULT 'operator',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `role`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@bookingtravel.com', '$2y$10$01w1UTVCTLTd8D4BlA0rFuOE0um8KIRzvTb6JmQ0kRTi0l6q8XVwm', 'admin', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(2, 'operator1', 'operator1@bookingtravel.com', '$2y$10$cgNtGJ3bb78hxA5umVc1luIkFdxJJSAIno5E56p.YRH5PUbQidrG.', 'operator', '2026-03-02 12:47:24', '2026-03-02 12:47:24'),
(3, 'boaz', 'batubaraboaz@gmail.com', '$2y$10$2XkMlCxbQs3jFLq939t1geVMfQPeg9sKrlUIaKuo8FFKnON1utip6', 'operator', '2026-03-02 15:36:05', '2026-03-02 15:36:05'),
(4, 'rifki', 'rifki@gmail.com', '$2y$10$.O5P/gLg8Qq0JS89V3HUHOaQRPvW6MpKy4xLKly8Gpb70mUVB4KoO', 'operator', '2026-03-03 07:38:45', '2026-03-03 07:38:45');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_code` (`booking_code`),
  ADD KEY `bookings_schedule_id_foreign` (`schedule_id`),
  ADD KEY `bookings_passenger_id_foreign` (`passenger_id`),
  ADD KEY `bookings_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `passengers`
--
ALTER TABLE `passengers`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_booking_id_foreign` (`booking_id`);

--
-- Indeks untuk tabel `routes`
--
ALTER TABLE `routes`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `schedules`
--
ALTER TABLE `schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `schedules_route_id_foreign` (`route_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `passengers`
--
ALTER TABLE `passengers`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `routes`
--
ALTER TABLE `routes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `schedules`
--
ALTER TABLE `schedules`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_passenger_id_foreign` FOREIGN KEY (`passenger_id`) REFERENCES `passengers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookings_schedule_id_foreign` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `schedules`
--
ALTER TABLE `schedules`
  ADD CONSTRAINT `schedules_route_id_foreign` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
