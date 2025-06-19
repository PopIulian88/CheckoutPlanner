package com.example.checkoutplanner.service;

import com.example.checkoutplanner.entity.Schedule;
import com.example.checkoutplanner.entity.Wishbook;
import com.example.checkoutplanner.repository.EmployeeRepository;
import com.example.checkoutplanner.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static java.lang.Long.parseLong;

@Service
public class ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Schedule> getSchedules() {
        return scheduleRepository.findAll();
    }

    public Schedule autoPlanningSchedules(String date) {
//        TODO: Implement this
        throw  new UnsupportedOperationException("Not supported yet.");
    }

    public Schedule planningSchedule(Wishbook wishbook) {

//      Verify if the Employee exists
        if (!employeeRepository.existsById(parseLong(wishbook.getEmployeeId()))){
            throw  new IllegalArgumentException("Employee not found");
        }

        List<Schedule> schedules = scheduleRepository.getSchedulesByDate(wishbook.getDate());
        Schedule currentDayScheduleDate;

        ///  Verify if the schedule exists, if not init one
        if (schedules.isEmpty()) {
            currentDayScheduleDate = new Schedule();
            currentDayScheduleDate.setDate(wishbook.getDate());
            currentDayScheduleDate.setShift_1(new ArrayList<>());
            currentDayScheduleDate.setShift_2(new ArrayList<>());
        } else {
            currentDayScheduleDate = schedules.getFirst();
        }

        ///  Try to fit the employee on the preferred spot
        switch (wishbook.getShift()) {
            case SHIFT_1:
                //Verify if is not already set for the day
                if (currentDayScheduleDate.getShift_1().toArray().length < 2 &&
                        !(currentDayScheduleDate.getShift_1().contains(parseLong(wishbook.getEmployeeId())) ||
                                currentDayScheduleDate.getShift_2().contains(parseLong(wishbook.getEmployeeId()))
                        )
                ) {
                    List<Long> currentIds = currentDayScheduleDate.getShift_1();
                    currentIds.add(parseLong(wishbook.getEmployeeId()));

                    currentDayScheduleDate.setShift_1(currentIds);
                }else {
                    throw new UnsupportedOperationException("This employee is already set for this day");
                }
                break;
            case SHIFT_2:
                //Verify if is not already set for the day
                if (currentDayScheduleDate.getShift_2().toArray().length < 2 &&
                        !(currentDayScheduleDate.getShift_1().contains(parseLong(wishbook.getEmployeeId())) ||
                                currentDayScheduleDate.getShift_2().contains(parseLong(wishbook.getEmployeeId()))
                        )
                ) {
                    List<Long> currentIds = currentDayScheduleDate.getShift_2();
                    currentIds.add(parseLong(wishbook.getEmployeeId()));

                    currentDayScheduleDate.setShift_2(currentIds);
                }else {
                    throw new UnsupportedOperationException("This employee is already set for this day");
                }
                break;
            default:
                throw new UnsupportedOperationException("No correct shifts are selected");
        }

        return scheduleRepository.save(currentDayScheduleDate);
    }

    public void deleteSchedules(String date) {
        scheduleRepository.deleteById(date);
    }
}
