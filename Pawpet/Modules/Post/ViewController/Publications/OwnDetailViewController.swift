//
//  OwnDetailViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 07.04.2023.
//

import UIKit

class OwnDetailViewController: DetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        connectButton.isHidden = true

        setupMenu()
    }
}

// MARK: - UI + Constraints
extension OwnDetailViewController {
    private func setupMenu() {
        let deleteAction = UIAction(title: "Remove", attributes: .destructive) { _ in
            let alertController = UIAlertController(title: "Are you sure you want to delete this post?", message: "After deletion, you and users will not be able to see this post, it will be impossible to restore it.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
                print("deleting...")
                guard let publicationID = self.publication?.id else { return }
                FireStoreManager.shared.deletePublication(withId: publicationID) { result in
                    switch result {
                    case .success:
                        print("Succesufuly deleted")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
        }

        let editAction = UIAction(title: "Edit") { _ in
            // код для редактирования
        }

        let actionsMenu = UIMenu(title: "", children: [editAction, deleteAction])
        let button = createRoundedButton()
        button.showsMenuAsPrimaryAction = true
        button.menu = actionsMenu

        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }

    func createRoundedButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.backgroundColor = .backgroundColor.withAlphaComponent(0.2)
        button.tintColor = .accentColor
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.snp.makeConstraints { $0.height.width.equalTo(32) }
        return button
    }
}
