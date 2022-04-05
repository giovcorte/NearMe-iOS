//
//  ImageCahe.swift
//  Nearme
//
//  Created by Giovanni Corte on 25/10/2021.
//

import UIKit

protocol ImageCache {
    
    subscript(_ url: URL) -> UIImage? { get set }
    
}

struct TemporaryImageCache: ImageCache {
    
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200 // 200 items
        cache.totalCostLimit = 1024 * 1024 * 200 // 200 MB
        return cache
    }()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
    
}
