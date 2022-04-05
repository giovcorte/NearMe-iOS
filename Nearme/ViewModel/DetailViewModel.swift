//
//  DetailViewModel.swift
//  Nearme
//
//  Created by Giovanni Corte on 26/10/2021.
//

import Foundation
import Combine
import MapKit

class DetailViewModel: ObservableObject {

    @Published private(set) var state = LoadableState<Detail>.idle
    
    public init() {
        
    }
    
    func loadDetail(id: String) -> Void {
        state = .loading
        NetworkEngine.request(endpoint: PlacesEndpoint.placeDetails(id: id)) { ( result: Result<DetailResponse, Error>) in
            switch result {
            case .success(let response):
                self.state = .loaded(response.result!)
            case .failure(let error):
                print(error)
                self.state = .failed(error)
            }
        }
    }
    
}
