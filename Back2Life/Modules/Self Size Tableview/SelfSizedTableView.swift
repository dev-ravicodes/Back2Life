//
//  SelfSizedTableView.swift
//  Back2Life
//
//  Created by Mohini's Mac on 07/02/22.
//
import UIKit

class SelfSizedTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

}

