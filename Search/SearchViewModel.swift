//
//  SearchViewModel.swift
//  Shapify

import UIKit
import Combine
import AVFoundation

protocol SearchViewModelDelegate: AnyObject {
    func showError(_ message: String)
}

final class SearchViewModel {
    
    @Published var resultsReady: Bool?
    
    private var recorder: AVAudioRecorder!
    
    private var currentTrack: Track?
    
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
        if #available(iOS 16, *) {
            let fileName = getDocumentsDirectory().appending(component: "file.m4a")
            if let data = try? Data(contentsOf: fileName) {
                request(input: data) { [weak self] message in
                    self?.resultsReady = true
                    if let error = message {
                        self?.delegate?.showError(error)
                    }
                }
            }
        } else {
            let fileName = getDocumentsDirectory().appendingPathComponent("file.m4a")
            if let data = try? Data(contentsOf: fileName) {
                request(input: data) { [weak self] message in
                    self?.resultsReady = true
                    if let error = message {
                        self?.delegate?.showError(error)
                    }
                }
            }
        }
    }
    
    func handleResults() {
        //TODO: - Implement showing results
        print(currentTrack)
    }
    
    private func request(input: Data, completion: @escaping (String?) -> ()) {
        currentTrack = nil
        let headers = [
            "content-type": "text/plain",
            "X-RapidAPI-Key": Constants.rapidAPIKey,
            "X-RapidAPI-Host": "shazam.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://shazam.p.rapidapi.com/songs/v2/detect?timezone=America%2FChicago&locale=en-US") else {
            completion("Error occured while creating url.")
            return
        }
        
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = input.base64EncodedString().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(error?.localizedDescription)
                return
            }
            do {
                let result = try JSONDecoder().decode(TrackResponse.self, from: data)
                self?.currentTrack = result.track
                completion(nil)
            } catch {
                completion(error.localizedDescription)
            }
        }).resume()
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
