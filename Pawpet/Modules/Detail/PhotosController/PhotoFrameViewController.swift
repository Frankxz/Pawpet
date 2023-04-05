//
//  PhotoFrameViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class PhotoFrameViewController: UIViewController {

    var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName ?? "")
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        imageView.backgroundColor = .clear
    }

}
