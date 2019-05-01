//
//  Downloads.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/22/19.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit
class Downloads: NSObject {
    
//    var downloadDelegate: DownloadTaskDelegate { return delegate as! DownloadTaskDelegate }
//    
//    @discardableResult
//    open func downloadProgress(queue: DispatchQueue = DispatchQueue.main, closure: @escaping ProgressHandler) -> Self {
//        downloadDelegate.progressHandler = (closure, queue)
//        return self
//    }
//    
//    @discardableResult
//    public func responseData(
//        queue: DispatchQueue? = nil,
//        completionHandler: @escaping (DownloadResponse<Data>) -> Void)
//        -> Self
//    {
//        return response(
//            queue: queue,
//            responseSerializer: DownloadRequest.dataResponseSerializer(),
//            completionHandler: completionHandler
//        )
//    }


    
    func downloadFile(imageURL:NSURL){
//        Alamofire.download(imageURL as! URLConvertible)
//            .downloadProgress { (progress) in
//                print("Video descarga en \(progress.fractionCompleted/0.01) %")
        
//                if(progress.fractionCompleted > self.downloadProgressValue + 0.05){
//                    self.downloadProgressValue = progress.fractionCompleted
//                    self.chatTblView.reloadRows(at: [IndexPath(row: index!, section: 0)], with: .none)
//                }
//            }
//            .responseData { (data) in
//                print("Completed!")
//                self.chatTblView.reloadData()
//                self.dowloadingVideoIndex = -10
//                self.downloadProgressValue = 0.0
//                //Play local audio File
//                if videoFileURL_ != nil{
//                    self.videoPlayer = AVPlayer(url: videoFileURL_ )
//                    let playerController = AVPlayerViewController()
//                    playerController.player = self.videoPlayer
//                    self.present(playerController, animated: true) {
//                        self.videoPlayer.play()
//                    }
//                }else{
//                    MessageObject.sharedInstance.showMessage("Hubo un problema al descargar el video, favor de intentar mas tarde", title: "Error", accept: "Aceptar")
//                }
//
//        }
    }
}
