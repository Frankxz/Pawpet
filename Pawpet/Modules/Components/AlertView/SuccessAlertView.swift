//
//  SuccessAlertView.swift
//  Pawpet
//
//  Created by Robert Miller on 29.04.2023.
//

import UIKit
import Lottie

class SuccessAlertView: UIView {
    // MARK: UI components
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "Success")
        view.loopMode = .playOnce
        view.layer.allowsEdgeAntialiasing = true
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
        return view
    }()

    private var promptView = PromptView(with: "", and: "", titleSize: 20, subtitleSize: 17)
    private var targetView: UIView?

    // MARK: - Inits
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI configuring
extension SuccessAlertView {
    private func setupView() {
        backgroundColor = .backgroundColor
        layer.cornerRadius = 12
        addSubview(promptView)
        addSubview(animationView)

        promptView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }

        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(140)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(30)
        }

    }
}

// MARK: - Appearing & Disappering logic
extension SuccessAlertView {
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        self.targetView = targetView

        promptView.setupTitles(title: title, subtitle: message)

        targetView.addSubview(self)
        self.frame = getFrame(for: .hide)

        UIView.animate(withDuration: 0.25, animations: {
            self.frame = self.getFrame(for: .show)
            self.animationView.play()
        }) { ended in
            if ended {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    UIView.animate(withDuration: 0.35, animations: {
                        self.frame = self.getFrame(for: .hide)
                    }) {  ended in
                        if ended {
                            self.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Frame computing
extension SuccessAlertView {
    private func getFrame(for type: AlertFrameType) -> CGRect {
        if type == .hide {
           return CGRect(x: 20, y: -170,
                   width: UIScreen.main.bounds.width - 40, height: 70)
        } else {
           return CGRect(x: 20, y: 0,
                   width: UIScreen.main.bounds.width - 40, height: 70)
        }
    }

    enum AlertFrameType {
        case hide
        case show
    }
}
