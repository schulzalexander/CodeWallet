//
//  AddCodeViewController.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit
import AVFoundation

class AddCodeViewController: UIViewController {
	
	//MARK: Properties
	var barcodeValue: String?
	var barcodeType: AVMetadataObject.ObjectType?
	
	//MARK: Outlets
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var barcodeButton: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// to highlight when user wants to create code, but barcode info is missing
		barcodeButton.layer.borderWidth = 2.0
		nameTextField.layer.borderWidth = 2.0
		barcodeButton.layer.borderColor = UIColor.clear.cgColor
		nameTextField.layer.borderColor = UIColor.clear.cgColor
		
		nameTextField.delegate = self
    }

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	//MARK: Layout Methods
	private func layoutBarcodeButton() {
		barcodeButton.layer.shadowOpacity = 1.0
		barcodeButton.layer.shadowColor = UIColor.lightGray.cgColor
		barcodeButton.layer.shadowRadius = 3.0
		barcodeButton.layer.borderWidth = 2
	}
	
	// Called when user clicks on the button that holds the barcode (if selected)
	@IBAction func selectBarcode(_ sender: UIButton) {
		barcodeButton.becomeFirstResponder()
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		
		// User can either scan a code, or load an image from the photo library
		let alertController = UIAlertController(title: NSLocalizedString("ImagePickerAlertControllerTitle", comment: ""), message: nil, preferredStyle: .actionSheet)
		let library = UIAlertAction(title: NSLocalizedString("PhotoLibrary", comment: ""), style: .default, handler: {(action) in
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				imagePickerController.sourceType = .photoLibrary
				self.present(imagePickerController, animated: true, completion: nil)
			} else {
				let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("LibraryFailAlertControllerText", comment: ""), preferredStyle: .alert)
				failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
				self.present(failController, animated: true, completion: nil)
			}
		})
		let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: {(action) in
			guard let scanViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScanCodeViewController") as? ScanCodeViewController else {
				return
			}
			self.navigationController?.pushViewController(scanViewController, animated: true)
//			if UIImagePickerController.isSourceTypeAvailable(.camera) {
//				imagePickerController.showsCameraControls = false
//				imagePickerController.sourceType = .camera
//				self.present(imagePickerController, animated: true, completion: nil)
//			} else {
//				let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("CameraFailAlertControllerText", comment: ""), preferredStyle: .alert)
//				failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
//				self.present(failController, animated: true, completion: nil)
//			}
		})
		let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
		alertController.addAction(camera)
		alertController.addAction(library)
		alertController.addAction(cancel)
		DispatchQueue.main.async {
			self.present(alertController, animated: true, completion: nil)
		}
	}
	
	// Called when the user wants to add a new code from the currently entered information
	@IBAction func addBarcode(_ sender: UIBarButtonItem) {
		var failed = false
		if barcodeValue == nil || barcodeType == nil {
			barcodeButton.layer.borderColor = UIColor.red.cgColor
			failed = true
		} else {
			barcodeButton.layer.borderColor = UIColor.clear.cgColor
		}
		if nameTextField.text == nil || nameTextField.text!.count == 0 {
			nameTextField.layer.borderColor = UIColor.red.cgColor
			failed = true
		} else {
			nameTextField.layer.borderColor = UIColor.clear.cgColor
		}
		if failed {
			return
		}
		
		CodeManager.shared.addCode(code: Code(name: nameTextField.text!, value: barcodeValue!, type: barcodeType!))
		CodeManagerArchive.saveCodeManager()
		
		self.dismiss(animated: true, completion: nil)
	}
	
}

extension AddCodeViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
}

extension AddCodeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
			print("No valid Image selected")
			return
		}
		barcodeButton.setBackgroundImage(selectedImage, for: .normal)
		barcodeButton.setTitle(nil, for: .normal)
		dismiss(animated: true, completion: nil)
	}
	
}
