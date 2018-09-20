//
//  CustomCollectionViewLayout.swift
//  CustomCollectionViewApp
//
//  Created by Tigran on 20.09.2018.
//  Copyright © 2018 Tigran. All rights reserved.
//

import UIKit

protocol CustomCollectionViewDelegate: class {
     func theNumberOfItemsInCollectionView() -> Int
}

extension CustomCollectionViewDelegate {
    func heightForContentInItem(inCollectionView collectionView: UICollectionView, at indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    fileprivate var numberOfColumns = 3
    fileprivate var cellPadding: CGFloat = 6
    fileprivate let cellHeight: CGFloat = 150
    
    weak var delegate: CustomCollectionViewDelegate?
    
    
    //An array to cache the calculated attributes
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    //For content size
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {return 0}
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //Setting the content size
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        //We begin measuring the location of items only if the cache is empty
        guard cache.isEmpty == true, let collectionView = collectionView else {return}
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        
        //Getting the xOffset based on the column and column width
        for column in 0..<numberOfColumns {
            
            if column == 0 {
                 xOffset.append(0)
            }
            if column == 1 {
                 xOffset.append(2 * columnWidth)
            }
            if column == 2
            {
                 xOffset.append( columnWidth)
            }
            
           // xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat]()
        
        //For each item in a collection view
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            //Different offset based on what column the item is
            for column in 0..<numberOfColumns {
                switch column {
                case 0:
                    yOffset.append(2 * cellPadding)
                case 1:
                    yOffset.append(2 * cellPadding)
                case 2:
                    
                    yOffset.append(cellPadding + cellHeight)
                default:
                    break
                }
            }
            
            //Measuring the frame
            let height = cellPadding * 2 + cellHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: columnWidth)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            //Creating attributres for the layout and caching them
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            print ("frame.maxY", frame.maxY)
            
            //We increase the max height of the content as we get more items
            contentHeight = max(collectionView.frame.height + 10, frame.maxY)
            
            
            //We increase the yOffset, too
            yOffset[column] = yOffset[column] + 2 * (height - cellPadding)
            
            // print ("column: \(column), yOffset: \(yOffset[column])")
            
            let numberOfItems = delegate?.theNumberOfItemsInCollectionView()
            
            //Changing column so the next item will be added to a different column
            
            if let numberOfItems = numberOfItems, indexPath.item == numberOfItems - 1
            {
                //In case we get to the last cell, we check the column of the cell before
                //The last one, and based on that, we change the column
                print ("indexPath.item: \(indexPath.item), numberOfItems: \(numberOfItems)")
                print ("A")
                switch column {
                case 0:
                    column = 2
                case 2:
                    column = 0
                case 1:
                    column = 2
                default:
                    return
                }
            } else  {
                print ("B")
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
        }
        
    }
    
    
    //Is called  to determine which items are visible in the given rect
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        //Loop through the cache and look for items in the rect
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    //The attributes for the item at the indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
