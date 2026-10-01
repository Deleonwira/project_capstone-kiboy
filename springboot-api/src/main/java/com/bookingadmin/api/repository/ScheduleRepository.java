package com.bookingadmin.api.repository;

import com.bookingadmin.api.entity.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Integer> {
    List<Schedule> findByRouteId(Integer routeId);
    List<Schedule> findByStatus(Schedule.Status status);
}
