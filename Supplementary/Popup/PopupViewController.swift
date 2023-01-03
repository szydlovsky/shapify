//
//  PopupViewController.swift
//  Shapify

import UIKit

final class PopupViewController: UIViewController {

    struct PopupModel {
        var message: String
        var buttonTitle: String
        var action: (() -> Void)?
    }
    
    private let mainView = PopupView()
    private let model: PopupModel
    
    init(model: PopupModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        mainView.onButtonPress = { [weak self] in
            self?.model.action?()
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        
        mainView.onClosePress = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
        
        mainView.configure(
            message: model.message,
            buttonTitle: model.buttonTitle
        )
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != mainView.containerView {
            DispatchQueue.main.async { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
}

