//
//  CancelRequestReaasonViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class BookAppointmentPopupViewController: UIViewController {
    
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var mainView: UIView!
    @IBOutlet weak private var myView: UIView!
    @IBOutlet weak private var gebuchtLabel: UILabel!
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak private var boldLongLabel: UILabel!
    @IBOutlet weak private var longLabel: UILabel!
    @IBOutlet weak private var fortsetzenButton: UIButton!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchesToUIElements()
    }
    
    
    // MARK: - Interface Builder Actions
    @IBAction func submitButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.navigate(.selectCard)
        }
      
    }
    
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        mainView.layer.cornerRadius = 20.0
    }
    
}
