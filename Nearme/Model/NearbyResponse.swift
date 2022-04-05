//
//  NearbyResponse.swift
//  Nearme
//
//  Created by Giovanni Corte on 25/10/2021.
//

import Foundation

struct NearbyResponse : Codable {
    let results : [Place]?
    let status : String?
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case status = "status"
        case token = "next_page_token"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decodeIfPresent([Place].self, forKey: .results)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        token = try values.decodeIfPresent(String.self, forKey: .token) ?? ""
    }
    
}

struct Place : Codable, Identifiable, Equatable {

    let id = UUID()
    
    let businessStatus : String
    let geometry : Geometry
    let icon : String
    let iconBackgroundColor : String
    let iconMaskBaseUri : String
    let name : String
    let openingHours : OpeningHour
    let photos : [Photo]
    let placeId : String
    let plusCode : PlusCode
    let priceLevel : Int
    let rating : Float?
    let reference : String
    let scope : String
    let types : [String]
    let userRatingsTotal : Int
    let vicinity : String
    
    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry = "geometry"
        case icon = "icon"
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseUri = "icon_mask_base_uri"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case placeId = "place_id"
        case plusCode = "plus_code"
        case priceLevel = "price_level"
        case rating = "rating"
        case reference = "reference"
        case scope = "scope"
        case types = "types"
        case userRatingsTotal = "user_ratings_total"
        case vicinity = "vicinity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        businessStatus = try values.decodeIfPresent(String.self, forKey: .businessStatus) ?? "Closed"
        geometry = try values.decodeIfPresent(Geometry.self, forKey: .geometry)!
        icon = try values.decodeIfPresent(String.self, forKey: .icon) ?? ""
        iconBackgroundColor = try values.decodeIfPresent(String.self, forKey: .iconBackgroundColor)!
        iconMaskBaseUri = try values.decodeIfPresent(String.self, forKey: .iconMaskBaseUri)!
        name = try values.decodeIfPresent(String.self, forKey: .name)!
        openingHours = try OpeningHour(from: decoder)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos) ?? []
        placeId = try values.decodeIfPresent(String.self, forKey: .placeId)!
        plusCode = try PlusCode(from: decoder)
        priceLevel = try values.decodeIfPresent(Int.self, forKey: .priceLevel) ?? 0
        rating = try values.decodeIfPresent(Float.self, forKey: .rating)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)!
        scope = try values.decodeIfPresent(String.self, forKey: .scope)!
        types = try values.decodeIfPresent([String].self, forKey: .types)!
        userRatingsTotal = try values.decodeIfPresent(Int.self, forKey: .userRatingsTotal)!
        vicinity = try values.decodeIfPresent(String.self, forKey: .vicinity)!
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.placeId == rhs.placeId
    }
    
    func thumbnail() -> String? {
        if photos.count > 0 {
            return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=" + String(photos[0].width ?? 256)
            + "&photoreference=" + String(photos[0].photoReference ?? "") + "&key=AIzaSyA6H30gsKS5UGyR30_CxE1TygjPup6wyOM"
        } else {
            return nil
        }
    }
    
    func open() -> String {
        var result: String = "Undefined"
        if openingHours.openNow != nil {
            if openingHours.openNow! {
                result = "Open"
            } else {
                result = "Closed"
            }
        }
        return result
    }
    
}

struct PlusCode : Codable {
    
    let compoundCode : String?
    let globalCode : String?
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        compoundCode = try values.decodeIfPresent(String.self, forKey: .compoundCode)
        globalCode = try values.decodeIfPresent(String.self, forKey: .globalCode)
    }
    
}

struct Photo : Codable, Identifiable, Equatable {
    
    let id = UUID()
    
    let height : Int?
    let htmlAttributions : [String]?
    let photoReference : String?
    let width : Int?
    
    enum CodingKeys: String, CodingKey {
        case height = "height"
        case htmlAttributions = "html_attributions"
        case photoReference = "photo_reference"
        case width = "width"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        htmlAttributions = try values.decodeIfPresent([String].self, forKey: .htmlAttributions)
        photoReference = try values.decodeIfPresent(String.self, forKey: .photoReference)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoReference == rhs.photoReference
    }
    
}

struct Geometry : Codable {
    
    let location : Location?
    let viewport : Viewport?
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
        case viewport = "viewport"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        viewport = try values.decodeIfPresent(Viewport.self, forKey: .viewport)
    }
    
}

struct Viewport : Codable {
    
    let northeast : Northeast?
    let southwest : Southwest?
    
    enum CodingKeys: String, CodingKey {
        case northeast = "northeast"
        case southwest = "southwest"
    }
    
    init(from decoder: Decoder) throws {
        _ = try decoder.container(keyedBy: CodingKeys.self)
        northeast = try Northeast(from: decoder)
        southwest = try Southwest(from: decoder)
    }
    
}

struct Southwest : Codable {
    
    let lat : Float?
    let lng : Float?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Float.self, forKey: .lat)
        lng = try values.decodeIfPresent(Float.self, forKey: .lng)
    }
    
}

struct Northeast : Codable {
    
    let lat : Float?
    let lng : Float?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Float.self, forKey: .lat)
        lng = try values.decodeIfPresent(Float.self, forKey: .lng)
    }
    
}

struct Location : Codable {
    
    let lat : Double?
    let lng : Double?
    
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lng = try values.decodeIfPresent(Double.self, forKey: .lng)
    }
    
}
