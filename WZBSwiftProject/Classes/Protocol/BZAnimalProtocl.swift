//
//  BZAnimalProtocl.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

protocol Animal {
    var name: String { get }
    var canFly: Bool { get }
    var canSwim: Bool { get }
}

protocol Flyable {
    
}

protocol Swimable {
    
}

extension Animal {
    var canFly: Bool { return false }
    var canSwim: Bool { return false }
}

extension Animal where Self: Flyable {
    var canFly: Bool { return true }
}

extension Animal where Self: Swimable {
    var canSwim: Bool { return true }
}

struct Parrot: Animal, Flyable {
    let name: String
}

struct Penguin: Animal, Flyable, Swimable {
    let name: String
}

struct Goldfish: Animal, Swimable {
    let name: String
}
