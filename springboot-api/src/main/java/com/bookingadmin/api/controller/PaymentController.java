package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.Payment;
import com.bookingadmin.api.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Payment>>> getAll(
            @RequestParam(required = false) Integer bookingId,
            @RequestParam(required = false) String status) {
        List<Payment> payments;
        if (bookingId != null) {
            payments = paymentService.findByBookingId(bookingId);
        } else if (status != null) {
            try {
                payments = paymentService.findByStatus(Payment.Status.valueOf(status));
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Status tidak valid. Gunakan: pending, paid, failed, refunded"));
            }
        } else {
            payments = paymentService.findAll();
        }
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data payments", payments));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Payment>> getById(@PathVariable Integer id) {
        return paymentService.findById(id)
                .map(p -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data payment", p)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Payment tidak ditemukan")));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Payment>> create(@RequestBody Payment payment) {
        try {
            Payment saved = paymentService.save(payment);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Payment berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat payment: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Payment>> update(@PathVariable Integer id, @RequestBody Payment payment) {
        try {
            Payment updated = paymentService.update(id, payment);
            return ResponseEntity.ok(ApiResponse.success("Payment berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            paymentService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("Payment berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
