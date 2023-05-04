//
//  EditDescriptionViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 04.05.2023.
//

import UIKit

class EditDescriptionViewController: PostViewController_6 {
    var callback: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.maxTextViewHeight = 560
        updateTextViewHeight()
    }

    override func nextButtonTapped(_ sender: UIButton) {
        callback()
        navigationController?.popViewController(animated: true)
    }
}
