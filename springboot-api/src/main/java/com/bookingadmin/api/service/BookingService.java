package com.bookingadmin.api.service;

import com.bookingadmin.api.entity.Booking;
import com.bookingadmin.api.entity.Passenger;
import com.bookingadmin.api.entity.Schedule;
import com.bookingadmin.api.entity.User;
import com.bookingadmin.api.repository.BookingRepository;
import com.bookingadmin.api.repository.PassengerRepository;
import com.bookingadmin.api.repository.ScheduleRepository;
import com.bookingadmin.api.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private PassengerRepository passengerRepository;

    @Autowired
    private UserRepository userRepository;

    public List<Booking> findAll() {
        return bookingRepository.findAll();
    }

    public Optional<Booking> findById(Integer id) {
        return bookingRepository.findById(id);
    }

    public Optional<Booking> findByBookingCode(String code) {
        return bookingRepository.findByBookingCode(code);
    }

    public List<Booking> findByUserId(Integer userId) {
        return bookingRepository.findByUserId(userId);
    }

    public List<Booking> findByStatus(Booking.Status status) {
        return bookingRepository.findByStatus(status);
    }

    public Booking save(Booking booking) {
        String code = "BK-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        booking.setBookingCode(code);

        if (booking.getSchedule() != null && booking.getSchedule().getId() != null) {
            Schedule schedule = scheduleRepository.findById(booking.getSchedule().getId())
                    .orElseThrow(() -> new RuntimeException("Schedule tidak ditemukan"));
            booking.setSchedule(schedule);
        }

        if (booking.getPassenger() != null && booking.getPassenger().getId() != null) {
            Passenger passenger = passengerRepository.findById(booking.getPassenger().getId())
                    .orElseThrow(() -> new RuntimeException("Passenger tidak ditemukan"));
            booking.setPassenger(passenger);
        }

        if (booking.getUser() != null && booking.getUser().getId() != null) {
            User user = userRepository.findById(booking.getUser().getId())
                    .orElseThrow(() -> new RuntimeException("User tidak ditemukan"));
            booking.setUser(user);
        }

        return bookingRepository.save(booking);
    }

    public Booking update(Integer id, Booking updatedBooking) {
        Booking existing = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking tidak ditemukan dengan ID: " + id));
        existing.setSeatCount(updatedBooking.getSeatCount());
        existing.setTotalPrice(updatedBooking.getTotalPrice());
        existing.setStatus(updatedBooking.getStatus());
        return bookingRepository.save(existing);
    }

    public void delete(Integer id) {
        if (!bookingRepository.existsById(id)) {
            throw new RuntimeException("Booking tidak ditemukan dengan ID: " + id);
        }
        bookingRepository.deleteById(id);
    }
}
