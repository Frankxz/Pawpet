//
//  PhotosPageViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class PhotosPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: - Button
    public lazy var closeButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium, scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.backgroundColor = .backgroundColor.withAlphaComponent(0.2)
        button.layer.cornerRadius = 16
        return button
    }()

    var imageViews: [UIImageView] = []

    init(publication: Publication) {
        let pawpetImages = publication.pictures.allImages
        for (index, pawpetImage) in pawpetImages.enumerated() {
            imageViews.append(UIImageView())
            pawpetImage.loadMainImage(into: imageViews[index])
            imageViews[index].layer.masksToBounds = false
            imageViews[index].contentMode = .scaleAspectFit
        }

        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        view.backgroundColor = .black
        setupView()
        setupCloseButton()
    }

    private func setupView() {
        let frameVC = PhotoFrameViewController()
        frameVC.imageView = imageViews.first!
        let viewControllers = [frameVC]
        setViewControllers(viewControllers, direction: .forward, animated: true)
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentImageView = (viewController as! PhotoFrameViewController).imageView
        let currentIndex = imageViews.firstIndex(of: currentImageView)

        if currentIndex! < imageViews.count - 1 {
            let frameVC = PhotoFrameViewController()
            frameVC.imageView = imageViews[currentIndex! + 1]
            return frameVC
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentImageView = (viewController as! PhotoFrameViewController).imageView
        let currentIndex = imageViews.firstIndex(of: currentImageView)

        if currentIndex! > 0 {
            let frameVC = PhotoFrameViewController()
            frameVC.imageView = imageViews[currentIndex! - 1]
            return frameVC
        }

        return nil
    }


    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalToSuperview().inset(50)
            make.right.equalToSuperview().inset(20)
        }
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
