package com.bookingadmin.api.repository;

import com.bookingadmin.api.entity.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer> {
    List<Payment> findByBookingId(Integer bookingId);
    List<Payment> findByStatus(Payment.Status status);
}
