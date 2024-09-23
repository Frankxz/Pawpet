//
//  AppDelegate.swift
//  Pawpet
//
//  Created by Robert Miller on 05.02.2023.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let databaseURL = "https://pawpet-2b8c5-default-rtdb.europe-west1.firebasedatabase.app"
        let firebaseConfig = FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!)
        firebaseConfig?.databaseURL = databaseURL
        FirebaseApp.configure(options: firebaseConfig!)
        
        let navigationController = UINavigationController(rootViewController: SignInViewController())
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()


        return true
    }
}

