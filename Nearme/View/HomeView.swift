//
//  HomeView.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.categories) { category in
                NavigationLink(destination: NearbyView(title: category.title)) {
                    CategoryView(category: category)
                        .padding(.all, 10)
                    
                }
            }
        }
        .navigationBarTitle("NearMe")
    }
}

struct CategoryView: View {

    let category: HomeCategory
    
    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            Image(category.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48.0, height: 48.0)
            Text(category.title)
                .bold()
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
