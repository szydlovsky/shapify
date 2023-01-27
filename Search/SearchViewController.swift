//
//  SearchViewController.swift
//  Shapify

import UIKit
import Combine
import AVFoundation

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
    
    private func tryGettingUsersProfile() {
        APICaller.shared.getProfile() { [weak self] error in
            if let _ = error {
                self?.showPopup(
                    message: "Network connection failed",
                    buttonTitle: "Retry", action: {
                        self?.tryGettingUsersProfile()
                    })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryGettingUsersProfile()
        
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.multiRoute, mode: .default, options: .mixWithOthers)
            try recordingSession.setActive(true, options: .notifyOthersOnDeactivation)
            recordingSession.requestRecordPermission() { [weak self] allowed in
                DispatchQueue.main.async {
                    if !allowed {
                        // pop up with error
                        self?.showPopup(message: "You did not allow to use your microfone. Make it in Settings to use the app.", buttonTitle: "OK")
                    }
                }
            }
        } catch {
            // popup with error
            showPopup(message: "Error occured when requesting using of microphone. Give an access in Settings to use the app.", buttonTitle: "OK")
        }
        
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
            self?.navigationController?.navigationBar.isUserInteractionEnabled = true
            if let tabBar = self?.tabBarController as? AppTabBarController {
                tabBar.tabBar.isUserInteractionEnabled = true
            }
            self?.viewModel.handleResults()
        }.store(in: &subs)
        
        viewModel.delegate = self
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

extension SearchViewController: SearchViewModelDelegate {
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showPopup(message: message, buttonTitle: "OK")
        }
    }
    
    func showResults(_ viewModel: ResultsViewModel) {
        let vc = ResultsViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}
