package com.finance.financebuddy;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class FinancebuddyApplication {

	public static void main(String[] args) {
		SpringApplication.run(FinancebuddyApplication.class, args);
		System.out.println("Start!");
		System.out.println("Copy snd Paste this Url to Your Browser: http://localhost:8080/login");
	}

}
