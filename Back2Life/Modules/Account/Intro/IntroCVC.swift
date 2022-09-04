//
//  IntroCVC.swift
//  House Flipper Estimator
//
//  Created by Sukhpreet Singh on 07/11/20.
//

import UIKit

class IntroCVC: UICollectionViewController {

    static var indexPathChanged: ((_ value: Int) -> Void)?

    //MARK:- UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Intro.objects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCell.identifier, for: indexPath) as? IntroCell else {fatalError("unable to deqeue cell")}
    
        cell.intro = Intro.objects[indexPath.item]
        return cell
    }
    
    //MARK:- UICollectionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let indexPath = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        IntroCVC.indexPathChanged!(indexPath)
    }
}

//MARK:- UICollectionView Delegate Flow Layout

extension IntroCVC:  UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
