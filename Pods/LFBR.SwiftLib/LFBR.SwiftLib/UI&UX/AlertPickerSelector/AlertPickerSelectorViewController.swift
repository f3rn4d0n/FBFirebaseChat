//
//  AlertPickerSelectorViewController.swift
//  ExtensionManager
//
//  Created by Luis Fernando Bustos Ramírez on 10/27/17.
//  Copyright © 2019 Gastando Tenis. All rights reserved.
//

import UIKit

public protocol AlertPickerDelegate{
    func dateSelected(_ dateSelected: Date, andTag: Int)
}

public class AlertPickerSelectorViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var delegate: AlertPickerDelegate?
    var dateSelected = NSData()
    var minDate = Date()
    var tag = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = minDate
        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        delegate?.dateSelected(datePicker.date, andTag: tag)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
