package com.bookingadmin.api.service;

import com.bookingadmin.api.entity.Route;
import com.bookingadmin.api.repository.RouteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RouteService {

    @Autowired
    private RouteRepository routeRepository;

    public List<Route> findAll() {
        return routeRepository.findAll();
    }

    public Optional<Route> findById(Integer id) {
        return routeRepository.findById(id);
    }

    public List<Route> search(String keyword) {
        return routeRepository.findByOriginContainingIgnoreCaseOrDestinationContainingIgnoreCase(keyword, keyword);
    }

    public Route save(Route route) {
        return routeRepository.save(route);
    }

    public Route update(Integer id, Route updatedRoute) {
        Route existing = routeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Route tidak ditemukan dengan ID: " + id));
        existing.setOrigin(updatedRoute.getOrigin());
        existing.setDestination(updatedRoute.getDestination());
        existing.setDistanceKm(updatedRoute.getDistanceKm());
        existing.setBasePrice(updatedRoute.getBasePrice());
        return routeRepository.save(existing);
    }

    public void delete(Integer id) {
        if (!routeRepository.existsById(id)) {
            throw new RuntimeException("Route tidak ditemukan dengan ID: " + id);
        }
        routeRepository.deleteById(id);
    }
}
