//
//  SearchViewController.swift
//  Shapify

import UIKit
import Combine

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private let viewModel: SearchViewModel
    
    private var subs = Set<AnyCancellable>()
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.setRecordingRepetitions(to: viewModel.bubbleAnimationRepetitions)
        
        mainView.$recordingOngoing.sink { [weak self] ongoing in
            guard let ongoing = ongoing else { return }
            if ongoing {
                self?.viewModel.beginRecording()
                self?.navigationController?.navigationBar.isUserInteractionEnabled = false
                if let tabBar = self?.tabBarController as? AppTabBarController {
                    tabBar.tabBar.isUserInteractionEnabled = false
                }
            } else {
                self?.viewModel.stopRecording()
            }
        }.store(in: &subs)
        
        mainView.$loadingOngoing.sink { [weak self] ongoing in
            guard let ongoing = ongoing,
                  !ongoing
            else {
                return
            }
            self?.viewModel.handleResults()
            self?.navigationController?.navigationBar.isUserInteractionEnabled = true
            if let tabBar = self?.tabBarController as? AppTabBarController {
                tabBar.tabBar.isUserInteractionEnabled = true
            }
        }.store(in: &subs)
        
        viewModel.$resultsReady.sink { [weak self] ready in
            guard let ready = ready,
                  ready
            else {
                return
            }
            self?.mainView.stopLoading()
        }.store(in: &subs)
    }
}
