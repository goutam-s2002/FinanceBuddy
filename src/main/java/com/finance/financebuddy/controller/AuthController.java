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
public class AuthController {
    
    @Autowired
    private UserService userService;
    
    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password,
                        HttpSession session, Model model) {
        if (userService.authenticate(username, password)) {
            session.setAttribute("loggedInUser", userService.findByUsername(username));
            return "redirect:/dashboard";
        }
        model.addAttribute("error", "Invalid credentials");
        return "login";
    }
    
    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }
    
    @PostMapping("/register")
    public String register(@RequestParam String username, @RequestParam String email,
                           @RequestParam String password, Model model) {
        if (userService.findByUsername(username) != null) {
            model.addAttribute("error", "Username exists");
            return "register";
        }
        User user = new User(username, password, email, Role.USER);
        userService.save(user);
        return "redirect:/login";
    }
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}