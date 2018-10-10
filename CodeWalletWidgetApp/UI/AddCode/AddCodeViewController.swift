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
	var barcodeLogo: UIImage?
	var imagePicked: Int? // Is set to keep track of which component opened the imagePicker
	var logoSearchResult: [[String: Any]]? // Array of dictionaries
	var logoImages: [UIImage]?
	var selectedLogoSuggestion: IndexPath?
	
	//MARK: Outlets
	@IBOutlet weak var logoCollectionView: UICollectionView!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var barcodeButton: UIButton!
	@IBOutlet weak var logoSuggestionsButton: UIButton!
	@IBOutlet weak var logoLibraryButton: UIButton!
	@IBOutlet weak var logoOrLabel: UILabel!
	@IBOutlet weak var codeSelectionLabel: UILabel!
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
		logoOrLabel.textColor = Theme.helperTextColor
		
		setupLogoButtons()
		layoutBarcodeButton()
		
		logoImageView.layer.cornerRadius = 5
		
		logoCollectionView.isHidden = true
		logoCollectionView.delegate = self
		logoCollectionView.dataSource = self
		
		setupGradientBackground()
    }

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	//MARK: Layout Methods
	
	private func setupGradientBackground() {
		let colours:[CGColor] = Theme.mainBackgroundGradientColors
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
	
	private func setupLogoButtons() {
		let buttons: [UIButton] = [logoSuggestionsButton, logoLibraryButton]
		for button in buttons {
			button.layer.cornerRadius = 5
			button.layer.shadowOpacity = 1.0
			button.layer.shadowColor = UIColor.lightGray.cgColor
			button.layer.shadowOffset = CGSize(width: 2, height: 2)
			button.backgroundColor = Theme.buttonBackgroundColor
			button.setTitleColor(Theme.buttonTextColor, for: .normal)
			button.layer.masksToBounds = false
			button.addTarget(self, action: #selector(logoButtonTouchDown(_:)), for: .touchDown)
			button.addTarget(self, action: #selector(logoButtonDragExit(_:)), for: .touchDragExit)
			button.addTarget(self, action: #selector(logoButtonTouchUpInside(_:)), for: .touchUpInside)
		}
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
		if barcodeLogo == nil {
			if logoAreaHighlightView == nil {
				logoAreaHighlightView = UIView()
				view.insertSubview(logoAreaHighlightView!, aboveSubview: gradientBackgroundView!)
			}
			// If one of the buttons has been pressed (-> buttons will be hidden), take collectionview as frame, else make frame around buttons
			if logoLibraryButton.layer.opacity == 0 {
				let padding: CGFloat = 15
				logoAreaHighlightView!.frame = CGRect(
					x: logoCollectionView.frame.minX - padding,
					y: logoCollectionView.frame.minY - padding,
					width: logoCollectionView.frame.width + 2 * padding,
					height: logoCollectionView.frame.height + 2 * padding)
			} else {
				let padding: CGFloat = 30
				logoAreaHighlightView!.frame = CGRect(
					x: logoLibraryButton.frame.minX - padding,
					y: logoLibraryButton.frame.minY - padding,
					width: logoLibraryButton.frame.width + 2 * padding,
					height: logoSuggestionsButton.frame.maxY - logoLibraryButton.frame.minY + 2 * padding)
			}
			logoAreaHighlightView!.layer.borderWidth = 2.0
			logoAreaHighlightView!.layer.borderColor = UIColor.red.cgColor
			failed = true
		} else {
			logoAreaHighlightView?.layer.borderColor = UIColor.clear.cgColor
		}
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
			DispatchQueue.main.async {
				self.present(imagePickerController, animated: true, completion: nil)
			}
		} else {
			let failController = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("LibraryFailAlertControllerText", comment: ""), preferredStyle: .alert)
			failController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
			DispatchQueue.main.async {
				self.present(failController, animated: true, completion: nil)
			}
		}
	}
	
	@IBAction func loadLogoSuggestions(_ sender: UIButton) {
		// First hide the "missing logo" highlighter
		logoAreaHighlightView?.layer.borderColor = UIColor.clear.cgColor
		
		// Check if a name has been entered
		guard let name = nameTextField.text, name.count > 0 else {
			nameTextField.layer.borderColor = UIColor.red.cgColor
			barcodeButton.layer.borderColor = UIColor.clear.cgColor // ONLY the namefield should be highlighted now
			
			let alertController = UIAlertController(title: nil, message: NSLocalizedString("LogoSuggestionsNameMissingMessage", comment: ""), preferredStyle: .alert)
			let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
			alertController.addAction(ok)
			present(alertController, animated: true, completion: nil)
			return
		}
		nameTextField.layer.borderColor = UIColor.clear.cgColor
		
		UIView.animate(withDuration: 0.4, animations: {
			self.logoLibraryButton.layer.opacity = 0
			self.logoOrLabel.layer.opacity = 0
			self.logoSuggestionsButton.center.y = self.logoOrLabel.frame.minY
		}) { (result) in
			if self.suggestionsLoadingIndicator == nil {
				self.suggestionsLoadingIndicator = UIActivityIndicatorView(style: .gray)
				self.view.addSubview(self.suggestionsLoadingIndicator!)
				self.suggestionsLoadingIndicator!.center.x = self.logoSuggestionsButton.frame.maxX + self.suggestionsLoadingIndicator!.frame.width
				self.suggestionsLoadingIndicator!.center.y = self.logoSuggestionsButton.center.y
			}
			self.suggestionsLoadingIndicator?.isHidden = false
			self.suggestionsLoadingIndicator?.startAnimating()
		}
		logoSuggestionsButton.isEnabled = false

		// Load the API key for search from the key json
		guard let apiKeys = Utils.loadJson(resourceName: "Keys"),
			let key = apiKeys["GoogleCustomSearch"] as? String,
			let url = URL(string: "https://www.googleapis.com/customsearch/v1?key=\(key)&cx=016319113637680411654:t4an8ihlcbc&q=\(getValidSearchString(string: name))+icon&searchType=image&imgSize=small&rights=cc_publicdomain%2Ccc_sharealike%2Ccc_nonderived") else {
				return //TODO: provide user message
		}
		// Init logo images array, where async download tasks will append images
		logoImages = [UIImage]()
		Utils.urlGetJSON(url: url) { (response) in
			guard let items = response["items"] as? [[String: Any]] else {
				return //TODO: error message
			}

			self.logoSearchResult = items
			let queue = DispatchGroup()
			for item in items {
				if let imageMetadata = item["image"] as? [String: Any],
					let imageURLString = imageMetadata["thumbnailLink"] as? String,
					let imageURL = URL(string: imageURLString) {
					queue.enter()
					Utils.urlGetImage(url: imageURL, completionHandler: { (image) in
						self.logoImages!.append(image)
						DispatchQueue.main.async {
							self.logoCollectionView.reloadData()
						}
						queue.leave()
					}, errorHandler: { (error) in
						queue.leave()
					})
				}
			}
			// We want to show all suggestions at the same time if possible, i.e. the responses are all loaded fast enough
			queue.notify(queue: .main, execute: {
				self.showLogoCollectionView()
			})
			// After 7 seconds, show the collectionview anyways with the pictures that have been loaded up to then
			// Collectionview will be reloaded when pictures get loaded
			DispatchQueue.main.asyncAfter(deadline: .now() + 7.0, execute: {
				if self.logoCollectionView.isHidden {
					self.showLogoCollectionView()
					self.logoCollectionView.reloadData()
				}
			})
		}
	}
	
	private func showLogoCollectionView() {
		// Hide the components that are in the way
		if self.suggestionsLoadingIndicator != nil {
			self.suggestionsLoadingIndicator?.isHidden = true
		}
		self.logoSuggestionsButton.isHidden = true
		self.logoCollectionView.isHidden = false
	}
	
	private func setLogo(image: UIImage?) {
		let hideSelectionButtons = image != nil
		logoSuggestionsButton.isHidden = hideSelectionButtons
		logoLibraryButton.isHidden = hideSelectionButtons
		logoOrLabel.isHidden = hideSelectionButtons
		logoImageView.image = image
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
	
	private func getValidSearchString(string: String) -> String {
		let pattern = "[^A-Za-z0-9]+"
		return string.replacingOccurrences(of: pattern, with: "", options: [.regularExpression])
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
			setLogo(image: selectedImage)
			barcodeLogo = selectedImage
		}
		imagePicked = nil
		dismiss(animated: true, completion: nil)
	}
	
}

extension AddCodeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return logoImages?.count ?? 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellIdentifier = "LogoCollectionViewCell"
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
		guard let image = logoImages?[indexPath.row] else {
			return cell
		}
		let backgroundView = UIImageView(frame: cell.frame)
		backgroundView.image = image
		cell.backgroundView = backgroundView
		if indexPath == selectedLogoSuggestion {
			cell.layer.borderColor = UIColor.green.cgColor
		} else {
			cell.layer.borderColor = UIColor.clear.cgColor
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// Highlight selected cell
		guard let cell = collectionView.cellForItem(at: indexPath),
			let imageView = cell.backgroundView as? UIImageView,
			let image = imageView.image else {
			fatalError("Failed to retreive collectionView cell after user selection!")
		}
		cell.layer.borderColor = UIColor.green.cgColor
		cell.layer.borderWidth = 4.0
		
		let reload = selectedLogoSuggestion
		selectedLogoSuggestion = indexPath
		if reload != nil {
			collectionView.reloadItems(at: [reload!])
		}
		barcodeLogo = image
	}
	
}
