//
//  PostViewController_3.swift
//  Pawpet
//
//  Created by Robert Miller on 11.04.2023.
//

import UIKit
import SnapKit

class PostViewController_3: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var isCrossbreed = false
    public var isFirstBreed = false

    private let breeds = Breed.generateBreeds()
    private var filteredBreeds = [Breed]()
    private var isSearching = false
    private var selectedBreed: Breed?

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

    private var promptView = PromptView(with: "Select the breed of your pet.",
                                        and: "", titleSize: 28)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.accentColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if isCrossbreed && isFirstBreed {
            promptView.titleLabel.text = "Select the first breed of the crossbreed"
        }
        else if isCrossbreed && !isFirstBreed {
            promptView.titleLabel.text = "Select the second breed of the crossbreed"
        }

        setupViews()
        setupConstraints()
    }
}

// MARK: - UI + Constraints
extension PostViewController_3 {
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
            make.top.equalToSuperview().inset(60)
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

        searchBar.placeholder = "Search your pet's breed "
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
    }
}

//MARK: - TableView DataSource
extension PostViewController_3 {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredBreeds.count : breeds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let breed = isSearching ? filteredBreeds[indexPath.row] : breeds[indexPath.row]
        cell.textLabel?.text = breed.name
        cell.accessoryType = breed.isChecked ? .checkmark : .none
        cell.tintColor = .systemGreen
        let selectionColorView = UIView()
        selectionColorView.backgroundColor = .clear
        cell.selectedBackgroundView = selectionColorView

        return cell
    }
}

//MARK: - TableView Delegate
extension PostViewController_3 {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let breed = isSearching ? filteredBreeds[indexPath.row] : breeds[indexPath.row]

        if let selectedBreed = selectedBreed {
            if breed.name == selectedBreed.name {
                breed.isChecked = !breed.isChecked
                selectedBreed.isChecked = breed.isChecked
                if (nextButton.isHidden) {
                    showButtonWithAnimation()
                } else {
                    hideButtonWithAnimation()
                }
            } else {
                selectedBreed.isChecked = false
                breed.isChecked = true
                self.selectedBreed = breed
                showButtonWithAnimation()
            }
        } else {
            breed.isChecked = true
            selectedBreed = breed
            showButtonWithAnimation()
        }

        tableView.reloadData()
    }
}

// MARK: - SearchBar Delegate
extension PostViewController_3: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredBreeds = breeds.filter({ $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() })
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
extension PostViewController_3 {
    @objc private func nextButtonTapped(_ sender: UIButton) {
        print("Email entered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.isCrossbreed && self.isFirstBreed {
                let secondBreedVC = PostViewController_3()
                secondBreedVC.isCrossbreed = true
                secondBreedVC.isFirstBreed = false

                self.navigationController?.pushViewController(secondBreedVC, animated: true)
            } else {
                self.navigationController?.pushViewController(PostViewController_4(), animated: true)
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
}
