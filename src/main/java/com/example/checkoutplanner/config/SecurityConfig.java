package com.example.checkoutplanner.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableMethodSecurity // To can use @PreAuthorize in controllers
public class SecurityConfig {

    @Bean
    public UserDetailsService userDetailsService() {
        var userDetailsManager = new InMemoryUserDetailsManager();

        // Employee account for test
        var employee = User.withUsername("employee")
                .password("{noop}password")
                .roles("EMPLOYEE")
                .build();

        // Admin account for test
        var admin = User.withUsername("admin")
                .password("{noop}adminpass")
                .roles("ADMIN")
                .build();

        userDetailsManager.createUser(employee);
        userDetailsManager.createUser(admin);

        return userDetailsManager;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/employees/**").authenticated()
                        .requestMatchers("/wishbook/**").hasAnyRole("EMPLOYEE", "ADMIN")
                        .requestMatchers("/schedule/**").authenticated()
                        .anyRequest().permitAll()
                )
                .httpBasic(Customizer.withDefaults());

        return http.build();
    }
}
