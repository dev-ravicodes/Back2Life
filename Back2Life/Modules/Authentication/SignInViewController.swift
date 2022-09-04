//
//  SignInViewController.swift
//  Back2Life
//
//  Created by Bright on 19/05/21.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
  }
    
    @IBAction func signInAction(_ sender: Any) {
       // navigate(.mobileDetails)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "EnterNumberViewController") as! EnterNumberViewController

            let navigationController = self.navigationController

            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: vc, action: nil)

            let transition = CATransition()
            transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
            navigationController?.view.layer.add(transition, forKey: nil)
            navigationController?.pushViewController(vc, animated: false)
    }
    
}
