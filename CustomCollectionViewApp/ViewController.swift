//
//  ViewController.swift
//  CustomCollectionViewApp
//
//  Created by Tigran on 20.09.2018.
//  Copyright © 2018 Tigran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    var numbers = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...33 {
            numbers.append(i)
        }
        
        let layout = collectionView.collectionViewLayout as? CustomCollectionViewLayout
        layout?.delegate = self
    }

    
}

//MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCellCollectionViewCell
        
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.clipsToBounds = true
        cell.numberLabel.text = String(numbers[indexPath.item])
        
        return cell
    }
}

//MARK: UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            cell.transform = .identity
        }, completion: nil)
        
    }
}


extension ViewController: CustomCollectionViewDelegate {
    func theNumberOfItemsInCollectionView() -> Int {
        return numbers.count 
    }
    
}
