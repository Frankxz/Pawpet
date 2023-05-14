//
//  RegionTableViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 23.04.2023.
//

import UIKit

class RegionTableViewController: UIViewController {

    private var filteredCities = [GeoObject]()
    private var isSearching = false
    private var selectedCity: GeoObject?

    public var cities: [GeoObject] = []

    let userRegionCity = GeoObject(name: UserManager.shared.user.city!, isChecked: false)

    let tableView = UITableView()
    var callBack: ()->() = {}
    
    // MARK: SearchBar
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    // MARK: PromptView
    private var promptView = PromptView(with: "Select search region",
                                        and: "Select the cities where you want to find relevant publications.", titleSize: 28)

    // MARK: Button
    private lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
        button.setupTitle(for: "Select")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        findCities(for: "Russia")
        setupView()
    }
}

// MARK: - UI + Constraints
extension RegionTableViewController {
    private func setupView() {
        view.backgroundColor  = .white

        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        setupConstraints()
        addKeyBoardObserver()
        setSearchBar()

        tableView.register(CityTableViewCell.self, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier)

        nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        nextButton.isHidden = true
    }

    private func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(nextButton)
        view.addSubview(promptView)
        view.addSubview(searchBar)


        promptView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
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
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }

    private func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        let imageOffset = UIOffset(horizontal: 15, vertical: 0)
        let textOffset = UIOffset(horizontal: 5, vertical: 0)
        searchBar.setPositionAdjustment(imageOffset, for: .search)
        searchBar.searchTextPositionAdjustment = textOffset

        searchBar.placeholder = "Search city...".localize()
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

// MARK: - SearchBar Delegate
extension RegionTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCities = cities.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
        isSearching = true
        isSearching = !searchText.isEmpty
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        print("canceled")
        searchBar.text = ""
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension RegionTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return section == 0 ? 0 : filteredCities.count
        } else {
            return section == 0 ? 1 : cities.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier, for: indexPath) as! CityTableViewCell
        if isSearching {
            let city = filteredCities[indexPath.row]
            cell.configure(city: city)
            return cell
        } else {
            let city = indexPath.section == 0 ? userRegionCity : cities[indexPath.row]
            cell.configure(city: city)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var city: GeoObject!
        if isSearching {
            city = filteredCities[indexPath.row]
        } else {
            city = indexPath.section == 0 ? userRegionCity : cities[indexPath.row]
        }

        city.isChecked.toggle()
        if let cell = tableView.cellForRow(at: indexPath) as? CityTableViewCell {
            cell.configure(city: city)
        }

        let selectedCities = getCheckedCities()
        selectedCities.isEmpty ? hideButtonWithAnimation() : showButtonWithAnimation()
    }
}

// MARK: Header
extension RegionTableViewController {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.text = "All regions".localize()
        label.textColor = .subtitleColor
        label.font = .systemFont(ofSize: 18)
        view.backgroundColor = .white
        view.addSubview(label)

        if section == 0 {
            label.text = "Your current region".localize()
            label.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalToSuperview()
            }
        } else {
            label.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalToSuperview()
            }
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: - Cities fetching
extension RegionTableViewController {
    func findCities(for country: String){
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            return
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            if let citiesDict = jsonResult as? [String: [String]],
               let fethcedCities = citiesDict[country] {
                for item in fethcedCities {
                    let city = GeoObject(name: item, isChecked: false)
                    self.cities.append(city)
                    print("\(item) add")
                }
                print(self.cities.count)
                tableView.reloadData()
                return
            } else { return }
        } catch { return }
    }

    func getCheckedCities() -> [GeoObject] {
        var checkedCities = [GeoObject]()

        if userRegionCity.isChecked {
            checkedCities.append(userRegionCity)
        }

        checkedCities.append(contentsOf: cities.filter { $0.isChecked })

        return checkedCities
    }
}

// MARK: - Button logic
extension RegionTableViewController {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        callBack()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationController?.popViewController(animated: true)
        }
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
}

