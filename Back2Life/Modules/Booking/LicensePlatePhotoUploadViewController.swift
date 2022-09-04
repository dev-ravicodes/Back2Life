//
//  LicensePlatePhotoUploadViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit
import AVFoundation
import AVKit
import CameraManager

class LicensePlatePhotoUploadViewController: AuthenticationBaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    
    // MARK: - Properties
    var captureSession: AVCaptureSession!
    let cameraManager = CameraManager()
    
    var imagePicker: UIImagePickerController!
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupCameraManager()
    }
    
    // MARK: - Layout
    // MARK: - ViewController
    fileprivate func setupCameraManager() {
        cameraManager.shouldEnableExposure = true
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        self.addCameraToView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addCameraToView()
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
        cameraManager.startQRCodeDetection { result in
            switch result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.videoWithMic)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) -> Void in }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoClick(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: - User Interaction
    @IBAction func openCameraButton(sender: UIButton) {

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         picker.dismiss(animated: true)
        
        let image = info[.originalImage] as? UIImage
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "LicensePlateScanningViewController") as! LicensePlateScanningViewController
        
        let navigationController = self.navigationController
        let capturedImage = image
        vc.image = capturedImage ?? UIImage()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: vc, action: nil)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func takeAPicktureButtonAction(_ sender: Any) {
        navigate(.licensePlateScanning)
    }
    
    // MARK: - Additional Helpers
}

extension LicensePlatePhotoUploadViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    }


public extension Data {
    func printExifData() {
        let cfdata: CFData = self as CFData
        let imageSourceRef = CGImageSourceCreateWithData(cfdata, nil)
        let imageProperties = CGImageSourceCopyMetadataAtIndex(imageSourceRef!, 0, nil)!
        
        let mutableMetadata = CGImageMetadataCreateMutableCopy(imageProperties)!
        
        CGImageMetadataEnumerateTagsUsingBlock(mutableMetadata, nil, nil) { _, tag in
            print(CGImageMetadataTagCopyName(tag)!, ":", CGImageMetadataTagCopyValue(tag)!)
            return true
        }
    }
}
