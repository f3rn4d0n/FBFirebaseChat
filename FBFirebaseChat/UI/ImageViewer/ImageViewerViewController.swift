//
//  ImageViewerViewController.swift
//  FBFirebaseChat
//
//  Created by Luis Fernando Bustos Ramírez on 3/18/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit
import LFBR_SwiftLib

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageSelected: UIImageView!
    var titleView = ""
    var urlToImage = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = titleView
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 6.0;
        self.scrollView.delegate = self
        
        let url = URL(string: urlToImage)
        imageSelected.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo-Descargando"))
        
        let moreOptions = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_file_download_white_48pt"), style: .done, target: self, action: #selector(moreOptionsAction))
        navigationItem.rightBarButtonItems = [moreOptions]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func moreOptionsAction(sender: AnyObject) {
        let image = imageSelected.image
        if image != nil{
            UIImageWriteToSavedPhotosAlbum(image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            MessageObject.sharedInstance.showMessage("Hubo un problema al descargar la imagen", title: "Error", okMessage: "Aceptar")
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            MessageObject.sharedInstance.showMessage("Error al guardar la imagen, favor de intentar mas tarde", title: "Error", okMessage: "Aceptar")
            print(error.localizedDescription)
        } else {
            MessageObject.sharedInstance.showMessage("La imagen ahora se encuentra en tu libreria de fotos", title: "Exito", okMessage: "Aceptar")
        }
    }

}

extension ImageViewerViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageSelected
    }
}


