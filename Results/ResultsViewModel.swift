//
//  ResultsViewModel.swift
//  Shapify

import UIKit

final class ResultsViewModel {
    
    public struct ResultCellModel {
        let image: String?
        let title: String
        let artist: String
        let link: String?
    }
    
    private var models: [ResultCellModel]
    private let isPostSearch: Bool
    private let searchDate: Date?
    private let originIdx: Int?
    
    init(tracks: [Track], isPostSearch: Bool, searchDate: Date? = nil, originIdx: Int? = nil) {
        self.models = tracks.map({
            ResultCellModel(
                image: $0.images?.coverart,
                title: $0.title,
                artist: $0.subtitle,
                link: $0.externalURL
            )
        })
        self.isPostSearch = isPostSearch
        self.searchDate = searchDate
        self.originIdx = originIdx
        
        //TODO: - Save search results to firebase
    }
    
    func model(at idx: Int) -> ResultCellModel {
        models[idx]
    }
    
    func colorIdx(at idx: Int) -> Int {
        originIdx == nil
            ? 0 + idx
            : originIdx! + idx
    }
    
    var modelsCount: Int {
        models.count
    }
    
    var titleString: String {
        isPostSearch
            ? "Here are Your\nResults!"
            : searchDate != nil
                ? "Results from\n" + DateFormatter.appFormatter.string(from: searchDate!)
                : "Here are Your\nResults!"
    }
}
