//
//  ProfileEditViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 21.04.2023.
//

import UIKit
import Lottie
import Firebase
import FirebaseStorage

class ProfileEditViewController: UITableViewController {

    // MARK: - ImageView
    public var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .backgroundColor
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: PromptView
    public var promptView = PromptView(with: "Profile settings", and: "To save the changed information, click on the save button in the upper right corner.")

    // MARK: - Lottie View
    public var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Loading")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

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

    // MARK: AlertView
    private let alertView = SuccessAlertView()

    var phoneNumber: String?
    var sectionCount = Section.allCases.count
    var callBack: ()->() = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        user = FireStoreManager.shared.user

        configureTableView()
        hideKeyboardWhenTappedAround()
        setupNavigationAppearence()

        navigationItem.rightBarButtonItem = saveButton
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
        case .nameAndSurname, .contactInfo, .geo:
            return 2
        case .logout, .password:
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
                if indexPath.row == 0 {
                    cell.leftLabel.text = "Change location"
                    cell.rightLabel.text = "\(FireStoreManager.shared.user.country ?? "Unselected"), \(FireStoreManager.shared.user.city ?? "")"
                } else if indexPath.row == 1 {
                    cell.leftLabel.text = "Change currency"
                    cell.rightLabel.text = FireStoreManager.shared.user.currency ?? "?"
                }
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
            view.addSubview(animationView)

            animationView.snp.makeConstraints { make in
                make.top.equalTo(avatarImageView.snp.top).inset(-30)
                make.height.width.equalTo(160)
                make.centerX.equalToSuperview()
            }

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

            hideAnimationView()
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
            if indexPath.row == 0 { locationRowSelected() }
            else if indexPath.row == 1 { currencyRowSelected() }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 { emailRowSelected() }
            else if indexPath.row == 1 { phoneRowSelected() }
        }
        else if indexPath.section == 3 { passwordRowSelected() }
        else if indexPath.section == 4 { logout() }
    }
}

// MARK: - ROW Selection LOGIC
extension ProfileEditViewController {
    private func emailRowSelected() {
        let emailChangeVC = EmailChangeViewController()
        emailChangeVC.editVCDelegate = self
        navigationController?.pushViewController(emailChangeVC, animated: true)
    }

    private func passwordRowSelected() {
        let changePasswordVC = PasswordChangeViewController()
        changePasswordVC.editVCDelegate = self
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }

    private func currencyRowSelected() {
        let currencyChangeVC = CurrencySelectionBottomSheetViewController()
        currencyChangeVC.modalPresentationStyle = .overCurrentContext
        currencyChangeVC.currencyDelegate = self
        self.present(currencyChangeVC, animated: false)
    }

    private func locationRowSelected() {
        let countryEditVC = CountryChangeViewController(geoObjects: GeoManager.shared.getAllCountries(localize: .ru), geoVCType: .country)

        countryEditVC.callback = { [self] in
            self.user = FireStoreManager.shared.user
            tableView.reloadData()
            self.saveButtonTapped()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.alertView.showAlert(with: "Location successfully changed.", message: "Current location: \(self.user.country ?? ""), \(self.user.city ?? "")", on: self)
            }
        }

        let navigationVC = UINavigationController(rootViewController: countryEditVC)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }

    private func phoneRowSelected() {
        let phoneNumberChangeVC = PNChangeViewController1()

        phoneNumberChangeVC.callback = { [self] in
            tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.alertView.showAlert(with: "Ph. No. successfully changed.", message: "Current number: \(FireStoreManager.shared.getUserPhoneNumber())", on: self)
            }
        }

        let navigationVC = UINavigationController(rootViewController: phoneNumberChangeVC)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
}

// MARK: - Avatar changing
extension ProfileEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func changeAvatarButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        showAnimationView()

        FireStoreManager.shared.saveAvatarImage(image: selectedImage) { result in
            switch result {
            case .success(let imagePath):
                print("Image saved to Firebase Storage with path: \(imagePath)")
                let alertView = SuccessAlertView()
                self.avatarImageView.image = selectedImage
                self.hideAnimationView()
                FireStoreManager.shared.user.isChanged = true
                alertView.showAlert(with: "Avatar successfully changed.", message: "", on: self)
            case .failure(let error):
                self.hideAnimationView()
                print("Error saving image to Firebase Storage: \(error.localizedDescription)")
            }
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Save & Logout buttons logic
extension ProfileEditViewController {
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let textWithNewChar = text + string
        print(textWithNewChar)
        textField.tag == 0 ? (user.name = textWithNewChar) : (user.surname = textWithNewChar)
        return true
    }
}

// MARK: - EmailChangeDelegate realization
extension ProfileEditViewController: EmailChangeDelegate {
    func showSuccessAlert(with newEmail: String) {
        let alertView = SuccessAlertView()
        alertView.showAlert(with: "Email successfully changed.", message: "Current email: \(newEmail)", on: self)
        tableView.reloadData()
    }
}

// MARK: - PasswordChangeDelegate realization
extension ProfileEditViewController: PasswordChangeDelegate {
    func showSuccesAlert() {
        let alertView = SuccessAlertView()
        alertView.showAlert(with: "Password successfully changed.", message: "", on: self)
    }
}

// MARK: - CurrencyChangeDelegate realization
extension ProfileEditViewController: CurrencyChangeDelegate {
    func currencySelected(currency: String) {
        FireStoreManager.shared.user.currency = currency
        FireStoreManager.shared.saveUserData(for: FireStoreManager.shared.user)
        tableView.reloadData()
    }
}

// MARK: - Section ENUM
extension ProfileEditViewController {
    enum Section: Int, CaseIterable {
        case nameAndSurname = 0
        case geo
        case contactInfo
        case password
        case logout
    }
}

// MARK: Animation View
extension ProfileEditViewController {
    func showAnimationView() {
        UIView.animate(withDuration: 0.15) {
            self.avatarImageView.isHidden = true
            self.animationView.isHidden = false
            self.animationView.play()
        }
    }

    func hideAnimationView() {
        UIView.animate(withDuration: 0.15) {
            self.avatarImageView.isHidden = false
            self.animationView.isHidden = true
            self.animationView.stop()
        }
    }
}
