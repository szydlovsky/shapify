//
//  ResultsView.swift
//  Shapify

import UIKit

final class ResultsView: BaseView {
    
    private let cutView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyDarkBackground
    }
    
    private let upperRect = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifySuperDarkGreen
        $0.layer.cornerRadius = 3
        $0.setWidth(.screenWidth * 0.5)
        $0.setHeight(7)
    }
    
    private let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 24, isBold: true)
        $0.textColor = .shapifyBlack
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var collectionView = UICollectionView(
        frame: frame,
        collectionViewLayout: .defaultFlowLayout(
            minimumSpacing: 30.0,
            cellSize: .init(
                width: .screenWidth - 50,
                height: .screenWidth - 50
            ),
            headerSize: .init(
                width: .screenWidth,
                height: 60
            )
        )
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyDarkBackground
        $0.register(
            ResultsCollectionViewCell.self,
            forCellWithReuseIdentifier: ResultsCollectionViewCell.identifier
        )
        $0.register(
            ResultsCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ResultsCollectionViewHeader.identifier
        )
    }
    
    init(title: String) {
        super.init()
        titleLabel.text = title
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .clear
        
        addSubview(cutView)
        cutView.addSubviews([upperRect, titleLabel, collectionView])
        
        NSLayoutConstraint.activate([
            cutView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cutView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cutView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cutView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .screenHeight * 0.05),
            
            upperRect.centerXAnchor.constraint(equalTo: cutView.centerXAnchor),
            upperRect.topAnchor.constraint(equalTo: cutView.topAnchor, constant: 15),
            
            titleLabel.topAnchor.constraint(equalTo: upperRect.bottomAnchor, constant: Constants.defaultMargin),
            titleLabel.leadingAnchor.constraint(equalTo: cutView.leadingAnchor, constant: Constants.defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: cutView.trailingAnchor, constant: -Constants.defaultMargin),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultMargin),
            collectionView.leadingAnchor.constraint(equalTo: cutView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: cutView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: cutView.bottomAnchor, constant: -1 * .screenHeight * 0.05)
        ])
    }
    
    func setCollectionDelegate(to controller: ResultsViewController) {
        collectionView.delegate = controller
        collectionView.dataSource = controller
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cutView.roundCorners(corners: [.topLeft, .topRight], radius: .screenWidth * 0.2)
    }
}
