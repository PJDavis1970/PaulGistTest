//
//  QRScannerViewController.swift
//  PaulGistTest
//
//  Created by Paul Davis on 08/10/2018.
//  Copyright © 2018 pauld. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController: UIViewController {
    
    @IBOutlet var message:UILabel!
    @IBOutlet var topbar: UIView!
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    // this is not nice but for now it works.  this flag will prevent scanner working after we have clicked yes use code.
    // as we will determin in here if code is correct we need asynchronise flow.  nasty but designing this in my head as i go.
    var scannerActive = true
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scannerActive = true
        
        // Get the back-facing camera for capturing videos
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = discoverySession.devices.first else {
            
            print("Failed to get camera")
            return
        }
        
        do {
            
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: message)
        view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Helper methods
    
    func gotoGist(gistString: String) {
        
        if presentedViewController != nil {
            
            return
        }
        
        let alert = UIAlertController(title: "Go To Gist", message: "Open Gist \(gistString)", preferredStyle: .actionSheet)
        
        let confirmAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.scannerActive = false
            
            // we need to remove the http:// section of teh gist string as we dont need this.
            let updatedGist = gistString.replacingOccurrences(of: "http://", with: "")
            
            // we need to check if we have a valid QR code.  If it is a Gist QR then open out gist view else go back to our main view
            GistManager.sharedInstance.addToHistory(id: updatedGist) {
                (result: Bool) in
                
                if result == true {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GistViewController") as! GistViewController
                    self.present(nextViewController, animated:true, completion:nil)
                } else {
                    
                    // was an invalid QR code so unwind to home
                    self.performSegue(withIdentifier: "unwindToHome", sender: self)
                }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // check if meta data objects contains an object
        if metadataObjects.count == 0 {
            
            qrCodeFrameView?.frame = CGRect.zero
            message.text = "No QR code detected"
            return
        }
        
        // Get metadata obj
        let metaObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metaObj.type) {
            
            if scannerActive == true {
            
                // If metadata == QR meta data update the label and set bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaObj)
                qrCodeFrameView?.frame = barCodeObject!.bounds
            
                if metaObj.stringValue != nil {
                
                    gotoGist(gistString: metaObj.stringValue!)
                    message.text = metaObj.stringValue
                }
            }
        }
    }
    
}

