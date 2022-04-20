//
//  NearmeApp.swift
//  Nearme
//
//  Created by Giovanni Corte on 23/10/2021.
//

import SwiftUI

@main
struct NearmeApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(DefaultNavigationViewStyle())
        }
    }
}
