//
//  CancelRequestReaasonViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

class CancelRequestReaasonViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var reasons: [String] {
        return [
            "Ziel kann nicht erreicht werden",
            "Kunde nicht da/erreichbar",
            "Persönliche Gründe",
            "Doppelbuchung am selben Tag",
            "Doppelbuchung zur selben Zeit",
            "Buchung wurde storniert",
            "Fahrzeugausfall"
        ]
    }
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(for: CancelRequestReaasonTableViewCell.self,
                           withIdentifier: CancelRequestReaasonTableViewCell.identifier)
        
        tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func cancellButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Additional Helpers
}

// MARK: - UITableViewDelegate

extension CancelRequestReaasonViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension CancelRequestReaasonViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CancelRequestReaasonTableViewCell.identifier, for: indexPath) as? CancelRequestReaasonTableViewCell else {
            fatalError()
        }
        cell.configure(with: reasons[indexPath.row])
        return cell
    }
}
