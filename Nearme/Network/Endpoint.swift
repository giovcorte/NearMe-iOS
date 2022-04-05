//
//  Endpoint.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import Foundation

protocol Endpoint {
    
    var scheme: String { get }

    var baseUrl: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
    
    var headers: [String: String] { get }
    
}
