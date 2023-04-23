//
//  ProfileEditViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 21.04.2023.
//

import UIKit

class ProfileEditViewController: UITableViewController {

    enum Section: Int, CaseIterable {
           case nameAndSurname = 0
           case geo
           case contactInfo
           case password
           case logout
       }

    // MARK: - ImageView
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .random()
        imageView.contentMode = .scaleAspectFill
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationAppearence()
        navigationItem.rightBarButtonItem = saveButton
        configureTableView()
    }
}

// MARK: - UI + Constraints
extension ProfileEditViewController {
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(TextFieldTableViewCell.self, forCellReuseIdentifier: "textFieldCell")
        tableView.backgroundColor = .white
    }
}

// MARK: - TableView DataSource
extension ProfileEditViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
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
            cell.backgroundColor = .backgroundColor
            return cell

        case .geo, .contactInfo, .password:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .backgroundColor
            cell.accessoryType = .disclosureIndicator

            let leftLabel = UILabel()
            let rightLabel = UILabel()

            leftLabel.textColor = .accentColor
            rightLabel.textColor = .subtitleColor

            cell.contentView.addSubview(leftLabel)
            cell.contentView.addSubview(rightLabel)

            leftLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }

            rightLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }

            switch section {
            case .geo:
                leftLabel.text = "Change location"
                rightLabel.text = "Russia, Moscow"
            case .contactInfo:
                if indexPath.row == 0 {
                    leftLabel.text = "Change email"
                    rightLabel.text = "email@mail.com"
                } else {
                    leftLabel.text = "Change phone number"
                    rightLabel.text = "+7 913 333 33 33"
                }
            case .password:
                leftLabel.text = "Change password"
                rightLabel.text = "••••••"
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

        // Выполните соответствующие действия для выбранной ячейки
    }
}

// MARK: - Button Logic
extension ProfileEditViewController {
    @objc private func changeAvatarButtonTapped(_ sender: UIButton) {

    }

    @objc func saveButtonTapped() {

    }
}

