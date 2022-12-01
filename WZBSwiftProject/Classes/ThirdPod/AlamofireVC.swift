//
//  AlamofireVC.swift
//  WZBSwiftProject
//
//  Created by zhibin wang on 2020/5/18.
//  Copyright © 2020 iTalkBB. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireVC: BZBaseVC {

    var dataTask: URLSessionDataTask?
    var urlSession: URLSession = URLSession.shared
    var dataRequest: DataRequest?
    var session: SessionManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        testAlamofireRequest {response in
            
        }
    }
    
    private func queueRequest() {
        
    }
    
    private func testAlamofireRequest(completionHandler: @escaping (DataResponse<Any>) -> Void) {

        session = SessionManager.default
        session?.request("https://httpbin.org/get").responseJSON(queue: DispatchQueue.global()) { (response) in
            
           
            print(Thread.current)
            print(response)
            switch response.result {
            case .success(let resultValue):
                print("success : \(resultValue)")
            case .failure(let error):
                print("error : \(error)")
                if error.localizedDescription.contains("cancelled") {
                    print("cancelled")
                }
            }
            print(response.value ?? "")
            
            print(response.request ?? "")
            //self.dataTask = self.urlSession.dataTask(with: response.request!)
            completionHandler(response)
        }
        
        //取消所有请求
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
            (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }

    }
    
    @IBAction func resumeOldTask(_ sender: Any) {
        
    }
    
    @IBAction func originalSessionRequest(_ sender: Any) {
        let urlStr = "https://httpbin.org/get"
        guard let url = URL(string: urlStr) else { return }
        let request = URLRequest(url: url,cachePolicy: .reloadIgnoringCacheData,timeoutInterval: 30.0)
        dataTask = urlSession.dataTask(with: request) { (data, response, error) in
            print(Thread.current)
            if let rData = data , (error == nil) {
                print(String(data: rData, encoding: .utf8) ?? "")
            } else {
                print("error : \(String(describing: error))")
            }
        }
        dataTask?.resume()
    }
}
