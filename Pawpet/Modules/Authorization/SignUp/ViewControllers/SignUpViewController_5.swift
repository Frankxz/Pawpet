//
//  SignUpViewController_6.swift
//  Pawpet
//
//  Created by Robert Miller on 13.04.2023.
//

import UIKit

class SignUpViewController_5: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var filteredCities = [City]()
    private var isSearching = false
    private var selectedCity: City?

    public var cities: [City] = []

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

    private var promptView = PromptView(with: "Select your city.",
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

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        print(cities.count)
    }
}

// MARK: - Observers
extension SignUpViewController_5 {
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
extension SignUpViewController_5 {
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

        searchBar.placeholder = "Search your city.."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

//MARK: - TableView DataSource
extension SignUpViewController_5 {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCities.count : cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = isSearching ? filteredCities[indexPath.row] : cities[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = city.name
        cell.accessoryType = city.isChecked ? .checkmark : .none
        cell.tintColor = .systemGreen
        let selectionColorView = UIView()
        selectionColorView.backgroundColor = .clear
        cell.selectedBackgroundView = selectionColorView

        return cell
    }
}

//MARK: - TableView Delegate
extension SignUpViewController_5 {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let city = isSearching ? filteredCities[indexPath.row] : cities[indexPath.row]

        if let selectedCity = selectedCity {
            if city.name == selectedCity.name {
                city.isChecked = !city.isChecked
                selectedCity.isChecked = city.isChecked
                if (nextButton.isHidden) {
                    showButtonWithAnimation()
                } else {
                    hideButtonWithAnimation()
                }
            } else {
                selectedCity.isChecked = false
                city.isChecked = true
                self.selectedCity = city
                showButtonWithAnimation()
            }
        } else {
            city.isChecked = true
            selectedCity = city
            showButtonWithAnimation()
        }

        tableView.reloadData()
    }
}

// MARK: - SearchBar Delegate
extension SignUpViewController_5: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = cities.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
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
extension SignUpViewController_5 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.pushViewController(SignUpViewController_final(), animated: true)
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

// MARK: - Cities fetching
extension SignUpViewController_5 {
    func findCities(for country: String) -> [String]{
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            if let citiesDict = jsonResult as? [String: [String]],
               let fethcedCities = citiesDict[country] {
                for item in fethcedCities {
                    let city = City(name: item)
                    self.cities.append(city)
                    print("\(item) add")
                }
                print(self.cities.count)
                tableView.reloadData()
                return fethcedCities
            } else { return []}
        } catch { return []}
    }
}
