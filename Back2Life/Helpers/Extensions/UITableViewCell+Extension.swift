//
//  UITableViewCell+Extension.swift
//  Back2Life
//
//  Created by Amalendu Kar on 13/05/21.
//

import UIKit

public protocol Nibable {
    static var identifier: String { get }
    static func nid() -> UINib
}

extension UITableViewCell: Nibable  {
    public static func nid() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    public func register<T: UITableViewCell>(for type: T.Type, withIdentifier identifier: String? = nil) {
        self.register(T.nid(), forCellReuseIdentifier: identifier ?? String(describing: T.self))
    }
}
