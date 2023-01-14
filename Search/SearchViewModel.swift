//
//  SearchViewModel.swift
//  Shapify

import UIKit
import Combine

final class SearchViewModel {
    
    @Published var resultsReady: Bool?
    
    //Entire recording animation formula is: 1.25s for initial animation, 2s for every bubble repetition and 1s for ending
    var bubbleAnimationRepetitions: Int = 1
    
    func beginRecording() {
        //TODO: - Implement recording
        resultsReady = false
        print("began")
    }
    
    func stopRecording() {
        //TODO: - Implement communicating with api
        print("stopped")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) { [weak self] in
            self?.resultsReady = true
        }
    }
    
    func handleResults() {
        //TODO: - Implement showing results
        print("ready")
    }
    
    
}
