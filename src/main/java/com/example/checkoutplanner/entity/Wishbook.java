package com.example.checkoutplanner.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Wishbook {

    public enum Shift {
        SHIFT_1,
        SHIFT_2
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String date;
    private String employeeId;

    @Enumerated(EnumType.STRING)
    private Shift shift;
}
