package com.finance.financebuddy.service;

import com.finance.financebuddy.model.Role;
import com.finance.financebuddy.model.Transaction;
import com.finance.financebuddy.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class DashboardService {

	@Autowired
	private TransactionService transactionService;

	public Map<String, Object> getDashboardSummary(User loggedInUser, LocalDate startDate, LocalDate endDate) {
		Map<String, Object> summary = new HashMap<>();

		List<Transaction> allTransactions = transactionService.findAll();

		// Filter by role and date
		List<Transaction> filtered = allTransactions.stream().filter(t -> {
			if (loggedInUser.getRole() != Role.ADMIN) {
				if (!t.getCreatedBy().equals(loggedInUser.getId()))
					return false;
			}
			if (startDate != null && t.getDate().isBefore(startDate))
				return false;
			if (endDate != null && t.getDate().isAfter(endDate))
				return false;
			return true;
		}).collect(Collectors.toList());

		// Basic Stats
		double totalIncome = filtered.stream().filter(t -> "INCOME".equals(t.getType()))
				.mapToDouble(Transaction::getAmount).sum();
		double totalExpense = filtered.stream().filter(t -> "EXPENSE".equals(t.getType()))
				.mapToDouble(Transaction::getAmount).sum();

		// ========== CHART 1: Category Wise Data for Bar Chart ==========
		Map<String, Double> incomeByCategory = filtered.stream().filter(t -> "INCOME".equals(t.getType())).collect(
				Collectors.groupingBy(Transaction::getCategory, Collectors.summingDouble(Transaction::getAmount)));

		Map<String, Double> expenseByCategory = filtered.stream().filter(t -> "EXPENSE".equals(t.getType())).collect(
				Collectors.groupingBy(Transaction::getCategory, Collectors.summingDouble(Transaction::getAmount)));

		// All unique categories
		Set<String> allCategories = new HashSet<>();
		allCategories.addAll(incomeByCategory.keySet());
		allCategories.addAll(expenseByCategory.keySet());

		List<String> categoryLabels = new ArrayList<>(allCategories);
		List<Double> incomeData = new ArrayList<>();
		List<Double> expenseData = new ArrayList<>();

		for (String cat : categoryLabels) {
			incomeData.add(incomeByCategory.getOrDefault(cat, 0.0));
			expenseData.add(expenseByCategory.getOrDefault(cat, 0.0));
		}

		// ========== CHART 2: Monthly Trends for Line Chart ==========
		List<String> monthLabels = new ArrayList<>();
		List<Double> monthlyIncome = new ArrayList<>();
		List<Double> monthlyExpense = new ArrayList<>();

		for (int i = 5; i >= 0; i--) {
			LocalDate monthStart = LocalDate.now().minusMonths(i).withDayOfMonth(1);
			LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());
			monthLabels.add(monthStart.format(DateTimeFormatter.ofPattern("MMM")));

			double inc = filtered.stream().filter(t -> "INCOME".equals(t.getType()))
					.filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
					.mapToDouble(Transaction::getAmount).sum();

			double exp = filtered.stream().filter(t -> "EXPENSE".equals(t.getType()))
					.filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
					.mapToDouble(Transaction::getAmount).sum();

			monthlyIncome.add(inc);
			monthlyExpense.add(exp);
		}

		// ========== CHART 3: Pie Chart Data (Expense Distribution) ==========
		List<Map<String, Object>> pieData = new ArrayList<>();
		for (Map.Entry<String, Double> entry : expenseByCategory.entrySet()) {
			Map<String, Object> item = new HashMap<>();
			item.put("category", entry.getKey());
			item.put("amount", entry.getValue());
			pieData.add(item);
		}

		// Put everything in summary
		summary.put("totalIncome", totalIncome);
		summary.put("totalExpense", totalExpense);
		summary.put("netBalance", totalIncome - totalExpense);
		summary.put("recentTransactions", filtered.stream().sorted((a, b) -> b.getDate().compareTo(a.getDate()))
				.limit(10).collect(Collectors.toList()));

		// Chart Data
		summary.put("categoryLabels", categoryLabels);
		summary.put("incomeData", incomeData);
		summary.put("expenseData", expenseData);
		summary.put("monthLabels", monthLabels);
		summary.put("monthlyIncome", monthlyIncome);
		summary.put("monthlyExpense", monthlyExpense);
		summary.put("pieData", pieData);

		return summary;
	}
}