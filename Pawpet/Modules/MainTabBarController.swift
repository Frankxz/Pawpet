//
//  MainTabBarController.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBarItems()
        setupTabBar()
    }
}

// MARK: - Configurating TABBAR items
extension MainTabBarController {
    private func generateTabBarItems() {
        // VC for tesing only
        let searchVC = HomeViewController()
        let postVC = PublicationsViewController()
        let profileVC = ProfileViewController()

        searchVC.view.backgroundColor = .white
        postVC.view.backgroundColor = .white
        profileVC.view.backgroundColor = .white


        viewControllers = [
            generateVC(viewController: searchVC,
                       title: "Search".localize(),
                       image: UIImage(systemName: "magnifyingglass")),

            generateVC(viewController: postVC,
                       title: "Post".localize(),
                       image: UIImage(systemName: "plus.circle")),

            generateVC(viewController: profileVC,
                       title: "Profile".localize(),
                       image: UIImage(systemName: "person")),
        ]
    }

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UINavigationController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return UINavigationController(rootViewController: viewController)
    }
}

// MARK: - Setup Tab bar appearance
extension MainTabBarController {
    private func setupTabBar() {
        let x: CGFloat = 0
        let y: CGFloat = 20

        let width = self.tabBar.bounds.width
        let height: CGFloat = 108

        let tabBarRect = CGRect(x: x, y: tabBar.bounds.minY - y, width: width, height: height)
        let roundLayer = CAShapeLayer()
        let beizerPath = UIBezierPath(
            roundedRect: tabBarRect,
            cornerRadius: 32)

        roundLayer.shadowColor = UIColor(red: 0.11, green: 0.25, blue: 0.55, alpha: 0.25).cgColor
        roundLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roundLayer.shadowRadius = 16
        roundLayer.shadowOpacity = 0.5
        roundLayer.path = beizerPath.cgPath
        roundLayer.fillColor = UIColor.white.cgColor

        tabBar.layer.insertSublayer(roundLayer, at: 0)

        tabBar.itemWidth = 40
        tabBar.itemPositioning = .fill
        tabBar.unselectedItemTintColor = .subtitleColor
        tabBar.tintColor = .accentColor

        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }
}
