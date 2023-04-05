//
//  BottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 28.03.2023.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate {
    func subviewToFront()
    func subviewToBack()
}

class BottomSheetView: UIView {

    // MARK: - Reqiered properties
    private var currentHeight: CGFloat = UIScreen.main.bounds.height * 0.6
    private var maxHeight: CGFloat = (UIScreen.main.bounds.height * 0.89)
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height * 0.6

    var containerViewHeightConstraint: Constraint?
    var containerViewBottomConstraint: Constraint?

    var delegate: MainViewControllerDelegate?

    // MARK: - UI Properties
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear

        setupPanGesture()
        configureView()

        self.containerViewBottomConstraint?.deactivate()
        self.containerView.snp.makeConstraints { make in
            self.containerViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        self.layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension BottomSheetView {
    func configureView(){
        addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            containerViewHeightConstraint = make.height.equalTo(defaultHeight).constraint
        }

        containerView.snp.makeConstraints { make in
            containerViewBottomConstraint = make.bottom.equalToSuperview().offset(defaultHeight).constraint
        }

        containerViewHeightConstraint?.activate()
        containerViewBottomConstraint?.activate()
    }
}

// MARK: - Animations
extension BottomSheetView {
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.deactivate()
            self.containerView.snp.makeConstraints { make in
                self.containerViewBottomConstraint = make.bottom.equalToSuperview().constraint
            }
            self.layoutIfNeeded()
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.deactivate()
            self.containerView.snp.makeConstraints { make in
                self.containerViewHeightConstraint = make.height.equalTo(height).constraint
            }

            self.layoutIfNeeded()
        }
        currentHeight = height
    }
}

// MARK: - Gesture Rocognizer
extension BottomSheetView {
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y

        switch gesture.state {
        case.changed:
            if newHeight < maxHeight && newHeight > defaultHeight {
                self.containerViewHeightConstraint?.deactivate()
                self.containerView.snp.makeConstraints { make in
                    self.containerViewHeightConstraint = make.height.equalTo(newHeight).constraint
                }
                layoutIfNeeded()
            }
        case .ended:
            // If  new height < default animate back to default
            if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
                delegate?.subviewToBack()
            }
            // If new height < max and going down -> set to default height
            else if newHeight < maxHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
                delegate?.subviewToBack()
            }
            // If new height < max and going up -> set to max height
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maxHeight)
                delegate?.subviewToFront()
            }
        default:
            break
        }
    }
}
