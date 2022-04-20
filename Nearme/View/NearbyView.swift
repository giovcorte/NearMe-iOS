//
//  NearbyPlacesView.swift
//  Nearme
//
//  Created by Giovanni Corte on 24/10/2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct NearbyView: View {
    
    @StateObject var viewModel: NearbyViewModel
    
    var title: String
    
    public init(title: String, viewModel: NearbyViewModel = .init()) {
        self.title = title
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.places) { place in
                NavigationLink(destination: DetailView(title: place.name, id: place.placeId)) {
                    PlaceView(url: place.thumbnail(), name: place.name, address: place.vicinity, open: place.open())
                        .onAppear(perform: {
                            viewModel.loadMorePlaces(currentItem: place)
                        })
                }
            }
            if $viewModel.loading.wrappedValue {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .modifier(CenterModifier())
            }
        }
        .onAppear(perform: {
            if (viewModel.places.isEmpty) {
                viewModel.loadPlaces(query: title)
            }
        })
        .navigationBarTitle(self.title)
    }
}

struct PlaceView: View {
    
    var url: String?
    var name: String
    var address: String
    var open: String
    
    var body: some View {
        HStack {
            if url != nil {
                WebImage(url: URL(string: url!))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .frame(width: 100, height: 100)
                /*AsyncImage(url: URL(string: url!)!,
                           placeholder: {
                            LoadableView()
                           }, image: {
                            Image(uiImage: $0)
                                .resizable()
                }).frame(width: 100, height: 100)*/
            }
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 18.0))
                    .bold()
                    .foregroundColor(Color("mainColor"))
                Text(address)
                    .font(.system(size: 14.0))
                Text(open)
                    .font(.system(size: 14.0))
                Spacer()
            }
            Spacer()
        }
    }
}
