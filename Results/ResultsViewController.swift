//
//  ResultsViewController.swift
//  Shapify

import UIKit

final class ResultsViewController: UIViewController {
    
    private lazy var mainView = ResultsView(title: viewModel.titleString)
    private let viewModel: ResultsViewModel
    
    init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
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
        super.viewDidLoad()
        mainView.setCollectionDelegate(to: self)
    }
}

extension ResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.modelsCount == 1
            ? 1
            : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0
            ? 1
            : viewModel.modelsCount - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ResultsCollectionViewCell.identifier,
            for: indexPath
        ) as? ResultsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let idx = indexPath.section == 0
            ? 0
            : indexPath.row + 1
        
        cell.fillWith(
            model: viewModel.model(at: idx),
            index: viewModel.colorIdx(at: idx)
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ResultsCollectionViewHeader.identifier,
                for: indexPath
              ) as? ResultsCollectionViewHeader
        else {
            return UICollectionReusableView()
        }
        
        header.setAsFirstSection(indexPath.section == 0)
        return header
    }
}
