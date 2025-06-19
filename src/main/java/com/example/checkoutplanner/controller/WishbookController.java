package com.example.checkoutplanner.controller;

import com.example.checkoutplanner.entity.Wishbook;
import com.example.checkoutplanner.service.WishbookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/wishbook")
public class WishbookController {

    @Autowired
    private WishbookService wishbookService;

    /**
     * Employee or Admins can set a wishbook for a specific employee
     * @param wishbook Date, ID of employee, preferred shift for the day (SHIFT_1 | SHIFT_2)
     * @return the preferred wishbook
     */
    @PostMapping
    public Wishbook setAvailability(@RequestBody Wishbook wishbook) {
        return wishbookService.setAvailability(wishbook);
    }

    /**
     * Show all the wishbook that are make
     * @return data for those wishbooks
     */
    @GetMapping
    public List<Wishbook> getWishbooks() {
        return wishbookService.getWishbooks();
    }

    /**
     * Delete a specific wishbook by id
     * @param id of the wishbook we want to delete
     */
    @DeleteMapping("/{id}")
    public void deleteWishbook(@PathVariable Long id) {
        wishbookService.deleteWishbook(id);
    }
}
