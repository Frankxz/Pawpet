//
//  BreedTableViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit

class BreedSelectionViewController: UIViewController {
    public var isCrossbreed = false
    public var isFirstBreed = false

    private let breeds = Breed.generateBreeds()
    private var filteredBreeds = [Breed]()
    private var isSearching = false
    public var selectedBreed: Breed?

    var callBack: () -> () = {}

    // MARK: TableView
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: SearchBar
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    // MARK: Button
    public lazy var nextButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Continue")
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: PromptView
    public var promptView = PromptView(with: "Select the breed of pet.",
                                        and: "", titleSize: 28)
    override func viewDidLoad() {
        super.viewDidLoad()

        if isCrossbreed && isFirstBreed {
            promptView.titleLabel.text = "Select the first breed of the crossbreed"
        }
        else if isCrossbreed && !isFirstBreed {
            promptView.titleLabel.text = "Select the second breed of the crossbreed"
        }

        setupView()
        setupViews()
        setupConstraints()
        addKeyBoardObservers()
    }

    private func setupView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupNavigationAppearence()
    }
}

// MARK: - Observers
extension BreedSelectionViewController {
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
extension BreedSelectionViewController: UITableViewDelegate {
    func setupViews() {
        view.addSubview(promptView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(nextButton)


        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setSearchBar()

        nextButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        nextButton.isHidden = false
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
extension BreedSelectionViewController: UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}

//MARK: - TableView Delegate
extension BreedSelectionViewController {
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
extension BreedSelectionViewController: UISearchBarDelegate {
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
extension BreedSelectionViewController {
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

// MARK: - Next Button
extension BreedSelectionViewController {
    @objc private func nextButtonTapped() {
        callBack()
    }
}
