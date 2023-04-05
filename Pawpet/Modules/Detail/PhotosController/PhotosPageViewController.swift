//
//  PhotosPageViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.04.2023.
//

import UIKit

class PhotosPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    let imageNames = ["husky0","husky1","husky2","husky3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        view.backgroundColor = .black.withAlphaComponent(0.8)
        setupView()
    }

    private func setupView(){
        let frameVC = PhotoFrameViewController()
        frameVC.imageName = imageNames.first
        let viewControllers = [frameVC]
        setViewControllers(viewControllers, direction: .forward, animated: true)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! PhotoFrameViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)

        if currentIndex! < imageNames.count - 1 {
            let frameVC = PhotoFrameViewController()
            frameVC.imageName = imageNames[currentIndex! + 1]
            return frameVC
        }

        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentImageName = (viewController as! PhotoFrameViewController).imageName
        let currentIndex = imageNames.firstIndex(of: currentImageName!)

        if currentIndex! > 0 {
            let frameVC = PhotoFrameViewController()
            frameVC.imageName = imageNames[currentIndex! - 1]
            return frameVC
        }

        return nil
    }



}


