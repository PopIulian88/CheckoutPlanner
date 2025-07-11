package com.example.checkoutplanner.controller;

import com.example.checkoutplanner.entity.Employee;
import com.example.checkoutplanner.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/employees")
public class EmployeeController {
    @Autowired
    private EmployeeService employeeService;

    /**
     * Create an employee
     * @param employee name of the employee
     * @return data for the new employee
     */
    @PostMapping
    public Employee createEmployee(@RequestBody Employee employee) {
        return employeeService.createEmployee(employee);
    }

    /**
     * Show all the employees
     * @return All the employees
     */
    @GetMapping
    public List<Employee> getAll() {
        return employeeService.getAll();
    }

    /**
     * Remove an existing employee
     * @param id of the employee we want to fire
     */
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/{id}")
    public void deleteEmployee(@PathVariable Long id) {
        employeeService.deleteEmployee(id);
    }
}
