//
//  DetailView.swift
//  Nearme
//
//  Created by Giovanni Corte on 26/10/2021.
//

import SwiftUI
import MapKit

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    @State private var currentPage = 0
    @State private var currentReviewPage = 0
    
    var title: String
    var id: String
    
    public init(title: String, id: String, viewModel: DetailViewModel = .init()) {
        self.title = title
        self.id = id
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        switch viewModel.state {
            case .idle:
                Color(.clear)
                    .onAppear(perform: {
                        viewModel.loadDetail(id: id)
                })
                .navigationBarTitle(self.title)
            case .loading:
                ProgressView()
                    .modifier(CenterModifier())
                    .background(Color(.clear))
                    .navigationBarTitle(self.title)
            case .failed(let error):
                Text(error.localizedDescription)
                    .navigationBarTitle(self.title)
            case .loaded(let detail):
                GeometryReader { geometry in
                    ScrollView {
                        if (detail.photos.count > 0) {
                            PagerView(pageCount: detail.photos.count, currentIndex: $currentPage, margin: 10, content: {
                                ForEach(detail.photoUrls()) { photo in
                                    AsyncImage(url: URL(string: photo)!,
                                               placeholder: {
                                                LoadableView()
                                               }, image: {
                                                Image(uiImage: $0)
                                                    .resizable()
                                    })//.frame(width: 100, height: 100)
                                }
                            })
                            .frame(height: 300)
                        }
                        InfoView(name: detail.name!, address: detail.formattedAddress!, rating: detail.ratingDescription(), price: detail.priceDescription())
                            .padding(.all, 10)
                        MapView(latitude: detail.latitude(), longitude: detail.longitude())
                        if let reviews = detail.reviews {
                            PagerView(pageCount: detail.photos.count, currentIndex: $currentReviewPage, margin: 10, content: {
                                ForEach(reviews) { review in
                                    ReviewView(review: review)
                                }
                            })
                            .frame(height: 300)
                        }
                    }
                }
                .navigationBarTitle(self.title)
                .accentColor(.white)
        }
    }
}

struct InfoView: View {
    
    var name: String
    var address: String
    var rating: String?
    var price: String?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 20.0))
                Text(address)
                    .font(.system(size: 18.0))
                Text(rating ?? "")
                    .font(.system(size: 18.0))
                Text(price ?? "")
                    .font(.system(size: 18.0))
            }
            Spacer()
        }
    }
    
}

struct PagerView<Content: View>: View {
    
    @Binding var currentIndex: Int
    
    let pageCount: Int
    let content: Content
    let margin: CGFloat

    init(pageCount: Int, currentIndex: Binding<Int>, margin: CGFloat = 10.0, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.margin = margin
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content
                    .frame(width: geometry.size.width - (2 * margin))
                    .padding(.leading, margin)
                    .padding(.trailing, margin)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.interactiveSpring(), value: currentIndex)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
        
    }
    
}

struct ReviewView: View {
    
    var review: Review
    
    public init(review: Review) {
        self.review = review
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(review.authorName!)
                    .font(.system(size: 18.0))
                Text(String(review.rating!))
                    .font(.system(size: 14.0))
                Text(review.text!)
                    .font(.system(size: 16.0))
                Spacer()
            }
            Spacer()
        }
        .background(Color.white)
    }
}

struct MapView: View {
    
    @State private var region: MKCoordinateRegion

    var latitude: Double
    var longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        _region = State(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                                         latitudinalMeters: 750,
                                                         longitudinalMeters: 750))
    }
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]) { loc in
            MapMarker(coordinate: loc)
        }
        .frame(height: 300)
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

extension CLLocationCoordinate2D: Identifiable {
    
    public var id: String {
        return String(self.latitude) + String(self.longitude)
    }
    
}
