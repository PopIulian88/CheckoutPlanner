package com.example.checkoutplanner.service;

import com.example.checkoutplanner.entity.Schedule;
import com.example.checkoutplanner.entity.Wishbook;
import com.example.checkoutplanner.repository.EmployeeRepository;
import com.example.checkoutplanner.repository.ScheduleRepository;
import com.example.checkoutplanner.repository.WishbookRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

import static java.lang.Long.parseLong;

@Service
public class ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private WishbookRepository wishbookRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public List<Schedule> getSchedules() {
        return scheduleRepository.findAll();
    }

    @Transactional
    public Schedule autoPlanningSchedules(String date) {
        // Find if there is already a schedule for the day
        Schedule daySchedule = scheduleRepository.findById(date).orElseGet(() -> {
            Schedule s = new Schedule();
            s.setDate(date);
            s.setShift_1(new ArrayList<>());
            s.setShift_2(new ArrayList<>());
            return s;
        });

        // Verify if the day is full
        if (daySchedule.getShift_1().size() + daySchedule.getShift_2().size() > 3) {
            throw new UnsupportedOperationException("Day already full");
        }

        Map<Long, Set<Wishbook.Shift>> dayOptions =  new HashMap<>();

        // Make a list with all the employee preference for the day
        wishbookRepository.findAll().forEach(wishbook -> {
            if (Objects.equals(wishbook.getDate(), date)) {
                Set<Wishbook.Shift> shifts =
                        dayOptions.computeIfAbsent(parseLong(wishbook.getEmployeeId()),
                                k -> new HashSet<>());

                shifts.add(wishbook.getShift());

                dayOptions.put(parseLong(wishbook.getEmployeeId()), shifts);
            }
        });

        // First, we try to add the employee that has only one choice
        Map<Long, Wishbook.Shift> singleChoiceDayOptions = dayOptions.entrySet().stream()
                .filter(entry -> entry.getValue().size() == 1)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue().iterator().next()
                ));


        singleChoiceDayOptions.forEach((employeeId, shift) -> {

            // Verify if the employee is already programed for this day and if the day is not full
            if (!(daySchedule.getShift_1().contains(employeeId) || daySchedule.getShift_2().contains(employeeId))){

                // Verify if the day is not full and add to the preferred spot
                switch (shift){
                    case SHIFT_1:
                        if(daySchedule.getShift_1().size() < 2) {
                            List<Long> currentIds = daySchedule.getShift_1();
                            currentIds.add(employeeId);

                            daySchedule.setShift_1(currentIds);

                            // remove from wishbook
                            wishbookRepository.deleteByEmployeeIdAndDate(employeeId.toString(), date);
                        }
                        break;
                    case SHIFT_2:
                        if(daySchedule.getShift_2().size() < 2) {
                            List<Long> currentIds = daySchedule.getShift_2();
                            currentIds.add(employeeId);

                            daySchedule.setShift_2(currentIds);

                            // remove from wishbook
                            wishbookRepository.deleteByEmployeeIdAndDate(employeeId.toString(), date);
                        }
                        break;
                }
            }
        });

        // After we complete with the employees thet can in both shifts
        Map<Long, Set<Wishbook.Shift>> twoChoiceDayOptions = dayOptions.entrySet().stream()
                .filter(entry -> entry.getValue().size() == 2)
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));

        twoChoiceDayOptions.forEach((employeeId, shifts) -> {

            // Try with both shifts
            shifts.forEach(shiftOption -> {

                // Verify if the employee is already programed for this day and if the day is not full
                if (!(daySchedule.getShift_1().contains(employeeId) || daySchedule.getShift_2().contains(employeeId))){

                    // Verify if the day is not full and add to the preferred spot
                    switch (shiftOption){
                        case SHIFT_1:
                            if(daySchedule.getShift_1().size() < 2) {
                                List<Long> currentIds = daySchedule.getShift_1();
                                currentIds.add(employeeId);

                                daySchedule.setShift_1(currentIds);

                                // remove from wishbook
                                wishbookRepository.deleteByEmployeeIdAndDate(employeeId.toString(), date);
                            }
                            break;
                        case SHIFT_2:
                            if(daySchedule.getShift_2().size() < 2) {
                                List<Long> currentIds = daySchedule.getShift_2();
                                currentIds.add(employeeId);

                                daySchedule.setShift_2(currentIds);

                                // remove from wishbook
                                wishbookRepository.deleteByEmployeeIdAndDate(employeeId.toString(), date);
                            }
                            break;
                    }
                }

            });
        });

        return scheduleRepository.save(daySchedule);
    }

    public Schedule planningSchedule(Wishbook wishbook) {

//      Verify if the Employee exists
        if (!employeeRepository.existsById(parseLong(wishbook.getEmployeeId()))){
            throw  new IllegalArgumentException("Employee not found");
        }

        List<Schedule> schedules = scheduleRepository.getSchedulesByDate(wishbook.getDate());
        Schedule currentDayScheduleDate;

        //  Verify if the schedule exists, if not init one
        if (schedules.isEmpty()) {
            currentDayScheduleDate = new Schedule();
            currentDayScheduleDate.setDate(wishbook.getDate());
            currentDayScheduleDate.setShift_1(new ArrayList<>());
            currentDayScheduleDate.setShift_2(new ArrayList<>());
        } else {
            currentDayScheduleDate = schedules.getFirst();
        }

        //  Try to fit the employee on the preferred spot
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

        // after adding to schedule, remove from Wishbook
        wishbookRepository.deleteById(wishbook.getId());

        return scheduleRepository.save(currentDayScheduleDate);
    }

    public void deleteSchedules(String date) {
        scheduleRepository.deleteById(date);
    }
}
