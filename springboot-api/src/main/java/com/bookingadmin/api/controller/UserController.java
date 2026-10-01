package com.bookingadmin.api.controller;

import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.entity.User;
import com.bookingadmin.api.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<User>>> getAll() {
        List<User> users = userService.findAll();
        return ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data users", users));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<User>> getById(@PathVariable Integer id) {
        return userService.findById(id)
                .map(user -> ResponseEntity.ok(ApiResponse.success("Berhasil mengambil data user", user)))
                .orElse(ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(ApiResponse.error("User tidak ditemukan")));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<User>> create(@RequestBody User user) {
        try {
            if (userService.existsByUsername(user.getUsername())) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Username sudah digunakan"));
            }
            if (userService.existsByEmail(user.getEmail())) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Email sudah digunakan"));
            }
            User saved = userService.save(user);
            saved.setPassword("[PROTECTED]");
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("User berhasil dibuat", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal membuat user: " + e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<User>> update(@PathVariable Integer id, @RequestBody User user) {
        try {
            User updated = userService.update(id, user);
            updated.setPassword("[PROTECTED]");
            return ResponseEntity.ok(ApiResponse.success("User berhasil diupdate", updated));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Integer id) {
        try {
            userService.delete(id);
            return ResponseEntity.ok(ApiResponse.success("User berhasil dihapus", null));
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
