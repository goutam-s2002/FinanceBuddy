package com.finance.financebuddy.controller;

import com.finance.financebuddy.model.Role;
import com.finance.financebuddy.model.Transaction;
import com.finance.financebuddy.model.User;
import com.finance.financebuddy.service.TransactionService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class TransactionController {

	@Autowired
	private TransactionService transactionService;

	@GetMapping("/transactions")
	public String listTransactions(HttpSession session, Model model, @RequestParam(required = false) String category,
			@RequestParam(required = false) String type, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate) {

		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";

		List<Transaction> transactions;
		if (user.getRole() == Role.ADMIN || user.getRole() == Role.ANALYST) {
			transactions = transactionService.findAll();
		} else {
			transactions = transactionService.findByUserId(user.getId());
		}

		// Category filter
		if (category != null && !category.isEmpty()) {
			transactions = transactions.stream()
					.filter(t -> t.getCategory() != null && t.getCategory().equalsIgnoreCase(category))
					.collect(Collectors.toList());
		}

		// Type filter
		if (type != null && !type.isEmpty()) {
			transactions = transactions.stream().filter(t -> t.getType().equalsIgnoreCase(type))
					.collect(Collectors.toList());
		}

		// Date filter - Start Date
		if (startDate != null && !startDate.isEmpty()) {
			LocalDate start = LocalDate.parse(startDate);
			transactions = transactions.stream().filter(t -> t.getDate() != null && !t.getDate().isBefore(start))
					.collect(Collectors.toList());
		}

		// Date filter - End Date
		if (endDate != null && !endDate.isEmpty()) {
			LocalDate end = LocalDate.parse(endDate);
			transactions = transactions.stream().filter(t -> t.getDate() != null && !t.getDate().isAfter(end))
					.collect(Collectors.toList());
		}

		// Sort by date descending
		transactions.sort((a, b) -> {
			if (a.getDate() == null && b.getDate() == null)
				return 0;
			if (a.getDate() == null)
				return 1;
			if (b.getDate() == null)
				return -1;
			return b.getDate().compareTo(a.getDate());
		});

		model.addAttribute("transactions", transactions);
		model.addAttribute("user", user);
		return "transactions";
	}

	@GetMapping("/transactions/add")
	public String addForm(HttpSession session, Model model) {
		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";
		model.addAttribute("transaction", new Transaction());
		return "add_transaction";
	}

	@PostMapping("/transactions/add")
	public String addTransaction(@ModelAttribute Transaction transaction, HttpSession session) {
		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";
		transaction.setCreatedBy(user.getId());
		transaction.setDate(LocalDate.now());
		transactionService.save(transaction);
		return "redirect:/transactions";
	}

	@GetMapping("/transactions/edit/{id}")
	public String editForm(@PathVariable Long id, HttpSession session, Model model) {
		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";
		Transaction transaction = transactionService.findById(id);
		model.addAttribute("transaction", transaction);
		return "edit_transaction";
	}

	@PostMapping("/transactions/edit/{id}")
	public String editTransaction(@PathVariable Long id, @ModelAttribute Transaction transaction, HttpSession session) {
		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";

		Transaction existing = transactionService.findById(id);
		if (existing == null)
			return "redirect:/transactions?error=Transaction not found";

		// Update only non-null fields
		if (transaction.getAmount() != null)
			existing.setAmount(transaction.getAmount());
		if (transaction.getType() != null && !transaction.getType().isEmpty())
			existing.setType(transaction.getType());
		if (transaction.getCategory() != null && !transaction.getCategory().isEmpty())
			existing.setCategory(transaction.getCategory());
		if (transaction.getDate() != null)
			existing.setDate(transaction.getDate());
		if (transaction.getRemark() != null)
			existing.setRemark(transaction.getRemark());

		transactionService.update(id, existing);
		return "redirect:/transactions";
	}

	@GetMapping("/transactions/delete/{id}")
	public String deleteTransaction(@PathVariable Long id, HttpSession session) {
		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";
		transactionService.delete(id);
		return "redirect:/transactions";
	}
}