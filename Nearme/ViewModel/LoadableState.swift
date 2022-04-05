//
//  LoadableState.swift
//  Nearme
//
//  Created by Giovanni Corte on 26/10/2021.
//

import Foundation

enum LoadableState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
