//
//  CollectionViewModel.swift
//  Shapify

import UIKit

final class CollectionViewModel {
    
    struct CollectionCellModel {
        let tracks: [Track]
        let date: Date
    }
    
    private var models: [CollectionCellModel] = [
        .init(tracks: [
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some other track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some other track", subtitle: "ddd artist", externalURL: nil, images: nil),
            .init(title: "Some other track", subtitle: "ddd artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some track", subtitle: "short artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some other track", subtitle: "short artist", externalURL: nil, images: nil),
            .init(title: "Some other track", subtitle: "ddd artist", externalURL: nil, images: nil),
            .init(title: "Some other track", subtitle: "ddd artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil)
        ], date: Date()),
        .init(tracks: [
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil),
            .init(title: "Some trackey", subtitle: "super loooooooong arrrrrr artist", externalURL: nil, images: nil)
        ], date: Date())
    ]
    
    func fetchCollectionData(completion: @escaping () -> ()) {
        //TODO: - Make a call to firebase, fetch needed data, map it to models and call completion
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion()
        }
    }
    
    func model(at idx: Int) -> CollectionCellModel {
        models[idx]
    }
    
    func resultsViewModel(at idx: Int) -> ResultsViewModel {
        .init(
            tracks: model(at: idx).tracks,
            isPostSearch: false,
            searchDate: model(at: idx).date,
            originIdx: idx
        )
    }
    
    var modelsCount: Int {
        models.count
    }
}
