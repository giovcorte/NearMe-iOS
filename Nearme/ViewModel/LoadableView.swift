//
//  LoadableView.swift
//  Nearme
//
//  Created by Giovanni Corte on 27/10/2021.
//

import SwiftUI

struct LoadableView: View {
    var body: some View {
        ProgressView()
            .modifier(CenterModifier())
    }
}

struct LoadableView_Previews: PreviewProvider {
    static var previews: some View {
        LoadableView()
    }
}
