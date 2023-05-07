//
//  EditPostViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 03.05.2023.
//

import UIKit

protocol EditPostDelegate {
    func didProvideUpdate(with newPublication: Publication)
}

class EditPostViewController: UITableViewController {

    // MARK: PromptView
    public var promptView = PromptView(with: "Publication editing", and: "To save the changed information, click on the save button in the upper right corner.")

    // MARK: Buttons
    private lazy var saveButton: UIBarButtonItem = {
        let customAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.accentColor]
        let saveButtonTitle = NSAttributedString(string: "Save".localize(), attributes: customAttributes)
        let saveButton = UIButton(type: .system)
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        return saveBarButton
    }()

    var oldPublication: Publication?
    var publication: Publication?

    var changedData: [String : Any] = [:]
    var postDelegate: EditPostDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideKeyboardWhenTappedAround()
        setupNavigationAppearence()
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: - UI + Constraints
extension EditPostViewController {
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(EditableTableViewCell.self, forCellReuseIdentifier: "editableCell")

        tableView.backgroundColor = .white
    }
}

// MARK: - TableView DataSource
extension EditPostViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return EditPostSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = EditPostSection(rawValue: section) else { return 0 }

        switch section {
        case .petType, .info:
            return 3
        case .price:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = EditPostSection(rawValue: indexPath.section) else { return UITableViewCell() }
        guard let publication = publication else { return UITableViewCell() }

        let cell = tableView.dequeueReusableCell(withIdentifier: "editableCell", for: indexPath) as! EditableTableViewCell
        cell.accessoryType = .disclosureIndicator
        
        switch section {
        case .petType:
            // IF PetType
            if indexPath.row == 0 {
                cell.leftLabel.text = "Pet type"
                cell.rightLabel.text = publication.petInfo.petType.getName()
            }
            // IF IsCrossBreed
            else if indexPath.row == 1 {
                let isCrossbreed = publication.petInfo.isCrossbreed ?? false
                let toggle = UISwitch()
                toggle.isOn = isCrossbreed
                toggle.addTarget(self, action: #selector(breedTogglerTapped(_:)), for: .touchUpInside)
                cell.accessoryView = toggle
                cell.accessoryType = .none
                cell.leftLabel.text = "Crossbreed factor"
            }
            // IF Breed
            else if indexPath.row == 2 {
                cell.leftLabel.text = "Breed"
                cell.rightLabel.text = publication.petInfo.breed
                if publication.petInfo.secondBreed != nil {
                    if  !(publication.petInfo.secondBreed!.isEmpty) {
                        cell.rightLabel.text = publication.petInfo.breed + " & " + publication.petInfo.secondBreed!
                    }
                }
            }
        case .info:
            // IF Age
            if indexPath.row == 0 {
                cell.leftLabel.text = "Age"
                cell.rightLabel.text = "\(publication.petInfo.age) monthes."
            }
            // If Params
            else if indexPath.row == 1 {
                cell.leftLabel.text = "Detail info"
            }
            // If description
            else if indexPath.row == 2 {
                cell.leftLabel.text = "Description"
                cell.rightLabel.text = ""
            }
        case .price:
            cell.leftLabel.text = "Price"
            cell.rightLabel.text = "\(publication.price.formatPrice()) \(publication.currency.inCurrencySymbol())"
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EditPostViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("section: \(indexPath.section), row: \(indexPath.row)")

        if indexPath.section == 0 {
            if indexPath.row == 0 { changePetTypeSelected() }
            else if indexPath.row == 2 { changeBreedSelected() }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 { changeAgeSelected() }
            else if indexPath.row == 1 { changeDetailInfoSelected() }
            else if indexPath.row == 2 { changeDescriptionSelected() }
        }
        else if indexPath.section == 2 { changePriceSelected() }
    }
}

// MARK: - Row Selecitons Logic
extension EditPostViewController {

    // MARK: CHANGE PET TYPE
    private func changePetTypeSelected() {
        let animalSelectionVC = AnimalSelectionBottomSheetViewController()
        animalSelectionVC.animalSelectionView.chapterCollectionView.selectItem(withPetType: publication!.petInfo.petType)
        animalSelectionVC.animalSelectionView.promptView.setupTitles(title: "Change the type of pet", subtitle: "")
        animalSelectionVC.animalSelectionView.promptView.subtitleLabel.attributedText = " Carefully. Changing the type of pet will reset all existing data!".createAttributedString(withHighlightedWord: "❗️Carefully")
        animalSelectionVC.modalPresentationStyle = .overCurrentContext
        animalSelectionVC.callback = {
            let selectedType = animalSelectionVC.animalSelectionView.chapterCollectionView.selectedType
            print("Selected pet type: \(selectedType)")
            if self.publication?.petInfo.petType != selectedType {
                self.publication?.petInfo.petType = selectedType
                self.resetAllValues()
            }
        }
        self.present(animalSelectionVC, animated: false)
    }

    // MARK: CHANGE BREED
    private func changeBreedSelected() {
        let breedVC = BreedEditViewController()
        let navigationController = UINavigationController(rootViewController: breedVC)
        navigationController.modalPresentationStyle = .fullScreen
        breedVC.isCrossbreed = publication?.petInfo.isCrossbreed ?? false
        breedVC.isFirstBreed = publication?.petInfo.isCrossbreed ?? false
        breedVC.editPostDelegate = self
        present(navigationController, animated: true)
    }

    // MARK: CHANGE AGE
    private func changeAgeSelected() {
        let ageSelectionVC = AgeSelectionBottomSheetViewController()
        ageSelectionVC.modalPresentationStyle = .overCurrentContext
        ageSelectionVC.ageSelectionView.promptView.setupTitles(
            title: "Select your pet's age".localize(),
            subtitle: "Please, if your pet is a newborn, set the year and month values to be zero.".localize())
        ageSelectionVC.ageSelectionView.agePickerView.setupAge(age: publication!.petInfo.age)
        ageSelectionVC.callback = {
            let newAge = ageSelectionVC.ageSelectionView.agePickerView.getAgeInMonth()
            self.changedData["age"] = newAge
            self.publication?.petInfo.age = newAge
            self.tableView.reloadData()
        }
        self.present(ageSelectionVC, animated: false)
    }

    // MARK: CHANGE Pet detail info
    private func changeDetailInfoSelected() {
        let detailPetInfoVC = PetInfoSelectionBottomSheetViewController()
        publication?.petInfo.isMale ?? true ? (detailPetInfoVC.petInfoView.maleButtonTapped()) : (detailPetInfoVC.petInfoView.femaleButtonTapped())
        detailPetInfoVC.petInfoView.setupTogglers(
            isVaccinated: publication?.petInfo.isVaccinated ?? false,
            isCupping: publication?.petInfo.isCupping ?? false,
            isSterilized: publication?.petInfo.isSterilized ?? false,
            isWithDocs: publication?.petInfo.isWithDocuments ?? false)
        detailPetInfoVC.modalPresentationStyle = .overCurrentContext
        detailPetInfoVC.callBack = { [weak self] in
            self?.publication?.petInfo.isVaccinated = detailPetInfoVC.petInfoView.isVacinated
            self?.publication?.petInfo.isCupping = detailPetInfoVC.petInfoView.isCupping
            self?.publication?.petInfo.isSterilized = detailPetInfoVC.petInfoView.isSterilized
            self?.publication?.petInfo.isWithDocuments = detailPetInfoVC.petInfoView.isWithDocuments

            self?.changedData["isVaccinated"] = detailPetInfoVC.petInfoView.isVacinated
            self?.changedData["isCupping"] = detailPetInfoVC.petInfoView.isCupping
            self?.changedData["isSterilized"] = detailPetInfoVC.petInfoView.isSterilized
            self?.changedData["isWithDocuments"] = detailPetInfoVC.petInfoView.isWithDocuments
            self?.tableView.reloadData()
        }
        self.present(detailPetInfoVC, animated: false)
    }

    // MARK: CHANGE DESCRIPTION
    private func changeDescriptionSelected() {
        let changeDescriptionVC = EditDescriptionViewController()
        changeDescriptionVC.textView.text = publication?.petInfo.description
        changeDescriptionVC.callback = {
            let newDescription = changeDescriptionVC.textView.text
            self.changedData["description"] = newDescription
        }
        navigationController?.pushViewController(changeDescriptionVC, animated: true)
    }


    // MARK: CHANGE PRICE
    private func changePriceSelected() {
        let priceSelectionVC = PriceSelectionBottomSheetViewController()
        priceSelectionVC.priceSelectionView.setupCurrencySymbol(with: publication?.currency ?? "")
        priceSelectionVC.priceSelectionView.setupPrice(price: publication?.price ?? 0)
        priceSelectionVC.modalPresentationStyle = .overCurrentContext
        priceSelectionVC.callback = { [weak self] in
            let currency = priceSelectionVC.priceSelectionView.priceTF.currency
            var price = Int(priceSelectionVC.priceSelectionView.priceTF.text ?? "0") ?? 0
            if priceSelectionVC.priceSelectionView.isFreeControl.selectedItem == "FREE" { price = 0 }
            self?.changedData["price"] = price
            self?.changedData["currency"] = currency

            self?.publication?.price = price
            self?.publication?.currency = currency
            self?.tableView.reloadData()
        }
        self.present(priceSelectionVC, animated: false)
    }
}

// MARK: - HeaderView
extension EditPostViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 0 {
            view.addSubview(promptView)
            promptView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
            }
        }
        return view
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 100 : 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

