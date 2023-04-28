//
//  ProfileEditViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 21.04.2023.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileEditViewController: UITableViewController {

    enum Section: Int, CaseIterable {
        case nameAndSurname = 0
        case geo
        case contactInfo
        case password
        case logout
    }

    var phoneNumber: String?
    var sectionCount = Section.allCases.count

    // MARK: - ImageView
    public var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .random()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: PromptView
    public var promptView = PromptView(with: "Profile settings", and: "To save the changed information, click on the save button in the upper right corner.")

    // MARK: Buttons
    private lazy var saveButton: UIBarButtonItem = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.accentColor]
        let saveButtonTitle = NSAttributedString(string: "Save", attributes: customAttributes)
        let saveButton = UIButton(type: .system)
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        return saveBarButton
    }()

    private lazy var changeAvatarButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(changeAvatarButtonTapped(_:)), for: .touchUpInside)
        let title = NSAttributedString(
            string: "Select new photo",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            ]
        )
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    // MARK: user properties
    private var user = PawpetUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        user = FireStoreManager.shared.user
        setupNavigationAppearence()
        navigationItem.rightBarButtonItem = saveButton
        configureTableView()
        hideKeyboardWhenTappedAround()
    }
}

// MARK: - UI + Constraints
extension ProfileEditViewController {
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.register(EditableTableViewCell.self, forCellReuseIdentifier: "editableCell")

        tableView.backgroundColor = .white
    }
}

// MARK: - TableView DataSource
extension ProfileEditViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }

        switch section {
        case .nameAndSurname, .contactInfo:
            return 2
        case .geo, .logout, .password:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .nameAndSurname:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField.placeholder = indexPath.row == 0 ? "Имя" : "Фамилия"
            cell.textField.tag = indexPath.row == 0 ? 0 : 1
            cell.textField.text = indexPath.row == 0 ? FireStoreManager.shared.user.name : FireStoreManager.shared.user.surname
            cell.backgroundColor = .backgroundColor
            cell.textField.delegate = self
            return cell

        case .geo, .contactInfo, .password:
            let cell = tableView.dequeueReusableCell(withIdentifier: "editableCell", for: indexPath) as! EditableTableViewCell
            
            switch section {
            case .geo:
                cell.leftLabel.text = "Change location"
                cell.rightLabel.text = "\(FireStoreManager.shared.user.country ?? "Unselected"), \(FireStoreManager.shared.user.city ?? "")"
            case .contactInfo:
                if indexPath.row == 0 {
                    cell.leftLabel.text = "Change email"
                    cell.rightLabel.text = FireStoreManager.shared.getUserEmail()
                } else {
                    cell.leftLabel.text = "Change phone number"
                    cell.rightLabel.text = phoneNumber
                }
            case .password:
                cell.leftLabel.text = "Change password"
                cell.rightLabel.text = "••••••"
            default:
                break
            }
            return cell

        case .logout:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .backgroundColor

            let logoutLabel = UILabel()
            logoutLabel.text = "Logout"
            logoutLabel.textColor = .systemRed
            cell.contentView.addSubview(logoutLabel)

            logoutLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }

            return cell
        }
    }
}

// MARK: - HeaderView
extension ProfileEditViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            view.addSubview(promptView)
            view.addSubview(avatarImageView)
            view.addSubview(changeAvatarButton)

            promptView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
            }

            avatarImageView.snp.makeConstraints { make in
                make.height.width.equalTo(120)
                make.centerX.equalToSuperview()
                make.top.equalTo(promptView.snp.bottom).offset(20)
            }

            changeAvatarButton.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.centerX.equalToSuperview()
                make.top.equalTo(avatarImageView.snp.bottom)
            }
        }
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 270 : 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
// MARK: - UITableViewDelegate
extension ProfileEditViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("section: \(indexPath.section), row: \(indexPath.row)")

        if indexPath.section == 1 {
            let countryChangeVC = CountryChangeViewController(geoObjects: Country.createCountries(), geoVCType: .country)
            countryChangeVC.callback = {
                self.user = FireStoreManager.shared.user
                tableView.reloadData()
                self.saveButtonTapped()
            }
            let navigationVC = UINavigationController(rootViewController: countryChangeVC)
            navigationVC.modalPresentationStyle = .fullScreen
            present(navigationVC, animated: true)
        }
        else if indexPath.section == 4 {
            logout()
        }
    }
}

// MARK: - Button Logic
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func changeAvatarButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        avatarImageView.image = selectedImage
        FireStoreManager.shared.saveAvatarImage(image: selectedImage) { result in
            switch result {
            case .success(let imagePath):
                print("Image saved to Firebase Storage with path: \(imagePath)")
            case .failure(let error):
                print("Error saving image to Firebase Storage: \(error.localizedDescription)")
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {
        FireStoreManager.shared.saveUserData(for: user)
        print("\(user.name ?? "") \(user.surname ?? "")")
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true)
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

// MARK: UITextFieldDelegate
extension ProfileEditViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.tag == 0 ? (user.name = textField.text) : (user.surname = textField.text)
    }

}
