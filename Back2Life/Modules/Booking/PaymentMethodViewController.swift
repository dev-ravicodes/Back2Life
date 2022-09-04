//
//  PaymentMethodViewController.swift
//  Back2Life
//
//  Created by Sachin Kumar on 20/05/21.
//  Copyright © 2021 Sachin Kumar. All rights reserved.
//

import UIKit

class Property {
    var name: String
    var image: String
    var isSelected: Bool
    
    init(name: String, image: String, isSelected: Bool = false) {
        self.name = name
        self.image = image
        self.isSelected = isSelected
    }
}

class PaymentMethodViewController: MainBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    //MARK: - Properties
    private var dataSaurce: [Property] = []
    var isPaypalSelected = false
    var isPayment = ""
    
    //MARK: - Interface Builder Outlets
    @IBOutlet weak private var backButton: UIButton!
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var zahlenButton: UIButton!
    @IBOutlet weak var eurPrice: UILabel!
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eurPrice.text? = (UserDefaults.standard.value(forKey: "ERO") as? String ?? "") + " €"
        zahlenButton.setTitle((UserDefaults.standard.value(forKey: "ERO") as? String ?? "") + " € ZAHLEN", for: .normal)
        self.applyFinishingTouchesToUIElements()
    }
    
    //MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSaurce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as! PaymentMethodTableViewCell
        let property = dataSaurce[indexPath.row]
        cell.populateUI(property: property)
      return cell
    }
    
    
    //MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSaurce = dataSaurce.compactMap({ (element) -> Property? in
            let newElement = element
            if dataSaurce[indexPath.row].name == element.name{
                newElement.isSelected = true
            }else{
                newElement.isSelected = false
            }
            return newElement
        })
        tableView.reloadData()
        if indexPath.row == 0 {
            isPaypalSelected = false
            isPayment = "1"
        }
        else {
            isPaypalSelected = true
            isPayment = "1"
        }
    }
    
    //MARK: - Helpers
    private func applyFinishingTouchesToUIElements() {
        
        let image = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.tintColor = .white
        
        let nib = UINib(nibName: "PaymentMethodTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PaymentMethodTableViewCell")
        
        tableView.estimatedRowHeight = 98
        tableView.rowHeight = UITableView.automaticDimension
        zahlenButton.layer.cornerRadius = 10.0
        self.setUpDataSource()
    }
    
    private func setUpDataSource() {
        
        //let dataSourceArray = [["name": "Kreditkarte", "image": "card"], ["name": "Bar", "image": "cash"], ["name": "", "image": "paypal"]]
        
        let dataSourceArray = [["name": "Kreditkarte", "image": "card"],["name": "Paypal", "image": "paypal"]]
        
        for value in dataSourceArray {
            let name = value["name"] ?? ""
            let image = value["image"] ?? ""
            let property = Property(name: name, image: image)
            dataSaurce.append(property)
        }
        
        tableView.reloadData()
    }
    @IBAction func NextAction(_ sender: Any) {
        if isPayment == "1"{
        UserStoreSingleton.shared.isPayPal = isPaypalSelected
        navigate(.payment)
        }else{
            showMessage("bitte zahlungsmethode auswählen")
        }
    }
    
}
