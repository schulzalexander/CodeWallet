//
//  AddCodeViewController.swift
//  CodeWalletWidget
//
//  Created by Alexander Schulz on 25.09.18.
//  Copyright © 2018 Alexander Schulz. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class AddCodeViewController: UIViewController {
	
	//MARK: Properties
	var barcodeValue: String?
	var barcodeType: AVMetadataObject.ObjectType?
	var barcodeLogo: UIImage?
	var imagePicked: Int? // Is set to keep track of which component opened the imagePicker
	var logoSearchResult: [[String: Any]]? // Array of dictionaries
	var logoImages: [UIImage]?
	var selectedLogoSuggestion: IndexPath?
	
	//MARK: Outlets
	@IBOutlet weak var logoImageResultButton: UIButton!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var barcodeButton: UIButton!
	@IBOutlet weak var codeSelectionLabel: UILabel!
	@IBOutlet weak var logoOptionalLabel: UILabel!
	@IBOutlet weak var seperator: UIView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var setLocationButton: UIButton!
	
	@IBOutlet weak var mapShrinkedAnchor: NSLayoutConstraint!
	@IBOutlet weak var mapExpandedAnchor: NSLayoutConstraint!
	
	var logoAreaHighlightView: UIView? // A view that covers the logo area, that is used to show a red border when a logo selection is missing
	var gradientBackgroundView: UIView?
	var suggestionsLoadingIndicator: UIActivityIndicatorView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// to highlight when user wants to create code, but barcode info is missing
		barcodeButton.layer.borderWidth = 2.0
		nameTextField.layer.borderWidth = 2.0
		barcodeButton.layer.borderColor = UIColor.clear.cgColor
		nameTextField.layer.borderColor = UIColor.clear.cgColor
		
		nameTextField.delegate = self
		nameTextField.backgroundColor = Theme.textFieldBackgroundColor
		
		logoOptionalLabel.textColor = Theme.logoDescriptionTextColor
		
		// Scan button
		layoutBarcodeButton()
		
		// Logo ImageView that shows an image when selected from local library
		logoImageResultButton.layer.cornerRadius = 10
		logoImageResultButton.layer.borderWidth = 1.0
		logoImageResultButton.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
		logoImageResultButton.clipsToBounds = true
		
		setupGradientBackground()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		layoutSeperator()
	}

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	//MARK: Layout Methods
	
	private func layoutSeperator() {
		let space = (mapView.frame.minY - nameTextField.frame.maxY) / 2
		seperator.center.y = nameTextField.frame.maxY + space
//		seperator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: space).isActive = true
//		seperator.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -space).isActive = true
	}
	
	private func setupGradientBackground() {
		let colours:[CGColor] = Theme.addCodeBackgroundGradientColors
		let locations:[NSNumber] = [0, 0.6]
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = colours
		gradientLayer.locations = locations
		gradientLayer.startPoint = CGPoint(x: 0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 1, y: 1)
		gradientLayer.frame = UIScreen.main.bounds
		
		// Depending on whether the gradient layer was set before, either create a new one or edit the existing
		if gradientBackgroundView == nil {
			gradientBackgroundView = UIView(frame: UIScreen.main.bounds)
			self.view.insertSubview(gradientBackgroundView!, at: 0)
		} else {
			gradientBackgroundView!.layer.sublayers?.removeAll()
		}
		gradientBackgroundView!.layer.addSublayer(gradientLayer)
	}
	
	private func layoutBarcodeButton() {
		barcodeButton.layer.shadowOpacity = 1.0
		barcodeButton.layer.shadowColor = UIColor.lightGray.cgColor
		barcodeButton.layer.shadowRadius = 3.0
		barcodeButton.layer.borderWidth = 2
		barcodeButton.backgroundColor = Theme.barcodeSelectionButtonBackgroundColor
		
		codeSelectionLabel.backgroundColor = Theme.buttonBackgroundColor
		codeSelectionLabel.textColor = Theme.buttonTextColor
	}
	
	//MARK: Barcode
	
	// Called when user clicks on the button that holds the barcode (if selected)
	@IBAction func selectBarcode(_ sender: UIButton) {
		//TODO: For now, directly go to scanning VC
		// in future, user should be able to select a picture from local library to scan it
		guard let scanViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScanCodeViewController") as? ScanCodeViewController else {
			return
		}
		self.navigationController?.pushViewController(scanViewController, animated: true)
