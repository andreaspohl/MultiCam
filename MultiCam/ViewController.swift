//
//  ViewController.swift
//  MultiCam
//
//  Created by Andreas on 19.07.17.
//  Copyright © 2017 Andreas. All rights reserved.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController {
    
    @IBOutlet weak var previewBox: NSView!
    
    let cameraSession = AVCaptureSession()
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) as AVCaptureDevice
    var deviceInput: AVCaptureDeviceInput?
    var dataOutput: AVCaptureVideoDataOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCapture()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func configureCapture() {
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
            
            cameraSession.beginConfiguration()
            
            if (cameraSession.canAddInput(deviceInput) == true) {
                cameraSession.addInput(deviceInput)
                NSLog("input added")
            }
            
            
            dataOutput = AVCaptureVideoDataOutput()
            dataOutput?.alwaysDiscardsLateVideoFrames = true
            
            if (cameraSession.canAddOutput(dataOutput) == true) {
                cameraSession.addOutput(dataOutput)
                NSLog("output added")
            }
            
            cameraSession.commitConfiguration()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
            previewLayer.frame = previewBox.bounds
            previewBox.layer = previewLayer
            cameraSession.startRunning()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
    }
}

