package com.example.demo.service;

import com.example.demo.model.Transaction;
import com.example.demo.repository.TransactionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Service
public class TransactionService {

    private final TransactionRepository repo;

    public TransactionService(TransactionRepository repo) {
        this.repo = repo;
    }

    public Transaction create(Transaction tx) {
        if (tx.getDate() == null) {
            tx.setDate(LocalDate.now());
        }
        return repo.save(tx);
    }

    public List<Transaction> listForUser(Long userId, String month) {
        if (month == null || month.isBlank()) {
            return repo.findByUserId(userId);
        }
        YearMonth ym = YearMonth.parse(month); // "YYYY-MM"
        LocalDate start = ym.atDay(1);
        LocalDate end = ym.atEndOfMonth();
        return repo.findByUserIdAndDateBetween(userId, start, end);
    }
}