// MARK: - Rest all values due to PetType change
extension EditPostViewController {
    private func resetAllValues() {
        self.publication?.petInfo.isCrossbreed = false
        self.publication?.petInfo.breed = ""
        self.publication?.petInfo.secondBreed = nil
        self.publication?.petInfo.age = 0
        self.publication?.petInfo.isCupping = false
        self.publication?.petInfo.isSterilized = false
        self.publication?.petInfo.isWithDocuments = false
        self.publication?.price = 0
        self.tableView.reloadData()
    }
}
// MARK: - Save & Toggler buttons logic
extension EditPostViewController {
    @objc func saveButtonTapped() {
        print(changedData)
        guard let publication = publication else { return }
        if publication.petInfo.breed.isEmpty {
            let errorAlert = ErrorAlertView()
            errorAlert.showAlert(with: "Oops! Error...", message: "Please provide all required data", on: self)
        } else if !changedData.isEmpty {
            PublicationManager.shared.updatePublication(oldPublication!, changedData: changedData) { result in
                switch result {
                case .success():
                    self.navigationController?.popViewController(animated: true)
                    self.postDelegate?.didProvideUpdate(with: publication)
                case .failure(let error):
                    let errorAlert = ErrorAlertView()
                    errorAlert.showAlert(with: "Oops! Error...", message: error.localizedDescription , on: self)
                }
            }
        }
    }

    @objc private func breedTogglerTapped(_ sender: UISwitch) {
        print("Toggler tapped")
        publication?.petInfo.isCrossbreed?.toggle()
        guard let isCrossBreed = publication?.petInfo.isCrossbreed else { return }
        changedData["isCrossbreed"] = isCrossBreed
        publication?.petInfo.isCrossbreed = isCrossBreed
        tableView.reloadData()
    }
}

// MARK: - Section ENUM
extension EditPostViewController {
    enum EditPostSection: Int, CaseIterable {
        case petType // PetType CrossBreed and Breed chosing
        case info // Age + Params + description
        case price
    }
}

// MARK: - Breed edit delegate
extension EditPostViewController: BreedEditDelegate {
    func provideFirstBreed(with breed: String) {
        publication?.petInfo.breed = breed
        changedData["breed"] = breed
        tableView.reloadData()
    }

    func provideSecondBreed(with breed: String) {
        print("Second breed provided")
        publication?.petInfo.secondBreed = breed
        changedData["seconBreed"] = breed
        tableView.reloadData()
    }
}

