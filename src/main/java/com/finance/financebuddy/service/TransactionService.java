package com.finance.financebuddy.service;

import com.finance.financebuddy.model.Transaction;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

@Service
public class TransactionService {

	private List<Transaction> transactions = new ArrayList<>();
	private AtomicLong idGenerator = new AtomicLong(1);

	public TransactionService() {
		LocalDate now = LocalDate.now();

		// Transaction for userid 1
		transactions.add(new Transaction(50000.0, "INCOME", "Salary", now.minusDays(10), "Monthly salary", 1L));
		transactions.add(new Transaction(200.0, "EXPENSE", "Tea", now.minusDays(3), "Food", 1L));
		transactions.add(new Transaction(15000.0, "EXPENSE", "Rent", now.minusDays(10), "Monthly rent", 1L));

		// Transaction for userid 2
		transactions.add(new Transaction(30000.0, "INCOME", "Sale", now.minusDays(2), "Old Bike Sale", 2L));
		transactions.add(new Transaction(500.0, "EXPENSE", "Petrol", now.minusDays(1), "Fuel", 2L));

		// Transaction for userid 3 
		transactions.add(new Transaction(1000.0, "EXPENSE", "Shopping", now.minusDays(4), "Clothes", 3L));
		transactions.add(new Transaction(200.0, "EXPENSE", "Burger", now.minusDays(2), "Food", 3L));
		transactions.add(new Transaction(500.0, "INCOME", "Gift", now.minusDays(6), "Birthday gift", 3L));

		for (Transaction t : transactions) {
			t.setId(idGenerator.getAndIncrement());
		}
	}

	public List<Transaction> findAll() {
		return transactions;
	}

	public List<Transaction> findByUserId(Long userId) {
		return transactions.stream().filter(t -> t.getCreatedBy().equals(userId)).collect(Collectors.toList());
	}

	public Transaction findById(Long id) {
		return transactions.stream().filter(t -> t.getId().equals(id)).findFirst().orElse(null);
	}

	public Transaction save(Transaction transaction) {
		transaction.setId(idGenerator.getAndIncrement());
		transaction.setCreatedAt(LocalDate.now());
		transactions.add(transaction);
		return transaction;
	}

	public Transaction update(Long id, Transaction updated) {
		Transaction existing = findById(id);
		if (existing != null) {
			existing.setAmount(updated.getAmount());
			existing.setType(updated.getType());
			existing.setCategory(updated.getCategory());
			existing.setDate(updated.getDate());
			existing.setRemark(updated.getRemark());
		}
		return existing;
	}

	public void delete(Long id) {
		transactions.removeIf(t -> t.getId().equals(id));
	}
	
	public List<Transaction> filter(Long userId, String category, String type, LocalDate startDate, LocalDate endDate) {
	    return transactions.stream()
	        .filter(t -> {
	            if (userId != null && !t.getCreatedBy().equals(userId)) {
	                return false;
	            }
	            if (category != null && !category.isEmpty() && !t.getCategory().equalsIgnoreCase(category)) {
	                return false;
	            }
	            if (type != null && !type.isEmpty() && !t.getType().equalsIgnoreCase(type)) {
	                return false;
	            }
	            if (startDate != null && t.getDate().isBefore(startDate)) {
	                return false;
	            }
	            if (endDate != null && t.getDate().isAfter(endDate)) {
	                return false;
	            }
	            return true;
	        })
	        .collect(Collectors.toList());
	}
}