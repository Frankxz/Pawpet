//
//  AlertView.swift
//  Pawpet
//
//  Created by Robert Miller on 27.04.2023.
//

import UIKit
import Lottie

class AlertView: UIView {

    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.1
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()

    private var targetView: UIView?

    // MARK: UI components
    private let promptView = PromptView(with: "", and: "", titleSize: 26, aligment: .center)

    // MARK: Lottie View
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "SadDog")
        view.loopMode = .autoReverse
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var closeButton: AuthButton = {
        let button = AuthButton()
        button.setupTitle(for: "Close")
        return button
    }()

    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupContainerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI + Constraints
extension AlertView {
    private func setupContainerView() {
        let stackView = getStackView()

        containerView.addSubview(closeButton)
        containerView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        closeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        animationView.play()
    }

    private func getStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -40

        animationView.snp.makeConstraints { $0.height.equalTo(260) }
        stackView.addArrangedSubview(promptView)
        stackView.addArrangedSubview(animationView)

        return stackView
    }
}
// MARK: - Appearing & Disappering logic
extension AlertView {
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        self.targetView = targetView

        dimmedView.frame = targetView.bounds
        promptView.setupTitles(title: title, subtitle: message)

        closeButton.addTarget(self, action: #selector(dismissAlertView), for: .touchUpInside)

        targetView.addSubview(dimmedView)
        targetView.addSubview(containerView)

        containerView.frame = CGRect(x: 40, y: -500, width: targetView.frame.width - 80, height: 400)

        UIView.animate(withDuration: 0.25, animations: {
            self.dimmedView.alpha = 0.6
        }) { ended in
            if ended {
                UIView.animate(withDuration: 0.25) {
                    self.containerView.center = targetView.center
                }
            }
        }
    }

    @objc func dismissAlertView() {
        print("Dismissing1")
        guard let targetView = targetView else { return }
        print("Dismissing2")
        UIView.animate(withDuration: 0.35, animations: {
            self.containerView.frame = CGRect(x: 40,
                                              y: targetView.frame.height,
                                              width: targetView.frame.width - 80,
                                              height: 400)
        }) { ended in
            if ended {
                UIView.animate(withDuration: 0.25, animations: {
                    self.dimmedView.alpha = 0
                }, completion: { ended in
                    if ended {
                        self.containerView.removeFromSuperview()
                        self.dimmedView.removeFromSuperview()
                    }
                })
            }
        }
    }
}
