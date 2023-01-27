//
//  CollectionViewModel.swift
//  Shapify

import UIKit

final class CollectionViewModel {
    
    private var models: [[Track]] = []
    
    func fetchCollectionData(completion: @escaping (DatabaseManager.DatabaseError?) -> ()) {
        guard let email = ProfileManager.shared.profile?.email else {
            completion(.argumentMissed)
            return
        }
        DatabaseManager.shared.getAllPreviousTracks(for: email) { result in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let tracksCollection):
                self.models = tracksCollection.sorted(by: {
                    DateFormatter.appFormatter.date(from: $0.first!.date!)! >
                    DateFormatter.appFormatter.date(from: $1.first!.date!)!
                })
                completion(nil)
            }
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
