package com.example.checkoutplanner.service;

import com.example.checkoutplanner.entity.Employee;
import com.example.checkoutplanner.repository.EmployeeRepository;
import com.example.checkoutplanner.repository.ScheduleRepository;
import com.example.checkoutplanner.repository.WishbookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

import static java.lang.Long.parseLong;

@Service
public class EmployeeService {

    @Autowired
    private EmployeeRepository employeeRepository;

    @Autowired
    private WishbookRepository wishbookRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    public Employee createEmployee( Employee employee) {

        return employeeRepository.save(employee);
    }

    public List<Employee> getAll() {
        return employeeRepository.findAll();
    }

    public void deleteEmployee(Long id) {

        // Remove the employee from the Schedule
        scheduleRepository.findAll().forEach(schedule -> {
            schedule.getShift_1().remove(id);
            schedule.getShift_2().remove(id);

            scheduleRepository.save(schedule);
        });

        // Remove the employee from the Wishbook
        wishbookRepository.findAll().forEach(wishbook -> {
            if (Objects.equals(parseLong(wishbook.getEmployeeId()), id) ) {
                wishbookRepository.delete(wishbook);
            }
        });

        employeeRepository.deleteById(id);
    }
}
