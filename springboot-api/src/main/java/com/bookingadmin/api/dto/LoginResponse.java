package com.bookingadmin.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class LoginResponse {
    private String token;
    private String tokenType;
    private Integer id;
    private String username;
    private String email;
    private String role;

    public LoginResponse(String token, Integer id, String username, String email, String role) {
        this.token = token;
        this.tokenType = "Bearer";
        this.id = id;
        this.username = username;
        this.email = email;
        this.role = role;
    }
}
