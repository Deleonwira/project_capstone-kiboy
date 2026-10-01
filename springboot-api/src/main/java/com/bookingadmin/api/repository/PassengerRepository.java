package com.bookingadmin.api.repository;

import com.bookingadmin.api.entity.Passenger;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PassengerRepository extends JpaRepository<Passenger, Integer> {
    List<Passenger> findByNameContainingIgnoreCase(String name);
    boolean existsByIdNumber(String idNumber);
}
