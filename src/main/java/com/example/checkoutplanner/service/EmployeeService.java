package com.example.checkoutplanner.service;

import com.example.checkoutplanner.entity.Employee;
import com.example.checkoutplanner.repository.EmployeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    public Employee createEmployee( Employee employee) {

        return employeeRepository.save(employee);
    }

    public List<Employee> getAll() {
        return employeeRepository.findAll();
    }
}
