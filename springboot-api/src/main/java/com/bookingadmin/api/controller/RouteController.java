package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.Route;
import com.bookingadmin.api.service.RouteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/routes")
@CrossOrigin(origins = "*")
public class RouteController {

    @Autowired
    private RouteService routeService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Route>>> getAll(
            @RequestParam(required = false) String search) {
        List<Route> routes = (search != null && !search.isBlank())
                ? routeService.search(search)
                : routeService.findAll();
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data routes", routes));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Route>> getById(@PathVariable Integer id) {
        return routeService.findById(id)
                .map(route -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data route", route)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("Route tidak ditemukan")));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Route>> create(@RequestBody Route route) {
        try {
            Route saved = routeService.save(route);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Route berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat route: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Route>> update(@PathVariable Integer id, @RequestBody Route route) {
        try {
            Route updated = routeService.update(id, route);
            return ResponseEntity.ok(ApiResponse.success("Route berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            routeService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("Route berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
