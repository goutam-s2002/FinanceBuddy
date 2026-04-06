package com.finance.financebuddy.controller;

import com.finance.financebuddy.model.Role;
import com.finance.financebuddy.model.Transaction;
import com.finance.financebuddy.model.User;
import com.finance.financebuddy.service.TransactionService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ReportController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping("/reports")
    public String reports(HttpSession session, Model model,
                          @RequestParam(required = false) String startDate,
                          @RequestParam(required = false) String endDate) {
        
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) return "redirect:/login";
        
        // Only Analyst and Admin can access reports
        if (user.getRole() != Role.ANALYST && user.getRole() != Role.ADMIN) {
            return "redirect:/dashboard";
        }
        
        // Date range
        LocalDate start = (startDate != null && !startDate.isEmpty()) ? LocalDate.parse(startDate) : LocalDate.now().withDayOfMonth(1);
        LocalDate end = (endDate != null && !endDate.isEmpty()) ? LocalDate.parse(endDate) : LocalDate.now();
        
        // Get all transactions (Analyst sees all, Admin sees all)
        List<Transaction> allTransactions = transactionService.findAll();
        
        // Filter by date
        List<Transaction> filtered = allTransactions.stream()
            .filter(t -> !t.getDate().isBefore(start) && !t.getDate().isAfter(end))
            .collect(Collectors.toList());
        
        // Income by category
        Map<String, Double> categoryIncome = filtered.stream()
            .filter(t -> "INCOME".equals(t.getType()))
            .collect(Collectors.groupingBy(Transaction::getCategory, 
                     Collectors.summingDouble(Transaction::getAmount)));
        
        // Expense by category
        Map<String, Double> categoryExpense = filtered.stream()
            .filter(t -> "EXPENSE".equals(t.getType()))
            .collect(Collectors.groupingBy(Transaction::getCategory, 
                     Collectors.summingDouble(Transaction::getAmount)));
        
        // Totals
        double totalIncome = categoryIncome.values().stream().mapToDouble(Double::doubleValue).sum();
        double totalExpense = categoryExpense.values().stream().mapToDouble(Double::doubleValue).sum();
        
        // Monthly trends
        List<Map<String, Object>> monthlyTrends = new ArrayList<>();
        for (int i = 5; i >= 0; i--) {
            LocalDate monthStart = LocalDate.now().minusMonths(i).withDayOfMonth(1);
            LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());
            
            double income = allTransactions.stream()
                .filter(t -> "INCOME".equals(t.getType()))
                .filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
                .mapToDouble(Transaction::getAmount).sum();
            
            double expense = allTransactions.stream()
                .filter(t -> "EXPENSE".equals(t.getType()))
                .filter(t -> !t.getDate().isBefore(monthStart) && !t.getDate().isAfter(monthEnd))
                .mapToDouble(Transaction::getAmount).sum();
            
            Map<String, Object> trend = new HashMap<>();
            trend.put("month", monthStart.getMonth().toString().substring(0, 3));
            trend.put("income", income);
            trend.put("expense", expense);
            trend.put("net", income - expense);
            monthlyTrends.add(trend);
        }
        
        // Add to model
        model.addAttribute("categoryIncome", categoryIncome);
        model.addAttribute("categoryExpense", categoryExpense);
        model.addAttribute("totalIncome", totalIncome);
        model.addAttribute("totalExpense", totalExpense);
        model.addAttribute("monthlyTrends", monthlyTrends);
        model.addAttribute("startDate", start);
        model.addAttribute("endDate", end);
        model.addAttribute("user", user);
        
        return "reports";
    }
}