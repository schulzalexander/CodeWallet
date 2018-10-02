//
//  ScanCodeViewController.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 02.10.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit
import AVFoundation

class ScanCodeViewController: UIViewController {

	//MARK: Properties
	var captureSession:AVCaptureSession!
	var videoPreviewLayer:AVCaptureVideoPreviewLayer!
	var qrCodeFrameView:UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		captureSession = AVCaptureSession()
		initCaptureSession()
		
		videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		initPreviewLayer()
		
		captureSession.startRunning()
    }
	
	private func initPreviewLayer() {
		// Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
		videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		videoPreviewLayer.frame = view.layer.bounds
		view.layer.addSublayer(videoPreviewLayer!)
	}
	
	private func initCaptureSession() {
		if #available(iOS 10.2, *) {
			let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
			
			guard let captureDevice = deviceDiscoverySession.devices.first else {
				let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("CameraFailAlertControllerText", comment: ""), preferredStyle: .alert)
				failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
				self.present(failController, animated: true, completion: nil)
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
				captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr] //TODO: add more codes here
			} catch {
				// If any error occurs, simply print it out and don't continue any more.
				print(error)
				return
			}
		} else {
			// Fallback on earlier versions
			//TODO
		}
	}

}

extension ScanCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
	
}
