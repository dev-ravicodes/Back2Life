
import Foundation
import UIKit
import AVFoundation


extension UIImageView {

    func makeRounded() {

      //  self.layer.borderWidth = 1
        self.layer.masksToBounds = false
      //  self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
      self.clipsToBounds = true
         self.layer.masksToBounds = true
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            if title == "Take photo"{
                switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
                case .authorized:
                    DispatchQueue.main.async {
                        self.pickerController.sourceType = type
                        self.presentationController?.present(self.pickerController, animated: true)
                    }
                    break
                case .denied:
                    let AC = UIAlertController(title: "", message: "It seems like your privacy settings restricted us to open camera. Please select the Settings button and turn on camera Permission.", preferredStyle: .alert)
                    let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel) { (selected) in
                        AC.dismiss(animated: true, completion: nil)
                    }
                    let SettingsBtn = UIAlertAction(title: "Open Settings", style: .default) { (selected) in
                       // self.presentationController?.OpenSettings()
                    }
                    AC.addAction(cancelBtn)
                    AC.addAction(SettingsBtn)
                    self.presentationController?.present(AC, animated: true, completion: nil)
                    break
                case .notDetermined,.restricted :
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
                        if success{
                            DispatchQueue.main.async {
                                self.pickerController.sourceType = type
                                self.presentationController?.present(self.pickerController, animated: true)
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
            else{
                self.pickerController.sourceType = type
                self.presentationController?.present(self.pickerController, animated: true)
            }
          
        }
    }
    
    public func present(from sourceView: UIView) {
        let alertController = UIAlertController(title: "Choose option :", message: nil, preferredStyle: .actionSheet)
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
     
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}


