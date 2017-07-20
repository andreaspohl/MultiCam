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
    
    let session = AVCaptureSession()
    var deviceInput: AVCaptureDeviceInput?
    var videoDataOutput: AVCaptureVideoDataOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSession()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //get all video devices
    func getDevices() -> [AVCaptureDevice] {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
        
        for dev in devices {
            NSLog(dev.modelID)
        }
        
        return devices
    }
    
    //calculate rectangle position
    //the videos are arranged in a row
    func calcRect(i: Int, maxI: Int) -> CGRect {
        
        
        let index: CGFloat = CGFloat(i - 1)
        
        let rectHeight = previewBox.bounds.height
        let rectWidth = previewBox.bounds.width / CGFloat(maxI)
        
        let rectX: CGFloat = index * rectWidth
        let rectY: CGFloat = 0
        
        let rect = CGRect.init(x: rectX, y: rectY, width: rectWidth, height: rectHeight)
        
        return rect
    }
    
    //setup session with inputs and output
    func setupSession() {
        do {

            session.beginConfiguration()
            
            let devices = getDevices()
            //let deviceCount = devices.count
            let deviceCount = 3
            
            let superVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            
            var i: Int = 0
            
            for device in devices {
                
                //device number
                i += 1
                
                //adding devices as input to session
                let input = try AVCaptureDeviceInput(device: device)
                if (session.canAddInput(input) == true) {
                    session.addInputWithNoConnections(input)
                    NSLog("\(device.modelID) added as input")
                }
                
                //get the video input port
                let inputPort = input.ports[0] as! AVCaptureInputPort
                
                //create a video preview layer with the session
                let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                
                //create a connection with the input port and the preview layer
                //and connect it to the session
                let connection = AVCaptureConnection.init(inputPort: inputPort, videoPreviewLayer: videoPreviewLayer)
                
                if (session.canAddConnection(connection) == true) {
                    session.addConnection(connection)
                }
                
                videoPreviewLayer.frame = calcRect(i, maxI: deviceCount)
                
                superVideoPreviewLayer.addSublayer(videoPreviewLayer)
                
            }
            
            
            //connect layer to view
            previewBox.layer = superVideoPreviewLayer
            
/*            deviceInput = try AVCaptureDeviceInput(device: device)
            
            
            if (session.canAddInput(deviceInput) == true) {
                session.addInput(deviceInput)
                NSLog("input added")
            }

            
            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput?.alwaysDiscardsLateVideoFrames = true
            
            if (session.canAddOutput(videoDataOutput) == true) {
                session.addOutput(videoDataOutput)
                NSLog("output added")
            }

 */
            session.commitConfiguration()
 /*
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.frame = previewBox.bounds
            previewBox.layer = previewLayer
*/
            session.startRunning()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
        
    }
}

