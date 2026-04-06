package com.finance.financebuddy.service;

import com.finance.financebuddy.model.Role;
import com.finance.financebuddy.model.User;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@Service
public class UserService {
    
    private List<User> users = new ArrayList<>();
    private AtomicLong idGenerator = new AtomicLong(1);
    
    public UserService() {
        // Admin
        User admin = new User("admin", "admin123", "admin@123.com", Role.ADMIN);
        admin.setId(idGenerator.getAndIncrement());
        users.add(admin);
        
        // Analyst
        User analyst = new User("analyst", "analyst123", "analyst@123.com", Role.ANALYST);
        analyst.setId(idGenerator.getAndIncrement());
        users.add(analyst);
        
        // User
        User user = new User("user", "user123", "user@123.com", Role.USER);
        user.setId(idGenerator.getAndIncrement());
        users.add(user);
    }
    
    public List<User> findAll() { return users; }
    
    public User findById(Long id) {
        return users.stream().filter(u -> u.getId().equals(id)).findFirst().orElse(null);
    }
    
    public User findByUsername(String username) {
        return users.stream().filter(u -> u.getUsername().equals(username)).findFirst().orElse(null);
    }
    
    public User findByEmail(String email) {
        return users.stream().filter(u -> u.getEmail().equals(email)).findFirst().orElse(null);
    }
    
    public User save(User user) {
        user.setId(idGenerator.getAndIncrement());
        users.add(user);
        return user;
    }
    
    public User updateRole(Long id, Role role) {
        User user = findById(id);
        if (user != null) user.setRole(role);
        return user;
    }
    
    public User updateStatus(Long id, String status) {
        User user = findById(id);
        if (user != null) user.setStatus(status);
        return user;
    }
    
    public boolean authenticate(String username, String password) {
        User user = findByUsername(username);
        return user != null && user.getPassword().equals(password) && user.getStatus().equals("ACTIVE");
    }
}