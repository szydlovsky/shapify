//
//  ResultsCollectionViewHeader.swift
//  Shapify

import UIKit

final class ResultsCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "ResultsHeader"
    
    private let headerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 18, isBold: true)
        $0.textColor = .shapifyBlack
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        backgroundColor = .clear
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 10)
        ])
    }
    
    func setAsFirstSection(_ first: Bool) {
        headerLabel.text = first ? "Closest match" : "Other matches"
    }
}
