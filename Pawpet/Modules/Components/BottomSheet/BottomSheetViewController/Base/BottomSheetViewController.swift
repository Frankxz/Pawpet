//
//  BottomSheetViewController.swift
//  Pawpet
//
//  Created by Robert Miller on 22.04.2023.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {

    // MARK: - Reqiered properties
    private var currentHeight: CGFloat = 560
    private var maxHeight: CGFloat = 560
    private var defaultHeight: CGFloat = 560
    private var dismissibleHeight: CGFloat = 560
    private let maxDimmedAlpha: CGFloat = 0.6

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

    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.6
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupPanGesture()
        setupDimmedPanGesture()
        configureView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateDimmedView()
        animatePresentContainer()
    }
}

// MARK: - UI + Constraints
extension BottomSheetViewController {
    func configureView(){
        view.addSubview(dimmedView)
        view.addSubview(containerView)

        dimmedView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

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

    public func changeHeight(defaultHeight: CGFloat, maxHeight: CGFloat) {
        self.defaultHeight = defaultHeight
        self.dismissibleHeight = defaultHeight
        self.currentHeight = defaultHeight
        self.maxHeight = maxHeight

        animateContainerHeight(currentHeight)
    }
}

// MARK: - Animations
extension BottomSheetViewController {
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.deactivate()
            self.containerView.snp.makeConstraints { make in
                self.containerViewBottomConstraint = make.bottom.equalToSuperview().constraint
            }
            self.view.layoutIfNeeded()
        }
    }

    func animateDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4){
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    func animateDismissView(){
        UIView.animate(withDuration: 0.3){ [self] in
            self.containerViewBottomConstraint?.deactivate()
            containerView.snp.makeConstraints { make in
                containerViewBottomConstraint = make.bottom.equalToSuperview().offset(defaultHeight).constraint
            }
            self.view.layoutIfNeeded()
        }

        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3){
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.containerViewHeightConstraint?.deactivate()
            self.containerView.snp.makeConstraints { make in
                self.containerViewHeightConstraint = make.height.equalTo(height).constraint
            }

            self.view.layoutIfNeeded()
        }
        currentHeight = height
    }
}

// MARK: - Gesture Rocognizer
extension BottomSheetViewController {
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    func setupDimmedPanGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        print("Here")
        dimmedView.addGestureRecognizer(tapGesture)
    }

    @objc func handleCloseAction() {
        print("Tik")
        animateDismissView()
    }

    @objc func handlePanGesture(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentHeight - translation.y

        switch gesture.state {
        case.changed:
            if newHeight < maxHeight {
                self.containerViewHeightConstraint?.deactivate()
                self.containerView.snp.makeConstraints { make in
                    self.containerViewHeightConstraint = make.height.equalTo(newHeight).constraint
                }
                view.layoutIfNeeded()
            }
        case .ended:
            // If new height < min height we dismiss controller
            if newHeight <= dismissibleHeight && isDraggingDown {
                self.animateDismissView()
            }
            // If  new height < defolt animate back to default
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            // If new height < max and going down -> set to default height
            else if newHeight < maxHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            // If new height < max and going up -> set to max height
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maxHeight)
            }
        default:
            break
        }
    }
}
