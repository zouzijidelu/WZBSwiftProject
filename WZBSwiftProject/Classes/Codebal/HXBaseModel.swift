//
//  HXBaseModel.swift
//  huanxin_ipad
//
//  Created by zhibin wang on 2022/3/16.
//  Copyright © 2022 italkbbtv.com. All rights reserved.
//

import UIKit

protocol HXBaseModel: Codable {
    func convertModel()
}

extension HXBaseModel {
    func convertModel() {}
}

extension KeyedDecodingContainer {

    func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        } else if let value = try? decode(Double.self, forKey: key) {
            return Int(value)
        } else if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
   
        if let value = try? decode(type, forKey: key) {
            return value
        } else if let value = try? decode(Double.self, forKey: key) {
            return String(value)
        } else if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        return nil
    }
    
    func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        
        if let value = try? decode(type, forKey: key) {
            return value
        } else if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        } else if let value = try? decode(Int.self, forKey: key) {
            return Double(value)
        }
        return nil
    }
}
