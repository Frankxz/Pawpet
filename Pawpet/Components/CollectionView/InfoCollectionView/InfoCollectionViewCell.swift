//
//  InfoCollectionViewCell.swift
//  Pawpet
//
//  Created by Robert Miller on 09.05.2023.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {

    lazy var labelView = LabelView(text: "")

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
