//
//  SearchAlertView.swift
//  Pawpet
//
//  Created by Robert Miller on 10.05.2023.
//

import UIKit

protocol SearchAlertViewDelegate {
    func didSelectVariant(breed: String)
}

class SearchAlertView: UIView {

    var variants: [SearchVariant] = []
    var targetView: UIView = UIView()
    var delegate: SearchAlertViewDelegate?

    // MARK: - TableView initialization
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        backgroundColor = .backgroundColor
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension SearchAlertView {
    func setupView() {
        backgroundColor = .accentColor
        tableView.backgroundColor = .accentColor
        tableView.layer.cornerRadius = 8
        self.layer.cornerRadius = 8
        tableView.separatorColor = .white
        addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}

//MARK: - TableView DataSource
extension SearchAlertView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let searchVariant = variants[indexPath.row]
        //cell.accessoryType  = .disclosureIndicator
        let rightView = UIImageView(image: UIImage(systemName: "arrow.right"))
        rightView.tintColor = .white
        cell.accessoryView = rightView
        cell.backgroundColor = .accentColor
        cell.textLabel?.text = searchVariant.getVariant()
        cell.selectionStyle = .none
        cell.textLabel?.textColor = .white
        return cell
    }
}

//MARK: - TableView Delegate
extension SearchAlertView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let variant = variants[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectVariant(breed: variant.breed)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
}

// MARK: - Popover logic
extension SearchAlertView {
    func show(on view: UIView) {
        self.targetView = view
        view.addSubview(self)
        self.frame = getFrame(for: .hide)

        UIView.animate(withDuration: 0.25, animations: {
            self.frame = self.getFrame(for: .show)
        })
    }

    func update(with variants: [SearchVariant]) {
        UIView.animate(withDuration: 0.25, animations: {
            self.variants = variants
            self.tableView.reloadData()
            self.frame = self.getDynamicFrame(for: variants)
        })
    }

    func hide() {
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = self.getFrame(for: .hide)
        })
    }
}

extension SearchAlertView {
    private func getFrame(for type: AlertFrameType) -> CGRect {
        if type == .hide {
           return CGRect(x: 0, y: 140,
                         width: targetView.bounds.width, height: 0)
        } else {
           return CGRect(x: 0, y: 140,
                         width: targetView.bounds.width, height: 0)
        }
    }

    private func getDynamicFrame(for variants: [SearchVariant]) -> CGRect {
        let maxHeight: CGFloat = 120
        var height: CGFloat = 0
        for _ in variants { if height < maxHeight { height += 40 }}
        return CGRect(x: 0, y: 140, width: targetView.bounds.width, height: height)
    }

    enum AlertFrameType {
        case hide
        case show
    }
}

class SearchVariant {
    let petType: PetType
    let breed: String

    init(petType: PetType, breed: String) {
        self.petType = petType
        self.breed = breed
    }

    func getVariant() -> String{
        "\(breed.localize())"
    }
}
