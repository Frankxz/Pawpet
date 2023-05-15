//
//  InfoFlowLayout.swift
//  Pawpet
//
//  Created by Robert Miller on 09.05.2023.
//

import UIKit

class InfoFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)

        guard let collectionView = collectionView else {
            return layoutAttributes
        }

        let collectionViewWidth = collectionView.bounds.width

        var xOffsets: [CGFloat] = []
        var lastYOffset: CGFloat = 0

        layoutAttributes?.forEach({ attribute in
            if attribute.frame.origin.y != lastYOffset {
                lastYOffset = attribute.frame.origin.y
                xOffsets = [0]
            }

            let currentXOffset = xOffsets.last ?? 0
            attribute.frame.origin.x = currentXOffset
            xOffsets.append(currentXOffset + attribute.frame.width + minimumInteritemSpacing)
            xOffsets = xOffsets.filter { $0 < collectionViewWidth }
        })

        return layoutAttributes
    }
}
