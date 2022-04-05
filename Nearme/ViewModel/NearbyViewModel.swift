//
//  NearbyViewModel.swift
//  Nearme
//
//  Created by Giovanni Corte on 25/10/2021.
//

import Foundation
import CoreLocation
import Combine
import SwiftUI

class NearbyViewModel: ObservableObject {
    
    @Published var places: [Place] = [Place]()
    @Published var loading: Bool = false
    @Published var error: LocationError = .none
    
    @Published var positions: [CGFloat] = [0.0]
    
    private var query: String = ""
    private var token: String = ""
    
    var locationManager: LocationManager
    var lastLocation: LatLng?
    
    init(locationManager: LocationManager = .init()) {
        self.locationManager = locationManager
    }
    
    func updatePosition(position: CGFloat) -> Void {
        if (positions.count >= 3) {
            positions.removeFirst()
        }
        positions.append(position)
    }
    
    func loadMorePlaces(currentItem place: Place) {
        let thresholdIndex = places.index(places.endIndex, offsetBy: -1)
        if places.firstIndex(where: { $0.placeId == place.placeId }) == thresholdIndex {
            loadPlaces(query: query)
        }
    }
    
    func loadPlaces(query: String) {
        self.query = query
        guard !loading else {
            return
        }
        
        loading = true
        
        guard lastLocation != nil else {
            locationManager.getLocation { (result : Result<LatLng, LocationError>) in
                switch result {
                case .success(let location):
                    self.lastLocation = location
                    self.loading = true
                    self.fetchPlaces(latitude: self.lastLocation!.latitude, longitude: self.lastLocation!.longitude)
                case .failure(let error):
                    self.loading = false
                    self.error = error
                }
            }
            return
        }
        fetchPlaces(latitude: lastLocation!.latitude, longitude: lastLocation!.longitude)
    }
    
    private func fetchPlaces(latitude: Double, longitude: Double) {
        NetworkEngine.request(
            endpoint: PlacesEndpoint.nearbyPlaces(query: query, latitude: latitude, longitude: longitude, radius: 5000, pageToken: token)) {
            (result : Result<NearbyResponse, Error>) in
            switch result {
            case .success(let response):
                if (response.results!.count == 0 && self.token == "") {
                    self.loading = false
                    self.error = .empty
                    return
                }
                self.token = response.token
                self.loading = false
                self.places.append(contentsOf: response.results!)
            case .failure(let error):
                print(error)
                self.error = .unknown
            }
        }
    }
    
}

