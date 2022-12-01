//
//  BZNewRequest.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/11/25.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit

protocol MyDecodable {
    static func parse(data: Data) -> Self?
}

protocol Client {
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void)

    var host: String { get }
}

struct URLSessionClient: Client {
    let host = "https://api.onevcat.com"
    
    func send<T: Request>(_ r: T, handler: @escaping (T.Response?) -> Void) {
        let url = URL(string: host.appending(r.path))!
        var request = URLRequest(url: url)
        request.httpMethod = r.method.rawValue
        
        let task = URLSession.shared.dataTask(with: request) {
            data, _, error in
            if let data = data, let res = T.Response.parse(data: data) {
                DispatchQueue.main.async { handler(res) }
            } else {
                DispatchQueue.main.async { handler(nil) }
            }
        }
        task.resume()
    }
}

// 使用
struct Test {
    func t() {
        URLSessionClient().send(UserRequest(name: "onevcat")) { user in
            if let user = user {
                print("\(user.message) from \(user.name)")
            }
        }
    }
}
