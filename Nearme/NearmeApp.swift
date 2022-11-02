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
            if #available(iOS 16.0, *) {
                NavigationStack {
                    HomeView()
                }
                .accentColor(Color.white)
            } else {
                NavigationView {
                    HomeView()
                }
            }
        }
    }
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(Color("mainColor"))
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
      
        UINavigationBar.appearance().tintColor = .white
    }
}
