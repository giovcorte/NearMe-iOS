//
//  HomeCategory.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import Foundation

struct HomeCategory: Identifiable, Hashable {
    
    let id: String
    var image: String
    var title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
        self.id = title
    }
    
}
