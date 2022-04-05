//
//  EnvironmentValues+ImageCache.swift
//  Nearme
//
//  Created by Giovanni Corte on 25/10/2021.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    
    static let defaultValue: ImageCache = TemporaryImageCache()
    
}

extension EnvironmentValues {
    
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
    
}
