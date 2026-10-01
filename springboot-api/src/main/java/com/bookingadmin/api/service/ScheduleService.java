package com.bookingadmin.api.service;

import com.bookingadmin.api.entity.Route;
import com.bookingadmin.api.entity.Schedule;
import com.bookingadmin.api.repository.RouteRepository;
import com.bookingadmin.api.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ScheduleService {

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private RouteRepository routeRepository;

    public List<Schedule> findAll() {
        return scheduleRepository.findAll();
    }

    public Optional<Schedule> findById(Integer id) {
        return scheduleRepository.findById(id);
    }

    public List<Schedule> findByRouteId(Integer routeId) {
        return scheduleRepository.findByRouteId(routeId);
    }

    public List<Schedule> findByStatus(Schedule.Status status) {
        return scheduleRepository.findByStatus(status);
    }

    public Schedule save(Schedule schedule) {
        if (schedule.getRoute() != null && schedule.getRoute().getId() != null) {
            Route route = routeRepository.findById(schedule.getRoute().getId())
                    .orElseThrow(() -> new RuntimeException("Route tidak ditemukan"));
            schedule.setRoute(route);
        }
        return scheduleRepository.save(schedule);
    }

    public Schedule update(Integer id, Schedule updatedSchedule) {
        Schedule existing = scheduleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Schedule tidak ditemukan dengan ID: " + id));

        if (updatedSchedule.getRoute() != null && updatedSchedule.getRoute().getId() != null) {
            Route route = routeRepository.findById(updatedSchedule.getRoute().getId())
                    .orElseThrow(() -> new RuntimeException("Route tidak ditemukan"));
            existing.setRoute(route);
        }
        existing.setDepartureDate(updatedSchedule.getDepartureDate());
        existing.setDepartureTime(updatedSchedule.getDepartureTime());
        existing.setVehicleName(updatedSchedule.getVehicleName());
        existing.setSeatCapacity(updatedSchedule.getSeatCapacity());
        existing.setAvailableSeats(updatedSchedule.getAvailableSeats());
        existing.setStatus(updatedSchedule.getStatus());
        return scheduleRepository.save(existing);
    }

    public void delete(Integer id) {
        if (!scheduleRepository.existsById(id)) {
            throw new RuntimeException("Schedule tidak ditemukan dengan ID: " + id);
        }
        scheduleRepository.deleteById(id);
    }
}
