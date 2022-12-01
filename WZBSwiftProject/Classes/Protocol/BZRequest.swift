//
//  BZRequest.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case GET
    case POST
}

protocol Request {
    var host: String { get }
    var path: String { get }
    
    var method: HTTPMethod { get }
    var parameter: [String: Any] { get }
//    associatedtype Response
//    func parse(data: Data) -> Response?
    associatedtype Response: MyDecodable
}

//extension Request {
//    func send(handler: @escaping (Response?) -> Void) {
//        let url = URL(string: host.appending(path))!
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//
//        // 在示例中我们不需要 `httpBody`，实践中可能需要将 parameter 转为 data
//        // request.httpBody = ...
//
//        let task = URLSession.shared.dataTask(with: request) {
//            data, _, error in
//            if let data = data, let res = parse(data: data) {
//                DispatchQueue.main.async { handler(res) }
//            } else {
//                DispatchQueue.main.async { handler(nil) }
//            }
//        }
//        task.resume()
//    }
//}

struct UserRequest: Request {
    typealias Response = User
    let name: String
    
    let host = "https://api.onevcat.com"
    var path: String {
        return "/users/\(name)"
    }
    let method: HTTPMethod = .GET
    let parameter: [String: Any] = [:]
    
//    func parse(data: Data) -> User? {
//        return User(data: data)
//    }
}
