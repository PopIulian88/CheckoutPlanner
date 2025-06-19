package com.example.checkoutplanner.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

import java.util.List;

@Entity
@Data
public class Schedule {

    @Id
    private String date;

    private List<Long> shift_1;
    private List<Long> shift_2;
}
