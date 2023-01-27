//
//  CollectionViewModel.swift
//  Shapify

import UIKit

final class CollectionViewModel {
    
    private var models: [[Track]] = []
    
    func fetchCollectionData(completion: @escaping () -> ()) {
        //TODO: - Make a call to firebase, fetch needed data, map it to models and call completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func tracks(at idx: Int) -> [Track] {
        models[idx]
    }
    
    func resultsViewModel(at idx: Int) -> ResultsViewModel {
        .init(
            tracks: tracks(at: idx),
            isPostSearch: false,
            originIdx: idx
        )
    }
    
    var modelsCount: Int {
        models.count
    }
}
