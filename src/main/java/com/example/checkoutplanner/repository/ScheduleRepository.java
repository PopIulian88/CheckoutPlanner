package com.example.checkoutplanner.repository;

import com.example.checkoutplanner.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, String> {
    List<Schedule> getSchedulesByDate(String date);
}
