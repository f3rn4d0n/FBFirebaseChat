//
//  RecordView.swift
//  FBFirebaseChat
//
//  Created by Ricardo Hernandez on 20/04/18.
//  Copyright © 2018 Luis Fernando Bustos Ramírez. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordViewDelegate: class {
    
    func RecordViewDidSelectRecord(_ sender : RecordView, button: UIView)
    func RecordViewDidStopRecord(_ sender : RecordView, button: UIView)
    func RecordViewDidCancelRecord(_ sender : RecordView, button: UIView)
    
}

@IBDesignable class RecordView: UIView {

    enum RecordViewState {
        case recording
        case none
    }
    
    var state : RecordViewState = .none {
        
        didSet {
            if state != .recording{
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    //self.slideToCancel.alpha = 1.0
                    //self.countDownLabel.alpha = 1.0
                    
                    self.invalidateIntrinsicContentSize()
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }else{
               // self.slideToCancel.alpha = 1.0
               // self.countDownLabel.alpha = 1.0
                self.invalidateIntrinsicContentSize()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
    
    let slideToCancel : UILabel = UILabel(frame: CGRect.zero)
    let countDownLabel : UILabel = UILabel(frame: CGRect.zero)
    
    var timer:Timer!
    var recordSeconds = 0
    var recordMinutes = 0
    var recordMiliSeconds = 0
    
    var audioRecorder: AVAudioRecorder?
    var recordingSession: AVAudioSession!

    var recordingLabelText = "<<< Desliza para cancelar"
    
    weak var delegate : RecordViewDelegate?
    
    
    // Our custom view from the XIB file
    var view: UIView!
    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var widthViewConstraint: NSLayoutConstraint!
    
    
    @IBAction func buttonPressed(_ sender: Any) {

    }
    
    @IBInspectable var image: UIImage? {
        get {
            return imageView.image
        }
        set(image) {
            imageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        //        self.view = loadViewFromNib() as! CustomView
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                    }
                }
            }
        } catch {
        }
        
        setupRecordButton()
        setupRecorder()

    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: "RecordView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }

    func expandView(){
        
        let frame = CGRect(x: 0, y: 0, width: (self.superview?.frame.width)! - (self.frame.width-20), height: (self.superview?.frame.height)!)
        let otherView = UIView(frame: frame)
        otherView.backgroundColor = self.superview?.backgroundColor
        otherView.tag = 1001
        self.superview?.addSubview(otherView)
        
        countDownLabel.frame = CGRect(x: 10, y: 10, width: 80 , height: (self.superview?.frame.height)! - 20)
        slideToCancel.frame = CGRect(x: 100, y: 10, width: 200 , height: (self.superview?.frame.height)! - 20)
        countDownLabel.textColor = .white
        slideToCancel.textColor = .white
        
        otherView.addSubview(countDownLabel)
        otherView.addSubview(slideToCancel)
    }
    
    func collapseView(){
       self.superview?.viewWithTag(1001)?.removeFromSuperview()
    }
}

extension RecordView :  AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
    
    
    func setupRecordButton() {
        
        
        recordButton.setImage(image, for: UIControl.State())
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(RecordView.userDidTapRecord(_:)))
        longPress.cancelsTouchesInView = false
        longPress.allowableMovement = 10
        longPress.minimumPressDuration = 0.2
        recordButton.addGestureRecognizer(longPress)
        
    }
    
    
    func setupRecorder(){
        
        let recordSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.low.rawValue
        ]
        
        do {
            try audioRecorder = AVAudioRecorder(url: RecordView.getFileURL(),
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getFileURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("audioFile.m4a")
    }
    
    override var intrinsicContentSize : CGSize {
        
        if state == .none {
            return recordButton.intrinsicContentSize
        } else {
            
            return CGSize(width: recordButton.intrinsicContentSize.width * 3, height: recordButton.intrinsicContentSize.height)
        }
    }
    
    func userDidTapRecordThenSwipe(_ sender: UIButton) {
        slideToCancel.text = nil
        countDownLabel.text = nil
        timer.invalidate()
        
        audioRecorder?.stop()
        
        delegate?.RecordViewDidCancelRecord(self, button: sender)
    }
    
    func userDidStopRecording(_ sender: UIButton) {
        slideToCancel.text = nil
        countDownLabel.text = nil
        timer.invalidate()
        audioRecorder?.stop()
        delegate?.RecordViewDidStopRecord(self, button: sender)
    }
    
    func userDidBeginRecord(_ sender : UIButton) {
        slideToCancel.text = self.recordingLabelText
        recordMinutes = 0
        recordSeconds = 0
        
        countdown()
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(RecordView.countdown) , userInfo: nil, repeats: true)
        self.audioRecorder?.record()
        delegate?.RecordViewDidSelectRecord(self, button: sender)
        
    }
    
    @objc func countdown() {
        
        var seconds = "\(recordSeconds)"
        if recordSeconds < 10 {
            seconds = "0\(recordSeconds)"
        }
        var minutes = "\(recordMinutes)"
        if recordMinutes < 10 {
            minutes = "0\(recordMinutes)"
        }
        
        countDownLabel.text = " \(minutes):\(seconds)"
        
        recordMiliSeconds+=1
        if recordMiliSeconds == 60{
            recordSeconds += 1
            recordMiliSeconds = 0
        }
       
        if recordSeconds == 60 {
            recordMinutes += 1
            recordSeconds = 0
        }
        
    }
    
    @objc func userDidTapRecord(_ gesture: UIGestureRecognizer) {
        
        let button = gesture.view as! UIButton
        
        let location = gesture.location(in: button)
        
        var startLocation = CGPoint.zero
        
        switch gesture.state {
            
        case .began:
            startLocation = location
            userDidBeginRecord(button)
        case .changed:
            
            let translate = CGPoint(x: location.x - startLocation.x, y: location.y - startLocation.y)
            
            if !button.bounds.contains(translate) {
                
                if state == .recording {
                    userDidTapRecordThenSwipe(button)
                }
            }
            
        case .ended:
            
            if state == .none { return }
            
            let translate = CGPoint(x: location.x - startLocation.x, y: location.y - startLocation.y)
             userDidStopRecording(button)
            if !button.frame.contains(translate) {
                
            }
            
        case .failed, .possible ,.cancelled : if state == .recording { userDidStopRecording(button) } else { userDidTapRecordThenSwipe(button)}
        }
        
        
    }
 
    
}
