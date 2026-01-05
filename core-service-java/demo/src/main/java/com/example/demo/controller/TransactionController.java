package com.example.demo.controller;

import com.example.demo.model.Transaction;
import com.example.demo.service.TransactionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class TransactionController {

    private final TransactionService service;

    public TransactionController(TransactionService service) {
        this.service = service;
    }

    @PostMapping("/transactions")
    public ResponseEntity<Transaction> create(@RequestBody Transaction tx) {
        Transaction created = service.create(tx);
        return ResponseEntity.status(201).body(created);
    }

    @GetMapping("/transactions")
    public ResponseEntity<List<Transaction>> list(
            @RequestParam Long userId,
            @RequestParam(required = false) String month
    ) {
        List<Transaction> list = service.listForUser(userId, month);
        return ResponseEntity.ok(list);
    }
}
