package com.finance.financebuddy.model;

import java.time.LocalDate;

public class Transaction {
    private Long id;
    private Double amount;
    private String type;  
    private String category;
    private LocalDate date;
    private String remark;
    private Long createdBy;
    private LocalDate createdAt;
    
    public Transaction() {}
    
    public Transaction(Double amount, String type, String category, LocalDate date, String remark, Long createdBy) {
        this.amount = amount;
        this.type = type;
        this.category = category;
        this.date = date;
        this.remark = remark;
        this.createdBy = createdBy;
        this.createdAt = LocalDate.now();
    }
    
   
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
    
    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
    
    public LocalDate getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDate createdAt) { this.createdAt = createdAt; }
}