//		let imagePickerController = UIImagePickerController()
//		imagePickerController.delegate = self
//
//		// User can either scan a code, or load an image from the photo library
//		let alertController = UIAlertController(title: NSLocalizedString("ImagePickerAlertControllerTitle", comment: ""), message: nil, preferredStyle: .actionSheet)
//		let library = UIAlertAction(title: NSLocalizedString("PhotoLibrary", comment: ""), style: .default, handler: {(action) in
//			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//				imagePickerController.sourceType = .photoLibrary
//				self.present(imagePickerController, animated: true, completion: nil)
//			} else {
//				let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("LibraryFailAlertControllerText", comment: ""), preferredStyle: .alert)
//				failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
//				self.present(failController, animated: true, completion: nil)
//			}
//		})
//		let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: {(action) in
//			guard let scanViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScanCodeViewController") as? ScanCodeViewController else {
//				return
//			}
//			self.navigationController?.pushViewController(scanViewController, animated: true)
//			if UIImagePickerController.isSourceTypeAvailable(.camera) {
//				imagePickerController.showsCameraControls = false
//				imagePickerController.sourceType = .camera
//				self.present(imagePickerController, animated: true, completion: nil)
//			} else {
//				let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("CameraFailAlertControllerText", comment: ""), preferredStyle: .alert)
//				failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
//				self.present(failController, animated: true, completion: nil)
//			}
//		})
//		let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
//		alertController.addAction(camera)
//		alertController.addAction(library)
//		alertController.addAction(cancel)
//		DispatchQueue.main.async {
//			self.present(alertController, animated: true, completion: nil)
//		}
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
//		if barcodeLogo == nil {
//			if logoAreaHighlightView == nil {
//				logoAreaHighlightView = UIView()
//				view.insertSubview(logoAreaHighlightView!, aboveSubview: gradientBackgroundView!)
//			}
//			// If one of the buttons has been pressed (-> buttons will be hidden), take collectionview as frame, else make frame around buttons
//			if logoLibraryButton.layer.opacity == 0 {
//				let padding: CGFloat = 15
//				logoAreaHighlightView!.frame = CGRect(
//					x: logoCollectionView.frame.minX - padding,
//					y: logoCollectionView.frame.minY - padding,
//					width: logoCollectionView.frame.width + 2 * padding,
//					height: logoCollectionView.frame.height + 2 * padding)
//			} else {
//				let padding: CGFloat = 30
//				logoAreaHighlightView!.frame = CGRect(
//					x: logoLibraryButton.frame.minX - padding,
//					y: logoLibraryButton.frame.minY - padding,
//					width: logoLibraryButton.frame.width + 2 * padding,
//					height: logoSuggestionsButton.frame.maxY - logoLibraryButton.frame.minY + 2 * padding)
//			}
//			logoAreaHighlightView!.layer.borderWidth = 2.0
//			logoAreaHighlightView!.layer.borderColor = UIColor.red.cgColor
//			failed = true
//		} else {
//			logoAreaHighlightView?.layer.borderColor = UIColor.clear.cgColor
//		}
		if failed {
			return
		}
		
		CodeManager.shared.addCode(code: Code(name: nameTextField.text!, value: barcodeValue!, type: barcodeType!, logo: barcodeLogo))
		CodeManagerArchive.saveCodeManager()
		
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK: Logo
	@IBAction func pickLocalLogo(_ sender: UIButton) {
		// First hide the "missing logo" highlighter
		logoAreaHighlightView?.layer.borderColor = UIColor.clear.cgColor
		
		// Create imagepicker to select logo from library
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePicked = 1 // identifies this imagePicker in the delegate method
		
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			imagePickerController.sourceType = .photoLibrary
			imagePickerController.allowsEditing = true
			self.present(imagePickerController, animated: true, completion: nil)
		} else {
			let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("LibraryFailAlertControllerText", comment: ""), preferredStyle: .alert)
			failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
			DispatchQueue.main.async {
				self.present(failController, animated: true, completion: nil)
			}
		}
	}
	
	@objc private func logoButtonTouchDown(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.clear.cgColor
	}
	
	@objc private func logoButtonDragExit(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.lightGray.cgColor
	}
	
	@objc private func logoButtonTouchUpInside(_ sender: UIButton) {
		sender.layer.shadowColor = UIColor.lightGray.cgColor
	}
	
	//MARK: Notification Location
	
	@IBAction func expandMap(_ sender: UIButton) {
		UIView.animate(withDuration: 0.3) {
			self.setLocationButton.layer.opacity = 0
		}
		UIView.animate(withDuration: 1.0) {
			self.mapShrinkedAnchor.priority = UILayoutPriority.defaultLow
			self.mapExpandedAnchor.priority = UILayoutPriority.defaultHigh
			self.view.layoutIfNeeded()
		}
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
		guard imagePicked != nil,
			let selectedImage = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage else {
			print("No valid Image selected")
			return
		}
		if imagePicked! == 0 {
			// Barcode selection
			barcodeButton.setBackgroundImage(selectedImage, for: .normal)
			barcodeButton.setTitle(nil, for: .normal)
		}
		if imagePicked! == 1 {
			// Logo selection
			logoImageResultButton.setBackgroundImage(selectedImage, for: .normal)
			barcodeLogo = selectedImage
		}
		imagePicked = nil
		dismiss(animated: true, completion: nil)
	}
	
}


