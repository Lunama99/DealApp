//
//  Observable.swift
//  DealApp
//
//  Created by Macbook on 31/08/2021.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            listeners.forEach {
                $0(value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?)->Void)] = []
    
    func bind(_ listener: @escaping (T?)->Void) {
        listener(value)
        self.listeners.append(listener)
    }
}
