//
//  HomeViewModel.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var categories: [HomeCategory] = [HomeCategory]()
    
    init() {
        let images = ["food", "bar", "hotel", "sweet", "pizza", "cinema", "museum", "pharma",  "icecream"]
        let titles = ["Ristorante", "Bar", "Hotel", "Pasticceria", "Pizzeria", "Cinema", "Museo", "Farmacia", "Gelateria"]
        for i in 0...images.count - 1 {
            categories.append(HomeCategory(image: images[i], title: titles[i]))
        }
    }
    
}
