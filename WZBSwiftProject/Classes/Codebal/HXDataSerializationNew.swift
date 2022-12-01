//
//  DFDataManager.swift
//  dftv2
//
//  Created by zhibin wang on 2020/4/20.
//  Copyright © 2020 italktv. All rights reserved.
//

import UIKit

internal class HXDataSerializationNew {
    /// Convert a Data/jsonObject to a specific model, where model adopt to `Codable`
    ///
    /// - Parameters:
    ///   - result: Data response result.
    public static func convertToNullableModel<T: HXBaseModel>(
        responseResult result: Any?) -> T? {
        guard result != nil else { return nil }
            let m = toModelObject(result, to: T.self)
            m?.convertModel()
            return m
    }
    
    /// Handle Json Array.
    ///
    /// - Parameters:
    ///   - result: Data response result.
    public static func convertToNullableModelArray<T: HXBaseModel>(responseResult result: Any?) -> [T]? {
        guard result != nil else { return nil }
        
        var resultArr = [T]()
        if let array = result as? [[String : Any]] {
            for obj in array {
                if let m = toModelObject(obj, to: T.self) {
                    m.convertModel()
                    resultArr.append(m)
                }
            }
            return resultArr
        }
        return nil
    }
    
    public static func converToJson<T: HXBaseModel>(from model: T?) -> Any? {
        guard model != nil else { return nil }
        let json = modelToJson(model)
        return json
    }
    
    public static func converToJson<T: HXBaseModel>(from list: [T]?) -> Any? {
        guard let list = list else { return nil }
        var resultArr = [Any]()
        for sub in list {
            if let json = modelToJson(sub) {
                resultArr.append(json)
            }
        }
        return resultArr
    }
    
    
    
    /// If result is nil. Will call failure callback
    ///
    /// - Parameters:
    ///   - result: Data response result.
    ///   - success: Success callback.
    ///   - failure: Failure callback.
    public static func convertToNonnullModel<T: HXBaseModel>(
        responseResult result: Any?,
        success: (T) -> Void,
        failure: (Error) -> Void) {
        if let m = toModelObject(result, to: T.self) {
            success(m)
        } else {
            //failure()
        }
    }
    
    /// 字典转模型
    public static func toModelObject<T>(_ dictionary: Any?, to type: T.Type) -> T? where T: Decodable {
        
        guard let dictionary = dictionary else {
            print("❌ 传入的数据解包失败!")
            return nil
        }
        if !JSONSerialization.isValidJSONObject(dictionary) {
            print("❌ 不是合法的json对象!")
            return nil
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            let decoder = JSONDecoder()
            // 处理下划线转驼峰
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let model = try decoder.decode(type, from: data)
            return model
        } catch {
            print("❌ error \(error.localizedDescription)")
            return nil
        }
    }
    
    public static func modelToJson<T>(_ encodable: T?) -> Any? where T: Encodable {
        guard let encodable = encodable else {
            print("❌ 传入的数据为空!")
            return nil
        }
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        guard let data = try? encoder.encode(encodable) else {
            print("❌ 传入的数据Encode失败!")
            return nil
        }
        
        guard let result = dataToJSON(data: data) else {
            print("❌ JSONSerialization转JSON失败!")
            return nil
        }
        return result
    }
    
    static func dataToJSON(data: Data) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch {
            print(error)
        }
        return nil
    }
}
