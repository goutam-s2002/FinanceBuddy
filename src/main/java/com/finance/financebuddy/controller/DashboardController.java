package com.finance.financebuddy.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class DashboardController {

	@Autowired
	private TransactionService transactionService;

	@GetMapping("/dashboard")
	public String dashboard(HttpSession session, Model model, @RequestParam(required = false) String startDate,
			@RequestParam(required = false) String endDate) {

		User user = (User) session.getAttribute("loggedInUser");
		if (user == null)
			return "redirect:/login";

		// Current month ka pehla aur aakhri din
		LocalDate now = LocalDate.now();
		LocalDate start = startDate != null ? LocalDate.parse(startDate) : now.withDayOfMonth(1);
		LocalDate end = endDate != null ? LocalDate.parse(endDate) : now.withDayOfMonth(now.lengthOfMonth());

		// Get all transactions
		List<Transaction> allTransactions = transactionService.findAll();

		// Filter by role and date
		List<Transaction> filtered = allTransactions.stream().filter(t -> {
			// Role filter
			if (user.getRole() != Role.ADMIN) {
				if (!t.getCreatedBy().equals(user.getId()))
					return false;
			}
			// Date filter
			if (t.getDate().isBefore(start))
				return false;
			if (t.getDate().isAfter(end))
				return false;
			return true;
		}).collect(Collectors.toList());

		// Calculate totals
		double totalIncome = filtered.stream().filter(t -> "INCOME".equals(t.getType()))
				.mapToDouble(Transaction::getAmount).sum();
		double totalExpense = filtered.stream().filter(t -> "EXPENSE".equals(t.getType()))
				.mapToDouble(Transaction::getAmount).sum();
		double netBalance = totalIncome - totalExpense;

		// Recent transactions (last 5)
		List<Transaction> recent = filtered.stream().sorted((a, b) -> b.getDate().compareTo(a.getDate()))
				.collect(Collectors.toList());

		// Category wise data for bar chart
		Map<String, Double> incomeByCat = filtered.stream().filter(t -> "INCOME".equals(t.getType())).collect(
				Collectors.groupingBy(Transaction::getCategory, Collectors.summingDouble(Transaction::getAmount)));

		Map<String, Double> expenseByCat = filtered.stream().filter(t -> "EXPENSE".equals(t.getType())).collect(
				Collectors.groupingBy(Transaction::getCategory, Collectors.summingDouble(Transaction::getAmount)));

		// All categories for bar chart
		Set<String> allCats = new HashSet<>();
		allCats.addAll(incomeByCat.keySet());
		allCats.addAll(expenseByCat.keySet());
		List<String> categories = new ArrayList<>(allCats);

		List<Double> incomeData = new ArrayList<>();
		List<Double> expenseData = new ArrayList<>();
		for (String cat : categories) {
			incomeData.add(incomeByCat.getOrDefault(cat, 0.0));
			expenseData.add(expenseByCat.getOrDefault(cat, 0.0));
		}

		// ========== PIE CHART DATA (Expense Distribution) ==========
		List<String> pieLabels = new ArrayList<>();
		List<Double> pieValues = new ArrayList<>();

		for (Map.Entry<String, Double> entry : expenseByCat.entrySet()) {
			pieLabels.add(entry.getKey());
			pieValues.add(entry.getValue());
		}

		// Monthly trends for line chart
		List<String> months = new ArrayList<>();
		List<Double> monthIncome = new ArrayList<>();
		List<Double> monthExpense = new ArrayList<>();

		for (int i = 5; i >= 0; i--) {
			LocalDate monthStart = LocalDate.now().minusMonths(i).withDayOfMonth(1);
			LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());
			months.add(monthStart.getMonth().toString().substring(0, 3));

			double inc = filtered.stream().filter(t -> "INCOME".equals(t.getType()))
					.filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
					.mapToDouble(Transaction::getAmount).sum();

			double exp = filtered.stream().filter(t -> "EXPENSE".equals(t.getType()))
					.filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
					.mapToDouble(Transaction::getAmount).sum();

			monthIncome.add(inc);
			monthExpense.add(exp);
		}

		// Create ObjectMapper for JSON conversion
		ObjectMapper mapper = new ObjectMapper();

		try {
			// Add to model with JSON format
			model.addAttribute("totalIncome", totalIncome);
			model.addAttribute("totalExpense", totalExpense);
			model.addAttribute("netBalance", netBalance);
			model.addAttribute("recent", recent);

			// JSON data for charts
			model.addAttribute("categoriesJson", mapper.writeValueAsString(categories));
			model.addAttribute("incomeDataJson", mapper.writeValueAsString(incomeData));
			model.addAttribute("expenseDataJson", mapper.writeValueAsString(expenseData));
			model.addAttribute("pieLabelsJson", mapper.writeValueAsString(pieLabels));
			model.addAttribute("pieValuesJson", mapper.writeValueAsString(pieValues));
			model.addAttribute("monthsJson", mapper.writeValueAsString(months));
			model.addAttribute("monthIncomeJson", mapper.writeValueAsString(monthIncome));
			model.addAttribute("monthExpenseJson", mapper.writeValueAsString(monthExpense));

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("startDate", start);
		model.addAttribute("endDate", end);
		model.addAttribute("user", user);

		return "dashboard";
	}
}