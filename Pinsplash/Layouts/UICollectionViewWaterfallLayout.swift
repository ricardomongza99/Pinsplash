//
//  WaterfallLayout.swift
//  Pinsplash
//
//  Created by Ricardo Montemayor on 24/06/23.
//

import UIKit

protocol UICollectionViewDelegateWaterallLayout: AnyObject {
    func collectionView( _ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGSize
}

class UICollectionViewWaterfallLayout: UICollectionViewLayout {
    
    weak var delegate: UICollectionViewDelegateWaterallLayout?
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
    
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var footerAttributes: UICollectionViewLayoutAttributes?
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Reset cache information
        cachedAttributes.removeAll()
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let imageSize = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? CGSize(width: 100, height: 100)
            let imageHeight = imageSize.height * columnWidth / imageSize.width
            let height = imageHeight + cellPadding * 2
            
            
            // Find column with minimum height
            column = yOffset.firstIndex(of: yOffset.min() ?? 0) ?? 0
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cachedAttributes.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
        }
        
        // Footer
        let footerIndexPath = IndexPath(item: 0, section: 0)
        footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: footerIndexPath)
        footerAttributes?.frame = CGRect(x: 0, y: contentHeight, width: collectionView.bounds.width, height: 50)
        contentHeight += 50
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop though the cache and look for items in the rect
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        // If the footer's frame intersects the provided rect, add its layout
        if let footerAttributes = footerAttributes, footerAttributes.frame.intersects(rect) {
            visibleLayoutAttributes.append(footerAttributes)
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionView.elementKindSectionFooter {
            return footerAttributes
        }
        
        return nil
    }
        
}
