//
//  SearchViewModel.swift
//  Shapify

import UIKit
import Combine
import AVFoundation

protocol SearchViewModelDelegate: AnyObject {
    func showError(_ message: String)
    func showResults(_ viewModel: ResultsViewModel)
}

final class SearchViewModel {
    
    @Published var resultsReady: Bool?
    
    private var recorder: AVAudioRecorder!
    
    private var currentTracks = [Track]()
    
    weak var delegate: SearchViewModelDelegate?
    
    //Entire recording animation formula is: 1.25s for initial animation, 2s for every bubble repetition and 1s for ending
    var bubbleAnimationRepetitions: Int = 1
    
    func beginRecording() {
        resultsReady = false
        let fileName = getDocumentsDirectory().appendingPathComponent("file.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: fileName, settings: settings)
            recorder.record()
        } catch {
            delegate?.showError("Error occured when initializing recorder.")
        }
    }
    
    func stopRecording() {
        recorder.stop()
        recorder = nil
        currentTracks = []
        if #available(iOS 16, *) {
            let fileName = getDocumentsDirectory().appending(component: "file.m4a")
            if let data = try? Data(contentsOf: fileName) {
                getTracks(data)
            }
        } else {
            let fileName = getDocumentsDirectory().appendingPathComponent("file.m4a")
            if let data = try? Data(contentsOf: fileName) {
                getTracks(data)
            }
        }
    }
    
    func handleResults() {
        guard !currentTracks.isEmpty else { return }
        let vm = ResultsViewModel(
            tracks: currentTracks,
            isPostSearch: true
        )
        delegate?.showResults(vm)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getTracks(_ data: Data) {
        APICaller.shared.recognizeTrack(using: data) { [weak self] res in
            switch res {
            case .failure(let error):
                self?.delegate?.showError(error.localizedDescription)
                self?.resultsReady = true
            case .success(let track):
                APICaller.shared.searchForTrack(with: track.subtitle, and: track.title) { res in
                    switch res {
                    case .failure(let error):
                        self?.delegate?.showError(error.localizedDescription)
                    case .success(let tracks):
                        self?.currentTracks = []
                        if tracks.isEmpty {
                            self?.delegate?.showError(APICaller.NetworkingError.trackNotFound.localizedDescription)
                        }
                        let currentDate = Date()
                        tracks.forEach { spotifyTrack in
                            let albumImage = spotifyTrack.album.images.first?.url ?? (track.images?.background ?? "")
                            let trackImage = spotifyTrack.album.images.first?.url ?? (track.images?.coverart ?? "")
                            self?.currentTracks.append(
                                Track(
                                    title: spotifyTrack.name,
                                    subtitle: spotifyTrack.artists.first?.name ?? "No Artist",
                                    externalURL: spotifyTrack.external_urls.spotify,
                                    images: Images(background: albumImage, coverart: trackImage),
                                    date: DateFormatter.appFormatter.string(from: currentDate)
                                )
                            )
                        }
                    }
                    self?.resultsReady = true
                }
            }
        }
    }
}
