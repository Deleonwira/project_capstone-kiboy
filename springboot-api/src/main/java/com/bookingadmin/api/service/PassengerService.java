package com.bookingadmin.api.service;

import com.bookingadmin.api.entity.Passenger;
import com.bookingadmin.api.repository.PassengerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PassengerService {

    @Autowired
    private PassengerRepository passengerRepository;

    public List<Passenger> findAll() {
        return passengerRepository.findAll();
    }

    public Optional<Passenger> findById(Integer id) {
        return passengerRepository.findById(id);
    }

    public List<Passenger> searchByName(String name) {
        return passengerRepository.findByNameContainingIgnoreCase(name);
    }

    public Passenger save(Passenger passenger) {
        return passengerRepository.save(passenger);
    }

    public Passenger update(Integer id, Passenger updatedPassenger) {
        Passenger existing = passengerRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Passenger tidak ditemukan dengan ID: " + id));
        existing.setName(updatedPassenger.getName());
        existing.setPhone(updatedPassenger.getPhone());
        existing.setEmail(updatedPassenger.getEmail());
        existing.setIdNumber(updatedPassenger.getIdNumber());
        existing.setGender(updatedPassenger.getGender());
        existing.setAddress(updatedPassenger.getAddress());
        return passengerRepository.save(existing);
    }

    public void delete(Integer id) {
        if (!passengerRepository.existsById(id)) {
            throw new RuntimeException("Passenger tidak ditemukan dengan ID: " + id);
        }
        passengerRepository.deleteById(id);
    }
}
