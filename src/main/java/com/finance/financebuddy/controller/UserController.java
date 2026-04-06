package com.finance.financebuddy.controller;

import com.finance.financebuddy.model.Role;
import com.finance.financebuddy.model.User;
import com.finance.financebuddy.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class UserController {

	@Autowired
	private UserService userService;

	@GetMapping("/users")
	public String listUsers(HttpSession session, Model model) {
		User loggedIn = (User) session.getAttribute("loggedInUser");
		if (loggedIn == null || loggedIn.getRole() != Role.ADMIN)
			return "redirect:/dashboard";
		model.addAttribute("users", userService.findAll());
		model.addAttribute("user", loggedIn);

		return "users";

	}

	@PostMapping("/users/add")
	public String addUser(@RequestParam String username, @RequestParam String email, @RequestParam String password,
			@RequestParam Role role) {
		User user = new User(username, password, email, role);
		userService.save(user);
		return "redirect:/users";
	}

	@PostMapping("/users/edit/{id}")
	public String editUser(@PathVariable Long id, @RequestParam Role role, @RequestParam String status) {
		userService.updateRole(id, role);
		userService.updateStatus(id, status);
		return "redirect:/users";
	}
}