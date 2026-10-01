package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.Schedule;
import com.bookingadmin.api.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/schedules")
@CrossOrigin(origins = "*")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Schedule>>> getAll(
            @RequestParam(required = false) Integer routeId,
            @RequestParam(required = false) String status) {
        List<Schedule> schedules;
        if (routeId != null) {
            schedules = scheduleService.findByRouteId(routeId);
        } else if (status != null) {
            try {
                schedules = scheduleService.findByStatus(Schedule.Status.valueOf(status));
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body(ApiResponse.error("Status tidak valid. Gunakan: active, cancelled, completed"));
            }
        } else {
            schedules = scheduleService.findAll();
        }
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data schedules", schedules));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Schedule>> getById(@PathVariable Integer id) {
        return scheduleService.findById(id)
                .map(s -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data schedule", s)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Schedule tidak ditemukan")));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Schedule>> create(@RequestBody Schedule schedule) {
        try {
            Schedule saved = scheduleService.save(schedule);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Schedule berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat schedule: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Schedule>> update(@PathVariable Integer id, @RequestBody Schedule schedule) {
        try {
            Schedule updated = scheduleService.update(id, schedule);
            return ResponseEntity.ok(ApiResponse.success("Schedule berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            scheduleService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("Schedule berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
