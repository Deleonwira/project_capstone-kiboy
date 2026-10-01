package com.bookingadmin.api.repository;

import com.bookingadmin.api.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {
    Optional<Booking> findByBookingCode(String bookingCode);
    List<Booking> findByUserId(Integer userId);
    List<Booking> findByStatus(Booking.Status status);
    boolean existsByBookingCode(String bookingCode);
}
