package com.example.checkoutplanner.repository;

import com.example.checkoutplanner.entity.Wishbook;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WishbookRepository extends JpaRepository<Wishbook, Long> {
    void deleteByEmployeeIdAndDate(String employeeId, String date);
}
