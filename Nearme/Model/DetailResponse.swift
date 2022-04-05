//
//  DetailResponse.swift
//  Nearme
//
//  Created by Giovanni Corte on 26/10/2021.
//

import Foundation

struct DetailResponse : Codable {

    let result : Detail?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Detail.self, forKey: .result) //Detail(from: decoder)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

struct Detail : Codable {

    let addressComponents : [AddressComponent]?
    let formattedAddress : String?
    let formattedPhoneNumber : String?
    let geometry : Geometry?
    let name : String?
    let openingHours : OpeningHour?
    let photos : [Photo]
    let placeId : String?
    let priceLevel : Int?
    let rating : Float?
    let reviews : [Review]?
    let website : String?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case geometry = "geometry"
        case name = "name"
        case openingHours = "opening_hours"
        case photos = "photos"
        case placeId = "place_id"
        case priceLevel = "price_level"
        case rating = "rating"
        case reviews = "reviews"
        case website = "website"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        addressComponents = try values.decodeIfPresent([AddressComponent].self, forKey: .addressComponents)
        formattedAddress = try values.decodeIfPresent(String.self, forKey: .formattedAddress)
        formattedPhoneNumber = try values.decodeIfPresent(String.self, forKey: .formattedPhoneNumber)
        geometry = try Geometry(from: decoder)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        openingHours = try OpeningHour(from: decoder)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos) ?? []
        placeId = try values.decodeIfPresent(String.self, forKey: .placeId)
        priceLevel = try values.decodeIfPresent(Int.self, forKey: .priceLevel)
        rating = try values.decodeIfPresent(Float.self, forKey: .rating)
        reviews = try values.decodeIfPresent([Review].self, forKey: .reviews)
        website = try values.decodeIfPresent(String.self, forKey: .website)
    }
    
    func priceDescription() -> String {
        if priceLevel != nil {
            return "Price level of " + String(priceLevel!) + "/5"
        } else {
            return "Price level undefined"
        }
    }
    
    func ratingDescription() -> String? {
        if rating != nil {
            return "This place has a rating of" + String(rating!) + "/5"
        }
        return nil
    }
    
    func photoUrls() -> [String] {
        var result: [String] = [String]()
        for photo in photos {
            let photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=" + String(photo.width ?? 256)
                + "&photoreference=" + String(photo.photoReference ?? "") + "&key=AIzaSyA6H30gsKS5UGyR30_CxE1TygjPup6wyOM"
            result.append(photoUrl)
        }
        return result
    }
    
    func latitude() -> Double {
        guard let latitude = self.geometry?.location?.lat else {
            return 0.0
        }
        return Double(latitude)
    }
    
    func longitude() -> Double {
        guard let longitude = self.geometry?.location?.lng else {
            return 0.0
        }
        return Double(longitude)
    }

}

struct Review : Codable {

        let authorName : String?
        let authorUrl : String?
        let language : String?
        let profilePhotoUrl : String?
        let rating : Int?
        let relativeTimeDescription : String?
        let text : String?
        let time : Int?

        enum CodingKeys: String, CodingKey {
            case authorName = "author_name"
            case authorUrl = "author_url"
            case language = "language"
            case profilePhotoUrl = "profile_photo_url"
            case rating = "rating"
            case relativeTimeDescription = "relative_time_description"
            case text = "text"
            case time = "time"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            authorName = try values.decodeIfPresent(String.self, forKey: .authorName)
            authorUrl = try values.decodeIfPresent(String.self, forKey: .authorUrl)
            language = try values.decodeIfPresent(String.self, forKey: .language)
            profilePhotoUrl = try values.decodeIfPresent(String.self, forKey: .profilePhotoUrl)
            rating = try values.decodeIfPresent(Int.self, forKey: .rating)
            relativeTimeDescription = try values.decodeIfPresent(String.self, forKey: .relativeTimeDescription)
            text = try values.decodeIfPresent(String.self, forKey: .text)
            time = try values.decodeIfPresent(Int.self, forKey: .time)
        }

}

struct OpeningHour : Codable {

        let openNow : Bool?
        let periods : [Period]?
        let weekdayText : [String]?

        enum CodingKeys: String, CodingKey {
            case openNow = "open_now"
            case periods = "periods"
            case weekdayText = "weekday_text"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            openNow = try values.decodeIfPresent(Bool.self, forKey: .openNow)
            periods = try values.decodeIfPresent([Period].self, forKey: .periods)
            weekdayText = try values.decodeIfPresent([String].self, forKey: .weekdayText)
        }

}

struct Period : Codable {

        let close : Close?
        let open : Open?

        enum CodingKeys: String, CodingKey {
            case close = "close"
            case open = "open"
        }
    
        init(from decoder: Decoder) throws {
            _ = try decoder.container(keyedBy: CodingKeys.self)
            close = try Close(from: decoder)
            open = try Open(from: decoder)
        }

}

struct Open : Codable {

        let day : Int?
        let time : String?

        enum CodingKeys: String, CodingKey {
            case day = "day"
            case time = "time"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            day = try values.decodeIfPresent(Int.self, forKey: .day)
            time = try values.decodeIfPresent(String.self, forKey: .time)
        }

}

struct Close : Codable {

        let day : Int?
        let time : String?

        enum CodingKeys: String, CodingKey {
            case day = "day"
            case time = "time"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            day = try values.decodeIfPresent(Int.self, forKey: .day)
            time = try values.decodeIfPresent(String.self, forKey: .time)
        }

}

struct AddressComponent : Codable {

        let longName : String?
        let shortName : String?
        let types : [String]?

        enum CodingKeys: String, CodingKey {
            case longName = "long_name"
            case shortName = "short_name"
            case types = "types"
        }
    
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            longName = try values.decodeIfPresent(String.self, forKey: .longName)
            shortName = try values.decodeIfPresent(String.self, forKey: .shortName)
            types = try values.decodeIfPresent([String].self, forKey: .types)
        }

}
