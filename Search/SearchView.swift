//
//  SearchView.swift
//  Shapify

import UIKit
import Combine

final class SearchView: BaseView {
    
    private var subs = Set<AnyCancellable>()
    
    //MARK: - Subviews
    
    private let infoLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 36)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "Click to start recording..."
        $0.numberOfLines = 0
    }
    
    private let logoView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setWidth(.screenWidth * 0.54)
        $0.setHeight(.screenWidth * 0.54)
        $0.backgroundColor = .shapifyDarkGreen
        $0.layer.cornerRadius = .screenWidth * 0.27
        
        let imgView = UIImageView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(named: "shapifyLogo")
            $0.contentMode = .scaleAspectFit
            $0.setWidth(.screenWidth * 0.5)
            $0.setHeight(.screenWidth * 0.5)
        }
        
        $0.addSubview(imgView)
        imgView.centerXAnchor.constraint(equalTo: $0.centerXAnchor).isActive = true
        imgView.centerYAnchor.constraint(equalTo: $0.centerYAnchor).isActive = true
    }
    
    private let outerCircle = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setWidth(.screenWidth * 0.68)
        $0.setHeight(.screenWidth * 0.68)
        $0.backgroundColor = .shapifyDarkGreen
        $0.layer.cornerRadius = .screenWidth * 0.34
    }
    
    private let innerCircle = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setWidth(.screenWidth * 0.60)
        $0.setHeight(.screenWidth * 0.60)
        $0.backgroundColor = .shapifyLightBackground
        $0.layer.cornerRadius = .screenWidth * 0.3
    }
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .shapifyLightBackground
        
        addSubviews([infoLabel, outerCircle, innerCircle, logoView])
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.defaultMargin),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.defaultMargin),
            infoLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2 * Constants.defaultMargin),
            
            outerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            outerCircle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2 * Constants.defaultMargin + .screenHeight * 0.2),
            
            innerCircle.centerXAnchor.constraint(equalTo: centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor)
        ])
        
        logoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonPressed)))
        
        $recordingOngoing.sink { [weak self] ongoing in
            guard let ongoing = ongoing else { return }
            self?.isUserInteractionEnabled = !ongoing
        }.store(in: &subs)
        
        $loadingOngoing.sink { [weak self] ongoing in
            guard let ongoing = ongoing else { return }
            self?.isUserInteractionEnabled = !ongoing
        }.store(in: &subs)
    }
    
    @objc private func buttonPressed() {
        beginAnimation()
    }
    
    //MARK: - Recording animations
    
    @Published var recordingOngoing: Bool?
    private var recordingRepetitions: Int = 1
    
    func setRecordingRepetitions(to amount: Int) {
        recordingRepetitions = amount
    }
    
    private func beginAnimation() {
        recordingOngoing = true
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            let scale = 0.6 / 0.54
            self?.logoView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self?.outerCircle.backgroundColor = .red
            self?.infoLabel.text = "Listening..."
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.75, animations: {
                let scale = 0.75
                self?.logoView.transform = CGAffineTransform(scaleX: scale, y: scale)
                self?.outerCircle.backgroundColor = .shapifyDarkGreen
            }) { _ in
                self?.animateBubble(repeats: self?.recordingRepetitions ?? 0)
            }
        }
    }
    
    private func animateBubble(repeats: Int) {
        guard repeats > 0 else {
            UIView.animate(withDuration: 1, animations: { [weak self] in
                self?.logoView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self?.outerCircle.backgroundColor = .shapifyDarkGreen
            }) { [weak self] _ in
                self?.infoLabel.text = "Recognizing..."
                self?.recordingOngoing = false
                self?.startLoading()
            }
            return
        }
        UIView.animate(withDuration: 1, animations: { [weak self] in
            self?.logoView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self?.outerCircle.backgroundColor = .red
        }) { [weak self] _ in
            UIView.animate(withDuration: 1, animations: {
                self?.logoView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self?.outerCircle.backgroundColor = .shapifyDarkGreen
            }) { _ in
                self?.animateBubble(repeats: repeats - 1)
            }
        }
    }
    
    //MARK: - Loading animations
    
    @Published var loadingOngoing: Bool?
    private var shouldLoadMore: Bool = true
        
    func stopLoading() {
        shouldLoadMore = false
    }
    
    func startLoading() {
        shouldLoadMore = true
        loadingOngoing = true
        animateLoading()
    }
    
    private func animateLoading() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.logoView.transform = CGAffineTransform(rotationAngle: .pi)
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.5, animations: {
                self?.logoView.transform = CGAffineTransform(rotationAngle: .zero)
            }) { _ in
                if self?.shouldLoadMore ?? false {
                    self?.animateLoading()
                } else {
                    self?.infoLabel.text = "Click to start recording..."
                    self?.loadingOngoing = false
                }
            }
        }
    }
}
