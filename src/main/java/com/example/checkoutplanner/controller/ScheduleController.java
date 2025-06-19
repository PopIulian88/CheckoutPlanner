package com.example.checkoutplanner.controller;

import com.example.checkoutplanner.entity.Schedule;
import com.example.checkoutplanner.entity.Wishbook;
import com.example.checkoutplanner.service.ScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/schedule")
public class ScheduleController {

    @Autowired
    private ScheduleService scheduleService;

    /**
     * Show all the schedule dates
     * @return Data, Shift_1, Shift_2
     */
    @GetMapping
    public List<Schedule> getSchedules() {
        return scheduleService.getSchedules();
    }

    /**
     * Admin-only
     * Automatic plan the schedules for a specific date.
     * Automatic gets the preferred dates for the employees, but the employee doesn't put the schedule in time,
     * they will be automatically arranged
     *
     * @param date the date we won to schedule
     * @return The scheduled date with the completed shifts
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/planning/auto/{date}")
    public Schedule autoPlanningSchedules(@PathVariable String date) {
        return scheduleService.autoPlanningSchedules(date);
    }

    /**
     * Admin-only
     * Admin can manually add employees to the schedule if the slots are available
     * @param wishbook include date when the employee can work, and the shift we want, along with the employee_id
     * @return Part of the schedule where the employee was arranged
     */
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/planning")
    public Schedule planningSchedule(@RequestBody Wishbook wishbook) {
        return scheduleService.planningSchedule(wishbook);
    }

    /**
     * Delete the schedule for a specific day
     * @param date the date of the day you wan to reset
     */
    @PreAuthorize("hasRole('ADMIN')")
    @DeleteMapping("/planning/{date}")
    public void deleteSchedules(@PathVariable String date) {
        scheduleService.deleteSchedules(date);
    }

}
