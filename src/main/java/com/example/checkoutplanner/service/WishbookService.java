package com.example.checkoutplanner.service;

import com.example.checkoutplanner.entity.Wishbook;
import com.example.checkoutplanner.repository.EmployeeRepository;
import com.example.checkoutplanner.repository.WishbookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Objects;

import static java.lang.Integer.parseInt;

@Service
public class WishbookService {

    @Autowired
    private WishbookRepository wishbookRepository;

    @Autowired
    private EmployeeRepository employeeRepository;

    public Wishbook setAvailability(Wishbook wishbook) {

        if ( employeeRepository.findAll().stream().anyMatch(
                employee -> Objects.equals(
                        employee.getId(), Long.valueOf(wishbook.getEmployeeId())
                )
        )){
            return wishbookRepository.save(wishbook);
        }else{
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Employee not found");
        }
    }

    public List<Wishbook> getWishbooks() {
        return wishbookRepository.findAll();
    }

    public void deleteWishbook(Long id) {
        wishbookRepository.deleteById(id);
    }
}
