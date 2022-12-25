//
//  DummyViewcontroller.swift
//  Shapify

import UIKit

class DummyViewController: UIViewController {
    
    private let stackView = UIStackView()
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        style()
        layout()
    }
}

extension DummyViewController {
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = .preferredFont(forTextStyle: .title2)
    }
    
    private func layout() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

