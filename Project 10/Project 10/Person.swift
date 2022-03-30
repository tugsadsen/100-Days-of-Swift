//
//  Person.swift
//  Project 10
//
//  Created by Tuğşad Şen on 28.03.2022.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
