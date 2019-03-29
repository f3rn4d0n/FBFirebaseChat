//
//  WebImageServices.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 08/02/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Networking {
    static let sharedInstance = Networking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.lava.app.backgroundtransfer"))
    }
}

class WebImageServices: NSObject {
    
    let urlServices = GlobalValues.sharedInstance.customURLS.urlImages
    
    func upload(fileData: Data?, fileName:String, mimeType:String, parameters: [String : Any], onCompletion: ((String) -> Void)? = nil, onError: ((Error) -> Void)? = nil){
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        Networking.sharedInstance.backgroundSessionManager.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = fileData{
                multipartFormData.append(data, withName: "UserFile", fileName: fileName.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%20", with: ""), mimeType: mimeType)
            }
        }, usingThreshold: UInt64.init(), to: urlServices, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    do{
                        let json = try JSON(data: response.data!)
                        let imageUrl = "\(json["Response"]["archivo"]["URL_Archivo"])"
                        if imageUrl == ""{
                            let myError = NSError.init()
                            onError?(myError)
                        }else{
                            onCompletion?(imageUrl)
                        }
                    }catch{
                        print(error)
                        print("Error in upload: \(error.localizedDescription)")
                        onError?(error)
                    }
                    
                }
                upload.uploadProgress { progress in
                    let percent = progress.fractionCompleted*100
                    print(percent)
                    NotificationCenter.default.post(name: NSNotification.Name("upload_percent"), object: percent)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
        
    }
}
