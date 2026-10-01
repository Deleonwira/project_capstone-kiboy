package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.Booking;
import com.bookingadmin.api.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = "*")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Booking>>> getAll(
            @RequestParam(required = false) Integer userId,
            @RequestParam(required = false) String status) {
        List<Booking> bookings;
        if (userId != null) {
            bookings = bookingService.findByUserId(userId);
        } else if (status != null) {
            try {
                bookings = bookingService.findByStatus(Booking.Status.valueOf(status));
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Status tidak valid. Gunakan: pending, confirmed, cancelled, completed"));
            }
        } else {
            bookings = bookingService.findAll();
        }
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data bookings", bookings));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Booking>> getById(@PathVariable Integer id) {
        return bookingService.findById(id)
                .map(b -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data booking", b)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Booking tidak ditemukan")));
    }

    @GetMapping("/code/{bookingCode}")
    public ResponseEntity<ApiResponse<Booking>> getByCode(@PathVariable String bookingCode) {
        return bookingService.findByBookingCode(bookingCode)
                .map(b -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data booking", b)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Booking tidak ditemukan dengan kode: " + bookingCode)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Booking>> create(@RequestBody Booking booking) {
        try {
            Booking saved = bookingService.save(booking);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Booking berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat booking: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Booking>> update(@PathVariable Integer id, @RequestBody Booking booking) {
        try {
            Booking updated = bookingService.update(id, booking);
            return ResponseEntity.ok(ApiResponse.success("Booking berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            bookingService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("Booking berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
