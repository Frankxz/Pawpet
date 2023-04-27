//
//  SignUpViewController6.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit
import SnapKit

class SignUpViewController6: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let countries = Country.createCountries()
    private var filteredCountries = [Country]()
    private var isSearching = false
    private var selectedCountry: Country?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Continue")
        return button
    }()

    private var promptView = PromptView(with: "Select your country.",
                                        and: "", titleSize: 28)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        addKeyBoardObservers()
        hideKeyboardWhenTappedAround()
        setupNavigationAppearence()
    }
}

// MARK: - Observers
extension SignUpViewController6 {
    private func addKeyBoardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

// MARK: - UI + Constraints
extension SignUpViewController6 {
    func setupViews() {
        view.addSubview(promptView)
        view.addSubview(tableView)
        view.addSubview(searchBar)
        view.addSubview(nextButton)

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setSearchBar()

        nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        nextButton.isHidden = true
    }

    func setupConstraints() {
        promptView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(100)
        }

        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(promptView.snp.bottom)
        }

        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }

    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        let imageOffset = UIOffset(horizontal: 15, vertical: 0)
        let textOffset = UIOffset(horizontal: 5, vertical: 0)
        searchBar.setPositionAdjustment(imageOffset, for: .search)
        searchBar.searchTextPositionAdjustment = textOffset

        searchBar.placeholder = "Search your country.."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

//MARK: - TableView DataSource
extension SignUpViewController6 {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCountries.count : countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let country = isSearching ? filteredCountries[indexPath.row] : countries[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(country.geoCode.geoCodeToEmoji()) \(country.name)"
        cell.accessoryType = country.isChecked ? .checkmark : .none
        cell.tintColor = .systemGreen
        let selectionColorView = UIView()
        selectionColorView.backgroundColor = .clear
        cell.selectedBackgroundView = selectionColorView

        return cell
    }
}

//MARK: - TableView Delegate
extension SignUpViewController6 {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let country = isSearching ? filteredCountries[indexPath.row] : countries[indexPath.row]

        if let selectedCountry = selectedCountry {
            if country.name == selectedCountry.name {
                country.isChecked = !country.isChecked
                selectedCountry.isChecked = country.isChecked
                if (nextButton.isHidden) {
                    showButtonWithAnimation()
                } else {
                    hideButtonWithAnimation()
                }
            } else {
                selectedCountry.isChecked = false
                country.isChecked = true
                self.selectedCountry = country
                showButtonWithAnimation()
            }
        } else {
            country.isChecked = true
            selectedCountry = country
            showButtonWithAnimation()
        }

        tableView.reloadData()
    }
}

// MARK: - SearchBar Delegate
extension SignUpViewController6: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = countries.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
        isSearching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}

// MARK: - Button logic
extension SignUpViewController6 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let signUpVC7 = SignUpViewController7()
            let cities = signUpVC7.findCities(for: self.selectedCountry!.name)
            if cities.count != 0 {
                self.navigationController?.pushViewController(signUpVC7, animated: true)
                UserDefaults.standard.set(self.selectedCountry!.name, forKey: "COUNTRY")
            } else {
                UserDefaults.standard.set(self.selectedCountry!.name, forKey: "COUNTRY")
                UserDefaults.standard.set("", forKey: "CITY")
                FireStoreManager.shared.saveUserDataFromUD()
                self.navigationController?.pushViewController(SignUpViewController_final(), animated: true)
            }
        }
        // TODO: - StorageManager
    }

    private func hideButtonWithAnimation(duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration, animations: {
            self.nextButton.transform = CGAffineTransform(translationX: self.nextButton.frame.width, y: 0)
        }) { (finished) in
            self.nextButton.isHidden = true
        }
        print("Button hided")
    }

    private func showButtonWithAnimation() {
        self.nextButton.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.nextButton.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        print("Button showed")
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            nextButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(keyboardHeight + 10)
                make.height.equalTo(70)
            }

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        nextButton.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(70)
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}