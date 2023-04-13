//
//  SignUpViewController_2.swift
//  Pawpet
//
//  Created by Robert Miller on 21.03.2023.
//

import UIKit
import Lottie

class SignUpViewController_2: BaseSignUpViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        promptView.setupTitles(title: "Create your password", subtitle: "This will help you to enter the application.")
        textField.setupPlaceholder(placeholder: "••••••")
        setupAnimationView(with: "WatchingDog")

        nextVC = SignUpViewController_3()
    }
}
