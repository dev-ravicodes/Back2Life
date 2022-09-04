//
//  TestStepViewController.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

protocol TestStepViewControllerDelegate: AnyObject {
    func didSubmitted(controller: TestStepViewController)
}

class TestStepViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    // MARK: - Properties
    
    weak var delegate: TestStepViewControllerDelegate?
    
    var steps: [String] {
        return [
            "Zieh Deine Schutzkleidung an",
            "Desinfiziere Deine Hände",
            "QR Code Scannen",
            "Ausweis Check",
            "Test Kit Scannen",
            "Test Durchführung",
            "Überprüfe das Ergebnis nach 15 Minuten und übermittle das Ergebnis"
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
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = 50
        tableView.register(for: TestStepTableViewCell.self,
                           withIdentifier: TestStepTableViewCell.identifier)
        
        tableView.layoutIfNeeded()
        tableViewHeight.constant = tableView.contentSize.height
    }
    
    // MARK: - Layout
    
    // MARK: - User Interaction
    
    @IBAction func submitButtonAction(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.didSubmitted(controller: self)
        }
    }
    
    // MARK: - Additional Helpers
}

// MARK: - UITableViewDelegate

extension TestStepViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension TestStepViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TestStepTableViewCell.identifier, for: indexPath) as? TestStepTableViewCell else {
            fatalError()
        }
        cell.numberingLabel.text = "\(indexPath.row + 1)."
        cell.configure(with: steps[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
