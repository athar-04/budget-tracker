package com.example.demo.controller;

import com.example.demo.model.User;
import com.example.demo.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final UserService service;

    public AuthController(UserService service) {
        this.service = service;
    }

    @PostMapping("/register")
    public ResponseEntity<User> register(@RequestBody User user) {
        User created = service.register(user);
        created.setPassword(null); // hide password in response
        return ResponseEntity.status(201).body(created);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body) {
        String email = body.get("email");
        String password = body.get("password");

        return service.login(email, password)
                .map(u -> ResponseEntity.ok(
                        Map.of(
                                "token", "dummy-token-" + u.getId(),
                                "userId", u.getId()
                        )
                ))
                .orElseGet(() -> ResponseEntity.status(401)
                        .body(Map.of("error", "Invalid credentials")));
    }
}
