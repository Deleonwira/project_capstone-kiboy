package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.Passenger;
import com.bookingadmin.api.service.PassengerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/passengers")
@CrossOrigin(origins = "*")
public class PassengerController {

    @Autowired
    private PassengerService passengerService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Passenger>>> getAll(
            @RequestParam(required = false) String search) {
        List<Passenger> passengers = (search != null && !search.isBlank())
                ? passengerService.searchByName(search)
                : passengerService.findAll();
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data passengers", passengers));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Passenger>> getById(@PathVariable Integer id) {
        return passengerService.findById(id)
                .map(p -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data passenger", p)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Passenger tidak ditemukan")));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Passenger>> create(@RequestBody Passenger passenger) {
        try {
            Passenger saved = passengerService.save(passenger);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Passenger berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat passenger: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Passenger>> update(@PathVariable Integer id, @RequestBody Passenger passenger) {
        try {
            Passenger updated = passengerService.update(id, passenger);
            return ResponseEntity.ok(ApiResponse.success("Passenger berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            passengerService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("Passenger berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
