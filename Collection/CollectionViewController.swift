//
//  CollectionViewController.swift
//  Shapify

import UIKit
import SwiftLoader

final class CollectionViewController: BaseViewController {
    
    private lazy var mainView = CollectionView()
    private let viewModel: CollectionViewModel
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setCollectionDelegate(to: self)
        
        var config = SwiftLoader.Config()
        config.size = .screenWidth * 0.5
        config.spinnerColor = .shapifyLightBackground
        config.backgroundColor = .shapifyDarkGreen
        config.cornerRadius = .screenWidth * 0.1
        config.titleTextFont = .appFont(ofSize: 16, isBold: false)
        config.titleTextColor = .shapifyLightBackground
        SwiftLoader.setConfig(config)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DatabaseManager.shared.shouldFetch {
            mainView.makeViewComponentsVisible(false)
            SwiftLoader.show(title: "Fetching data...", animated: true)
            viewModel.fetchCollectionData(completion: { [weak self] error in
                guard let self = self else { return }
                SwiftLoader.hide()
                if let error = error {
                    self.showPopup(message: error.localizedDescription, buttonTitle: "Ok")
                    return
                }
                self.mainView.makeViewComponentsVisible(true)
                self.mainView.reloadCollection()
            })
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.modelsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.identifier,
            for: indexPath
        ) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.fillWith(
            tracks: viewModel.tracks(at: indexPath.row),
            index: indexPath.row
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ResultsViewController(viewModel: viewModel.resultsViewModel(at: indexPath.row))
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}
