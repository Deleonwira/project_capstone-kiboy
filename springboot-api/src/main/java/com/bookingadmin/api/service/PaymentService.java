package com.bookingadmin.api.service;

import com.bookingadmin.api.entity.Booking;
import com.bookingadmin.api.entity.Payment;
import com.bookingadmin.api.repository.BookingRepository;
import com.bookingadmin.api.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private BookingRepository bookingRepository;

    public List<Payment> findAll() {
        return paymentRepository.findAll();
    }

    public Optional<Payment> findById(Integer id) {
        return paymentRepository.findById(id);
    }

    public List<Payment> findByBookingId(Integer bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    public List<Payment> findByStatus(Payment.Status status) {
        return paymentRepository.findByStatus(status);
    }

    public Payment save(Payment payment) {
        if (payment.getBooking() != null && payment.getBooking().getId() != null) {
            Booking booking = bookingRepository.findById(payment.getBooking().getId())
                    .orElseThrow(() -> new RuntimeException("Booking tidak ditemukan"));
            payment.setBooking(booking);
        }
        if (payment.getStatus() == Payment.Status.paid && payment.getPaidAt() == null) {
            payment.setPaidAt(LocalDateTime.now());
        }
        return paymentRepository.save(payment);
    }

    public Payment update(Integer id, Payment updatedPayment) {
        Payment existing = paymentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Payment tidak ditemukan dengan ID: " + id));
        existing.setAmount(updatedPayment.getAmount());
        existing.setPaymentMethod(updatedPayment.getPaymentMethod());
        existing.setReferenceNumber(updatedPayment.getReferenceNumber());
        existing.setStatus(updatedPayment.getStatus());
        if (updatedPayment.getStatus() == Payment.Status.paid && existing.getPaidAt() == null) {
            existing.setPaidAt(LocalDateTime.now());
        }
        return paymentRepository.save(existing);
    }

    public void delete(Integer id) {
        if (!paymentRepository.existsById(id)) {
            throw new RuntimeException("Payment tidak ditemukan dengan ID: " + id);
        }
        paymentRepository.deleteById(id);
    }
}
