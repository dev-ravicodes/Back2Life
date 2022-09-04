//
//  HFPageControl.swift
//  House Flipper Estimator
//
//  Created by Sukhpreet Singh on 06/11/20.
//

import UIKit

class HFPagerView: UIView {
    
    private var circles = [Circle]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var numberOfPages: Int = 0 {
        didSet {
            let minDimension = min(bounds.width, bounds.height)
            let pagerWidthDivision = bounds.width/CGFloat(numberOfPages)
            var spacing = pagerWidthDivision - minDimension
            spacing += spacing/2
            
            for pageIndex in 0..<numberOfPages {
                let circle = Circle(frame: CGRect(origin: .zero, size: CGSize(width: minDimension, height: minDimension)))
                let xOffset = pageIndex*Int(spacing) + pageIndex * Int(minDimension)
                circle.frame.origin = CGPoint(x: xOffset, y: 0)
                circles.append(circle)
                addSubview(circle)
            }
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            guard currentPage < circles.count else {return}
            for (index, circle) in circles.enumerated() {
                if index == currentPage {
                    circle.fill(currentTint)
                } else {
                    circle.backgroundColor = .clear
                    circle.stroke()
                }
            }
        }
    }
    
    var tint: UIColor = .red {
        didSet {
            circles.forEach { circle in
                circle.borderColor = tint
            }
        }
    }
    
    var currentTint: UIColor = .red {
        didSet {
            circles[currentPage].backgroundColor = currentTint
        }
    }
    
}

class Circle: UIView {
    
    var borderColor: UIColor = .purple
    private var borderWidth: CGFloat = 1
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        stroke()
    }
    
    func stroke() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func fill(_ color: UIColor) {
        backgroundColor = color
    }
    
}
