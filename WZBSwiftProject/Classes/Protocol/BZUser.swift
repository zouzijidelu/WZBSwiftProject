//
//  BZUser.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

struct User {
    
    let name: String
    let message: String
    
    init?(data: Data) {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        guard let name = obj["name"] as? String else {
            return nil
        }
        guard let message = obj["message"] as? String else {
            return nil
        }
        
        self.name = name
        self.message = message
    }
}

extension User: MyDecodable {
    static func parse(data: Data) -> User? {
        return User(data: data)
    }
}
