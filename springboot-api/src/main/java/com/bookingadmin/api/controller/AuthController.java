package com.bookingadmin.api.controller;

import com.bookingadmin.api.config.JwtUtil;
import com.bookingadmin.api.dto.ApiResponse;
import com.bookingadmin.api.dto.LoginRequest;
import com.bookingadmin.api.dto.LoginResponse;
import com.bookingadmin.api.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import com.bookingadmin.api.entity.User;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );

            var user = userService.findByUsername(request.getUsername())
                    .orElseGet(() -> userService.findByEmail(request.getUsername()).orElseThrow());

            UserDetails userDetails = userService.loadUserByUsername(user.getUsername());
            String token = jwtUtil.generateToken(userDetails);

            LoginResponse response = new LoginResponse(token, user.getId(), user.getUsername(), user.getEmail(), user.getRole().name());

            return ResponseEntity.ok(ApiResponse.success("Login berhasil", response));
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(ApiResponse.error("Username atau password salah"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Terjadi kesalahan: " + e.getMessage()));
        }
    }

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<User>> register(@Valid @RequestBody User user) {
        try {
            if (userService.existsByUsername(user.getUsername())) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Username sudah digunakan"));
            }
            if (userService.existsByEmail(user.getEmail())) {
                return ResponseEntity.badRequest()
                        .body(ApiResponse.error("Email sudah digunakan"));
            }
            user.setRole(User.Role.operator);
            User saved = userService.save(user);
            saved.setPassword("[PROTECTED]");
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(ApiResponse.success("Registrasi berhasil", saved));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ApiResponse.error("Gagal melakukan registrasi: " + e.getMessage()));
        }
    }
}
