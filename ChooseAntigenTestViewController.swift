//
//  ChooseAntigenTestViewController.swift
//  Back2Life
//
//  Created by Bright on 19/05/21.
//

import UIKit

class ChooseAntigenTestViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var testBottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUpView.isHidden = true
    }
    
    @IBAction func antigenButton(_ sender: Any) {
        testBottomView.isHidden = true
        popUpView.isHidden = false
       // dismiss(animated: true, completion: nil)
    }
    
    @IBAction func popUpselectionAction(_ sender: Any) {
   //     navigate(.booking)
    }
    
}
