//
//  InfoCollectionView.swift
//  Pawpet
//
//  Created by Robert Miller on 09.05.2023.
//

import UIKit

class InfoCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var labelViews: [LabelView] = []

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        print("COLLECTION VIEW INIT")
        let flowLayout = InfoFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 10
        
        super.init(frame: frame, collectionViewLayout: flowLayout)

        self.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: "InfoCollectionViewCell")
        self.delegate = self
        self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelViews.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoCollectionViewCell", for: indexPath) as! InfoCollectionViewCell
        cell.labelView = labelViews[indexPath.item]
        cell.contentView.addSubview(cell.labelView)
        cell.labelView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.bottom.left.right.equalToSuperview()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelView = labelViews[indexPath.item]
        let biggerText = (labelView.subtitleLabel.text!.count > labelView.mainLabel.text!.count) ? labelView.subtitleLabel.text! : labelView.mainLabel.text!
        let size = biggerText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        print("SIZE: \(size) for labelView \(labelView.subtitleLabel.text!)")
        return CGSize(width: size.width + 60, height: 50)
    }
}


