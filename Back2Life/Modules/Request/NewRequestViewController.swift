//
//  NewRequestViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 12/05/21.
//

import UIKit

class NewRequestViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeAddress()
        makeTiming()
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func rejectButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: CancelRequestReaasonViewController.self)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        let vc = Storyboard.Test.viewController(for: TestStepViewController.self)
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        present(vc, animated: false, completion: nil)
    }
    // MARK: - Additional Helpers
    
    func makeAddress() {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: " Hofweg 29, 22085 Hamburg", attributes: [NSAttributedString.Key.font: AppFont.font(style: .medium, size: 16), NSAttributedString.Key.foregroundColor: AppColor.primaryLabelColor])

        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "location")
        image1Attachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.insert(image1String, at: 0)

        // draw the result in a label
        locationLabel.attributedText = fullString
    }
    
    func makeTiming() {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: " Donnerstag, 10 Mai  9:55 AM", attributes: [NSAttributedString.Key.font: AppFont.font(style: .medium, size: 16), NSAttributedString.Key.foregroundColor: AppColor.primaryLabelColor])

        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "timing")
        image1Attachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.insert(image1String, at: 0)

        // draw the result in a label
        timingLabel.attributedText = fullString
    }
}

extension NewRequestViewController: TestStepViewControllerDelegate {
    
    func didSubmitted(controller: TestStepViewController) {
        let vc = BaseNavigationViewController(rootViewController: Storyboard.Test.viewController(for: ScanQRViewController.self))
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false, completion: nil)
    }
}
