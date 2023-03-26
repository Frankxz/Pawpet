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

        let vc1 = UINavigationController(rootViewController: SearchViewController())
        let vc2 = UINavigationController(rootViewController: PostViewController())
        let vc3 = UINavigationController(rootViewController: ProfileViewController())

        viewControllers = [vc1, vc2, vc3]

        setTitles()
        setImages()

        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "ChalkboardSE-Regular", size: 12)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
    }

    func setTitles() {
        tabBar.items?[0].title = "Search"
        tabBar.items?[1].title = "Post"
        tabBar.items?[2].title = "Profile"
    }

    func setImages() {
        tabBar.items?[0].image = UIImage(systemName: "magnifyingglass")
        tabBar.items?[1].image = UIImage(systemName: "plus.circle")
        tabBar.items?[2].image = UIImage(systemName: "person")
    }
}
