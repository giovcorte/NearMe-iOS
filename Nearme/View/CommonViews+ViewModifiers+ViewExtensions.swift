//
//  ViewExtensions.swift
//  Nearme
//
//  Created by Giovanni Corte on 26/10/2021.
//

import Foundation
import SwiftUI

extension View {
    func getPopupMaxWidth() -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        return (screenWidth * 2) / 3
    }
    
    func getToolBarHeight()  -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        return screenHeight / 10
    }
}

struct ErrorView: View {
    @Binding var error: LocationError
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 4.0) {
                HStack(alignment: .center, spacing: 4.0) {
                    Text(error.title)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    Spacer()
                    Button(action: {
                        self.error = .none
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                Text(error.description)
                    .font(.body)
                if error == .authorization {
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        Text(Constants.Titles.settings)
                    })
                }
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: self.getPopupMaxWidth(), minHeight: 0, maxHeight: 150)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
