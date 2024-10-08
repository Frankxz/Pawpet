//
//  PhotoFrameViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class PhotoFrameViewController: UIViewController {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.layer.masksToBounds = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        imageView.backgroundColor = .clear
    }
    
}
