//
//  CollectionView.swift
//  Shapify

import UIKit

final class CollectionView: BaseView {
    
    private let infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 36)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Previous searches"
        $0.numberOfLines = 0
    }
    
    private lazy var collectionView = UICollectionView(
        frame: frame,
        collectionViewLayout: .defaultFlowLayout(
            minimumSpacing: 30.0,
            cellSize: .init(
                width: .screenWidth - 50,
                height: .screenWidth - 130
            )
        ).then {
            $0.sectionInset = UIEdgeInsets(top: 2 * Constants.defaultMargin, left: 0, bottom: .screenHeight * 0.05, right: 0)
        }
    ).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .shapifyLightBackground
        $0.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.identifier
        )
        $0.showsVerticalScrollIndicator = false
    }
    
    override init() {
        super.init()
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .shapifyLightBackground
        
        addSubviews([infoLabel, collectionView])
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * Constants.defaultMargin),
            infoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.defaultMargin),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setCollectionDelegate(to controller: CollectionViewController) {
        collectionView.delegate = controller
        collectionView.dataSource = controller
    }
    
    func makeViewComponentsVisible(_ visible: Bool) {
        if visible {
            infoLabel.isHidden = false
            collectionView.isHidden = false
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.infoLabel.alpha = 1
                self?.collectionView.alpha = 1
            }
        } else {
            infoLabel.isHidden = true
            infoLabel.alpha = 0
            collectionView.isHidden = true
            collectionView.alpha = 0
        }
    }
    
    func reloadCollection() {
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }
}
