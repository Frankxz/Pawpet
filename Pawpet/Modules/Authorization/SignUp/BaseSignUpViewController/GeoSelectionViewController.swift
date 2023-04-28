//
//  GeoSelectionViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 28.04.2023.
//

import UIKit
import SnapKit

class GeoSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var geoObjects: [GeoObject] = []
    private var filteredGeoObjects = [GeoObject]()
    private var isSearching = false
    private var type: GeoVCType
    public var selectedGeoObject: GeoObject?

    // MARK: - TableView initialization
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: - Search Bar
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    // MARK: - NextButton
    public lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Continue")
        return button
    }()

    // MARK: PromptView
    private var promptView = PromptView(with: "Select your country:",
                                        and: "", titleSize: 28)

    // MARK: - INITS
    init(geoObjects: [GeoObject], geoVCType: GeoVCType) {
        self.type = geoVCType
        self.geoObjects = geoObjects
        if type == .city {
            promptView.setupTitles(title: "Select your city:", subtitle: "")
        }
        super.init(nibName: nil, bundle: nil)
        
        tableView.reloadData()
        print(geoObjects.count)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        type = .country
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

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
    }
}

//MARK: - TableView DataSource
extension GeoSelectionViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredGeoObjects.count : geoObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let geoObject = isSearching ? filteredGeoObjects[indexPath.row] : geoObjects[indexPath.row]

        if type == .country {
            let country = geoObject as! Country
            cell.textLabel?.text = "\(country.geoCode.geoCodeToEmoji()) \(country.name)"
        } else {
            cell.textLabel?.text = geoObject.name
        }

        cell.accessoryType = geoObject.isChecked ? .checkmark : .none
        cell.tintColor = .systemGreen
        cell.textLabel?.numberOfLines = 0

        let selectionColorView = UIView()
        selectionColorView.backgroundColor = .clear
        cell.selectedBackgroundView = selectionColorView

        return cell
    }
}

//MARK: - TableView Delegate
extension GeoSelectionViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let geoObject = isSearching ? filteredGeoObjects[indexPath.row] : geoObjects[indexPath.row]

        if let selectedGeoObject = selectedGeoObject {
            if geoObject.name == selectedGeoObject.name {
                geoObject.isChecked = !geoObject.isChecked
                selectedGeoObject.isChecked = geoObject.isChecked
                if (nextButton.isHidden) {
                    showButtonWithAnimation()
                } else {
                    hideButtonWithAnimation()
                }
            } else {
                selectedGeoObject.isChecked = false
                geoObject.isChecked = true
                self.selectedGeoObject = geoObject
                showButtonWithAnimation()
            }
        } else {
            geoObject.isChecked = true
            selectedGeoObject = geoObject
            showButtonWithAnimation()
        }

        tableView.reloadData()
    }
}

// MARK: - SearchBar Delegate
extension GeoSelectionViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredGeoObjects = geoObjects.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
        isSearching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}

// MARK: - Animation logic
extension GeoSelectionViewController {
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

// MARK: - UI + Constraints
extension GeoSelectionViewController {
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

        searchBar.placeholder = "Search your location..."
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

// MARK: - Observers
extension GeoSelectionViewController {
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

// MARK: - Cities fetching
extension GeoSelectionViewController {
    func findCities(for country: String) -> [GeoObject]{
        guard let path = Bundle.main.path(forResource: "countries", ofType: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

            if let citiesDict = jsonResult as? [String: [String]],
               let fethcedCities = citiesDict[country] {
                var cities: [GeoObject] = []
                for item in fethcedCities {
                    let city = GeoObject(name: item, isChecked: false)
                    cities.append(city)
                    print("\(item) add")
                }
                print(cities.count)
                return cities
            } else { return []}
        } catch { return []}
    }
}

// MARK: Type
extension GeoSelectionViewController {
    enum GeoVCType {
        case country
        case city
    }
}
