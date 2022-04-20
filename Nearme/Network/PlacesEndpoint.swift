//
//  PlacesEndpoint.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import Foundation

enum PlacesEndpoint: Endpoint {
    
    case nearbyPlaces(query: String, latitude: Double, longitude: Double, radius: Int, pageToken: String)
    case placeDetails(id: String)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseUrl: String {
        return "maps.googleapis.com"
    }
    
    var path: String {
        switch self {
        case .nearbyPlaces:
            return "/maps/api/place/nearbysearch/json"
        case .placeDetails:
            return "/maps/api/place/details/json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .nearbyPlaces(let query, let latitude, let longitude, let radius, let pageToken):
            return [URLQueryItem(name: "radius", value: String(radius)),
                    URLQueryItem(name: "location", value: String(latitude) + "," + String(longitude)),
                    URLQueryItem(name: "keyword", value: query),
                    URLQueryItem(name: "key", value: Values.API_KEY),
                    URLQueryItem(name: "pagetoken", value: pageToken)
            ]
        case .placeDetails(let id):
            return [URLQueryItem(name: "place_id", value: id),
                    URLQueryItem(name: "fields", value: "address_component,name,rating,formatted_phone_number,photo,opening_hours,formatted_address,website,geometry,place_id,price_level,reviews"),
                    URLQueryItem(name: "key", value: Values.API_KEY)]
        }
    }
        
    var method: String {
        switch self {
        case .nearbyPlaces:
            return "GET"
        case .placeDetails:
            return "GET"
        }
    }
    
    var headers: [String: String] {
        switch self {
        default:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
    
    
}
