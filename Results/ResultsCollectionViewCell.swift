//
//  ResultsCollectionViewCell.swift
//  Shapify

import UIKit

final class ResultsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ResultsCell"
    
    private var spotifyLink: String?
    
    private var cellSize: CGFloat!
    
    private lazy var bgView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setHeight(cellSize)
        $0.setWidth(cellSize)
        $0.layer.cornerRadius = .screenWidth * 0.2
    }
    
    private lazy var imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setWidth(cellSize / 3)
        $0.setHeight(cellSize / 3)
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 20)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let artistLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var playButton = UIButton(type: .system).then {
        $0.setUpRoundedButton(title: "Play", withSpotiIcon: true)
        $0.setWidth(cellSize * 0.6)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellSize = .screenWidth - 50
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(bgView)
        bgView.addSubviews([imageView, titleLabel, artistLabel, playButton])

        NSLayoutConstraint.activate([
            bgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            imageView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: cellSize * 0.08),
            imageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: cellSize * 0.03),
            titleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellSize * 0.03),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellSize * 0.03),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: cellSize * 0.03),
            artistLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellSize * 0.03),
            artistLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellSize * 0.03),
            
            playButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -1 * cellSize * 0.05),
            playButton.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
        
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
    }
    
    func fillWith(model: ResultsViewModel.ResultCellModel, index: Int) {
        let bgColor = UIColor.CollectionColor(at: index)
        let labelColor = bgColor.isLight() ? UIColor.shapifyBlack : UIColor.white
        
        bgView.backgroundColor = bgColor
        
        titleLabel.text = model.title
        titleLabel.textColor = labelColor
        
        artistLabel.text = model.artist
        artistLabel.textColor = labelColor
        
        spotifyLink = model.link
        
        imageView.loadImage(urlString: model.image)
    }
    
    @objc private func playPressed() {
        if let link = spotifyLink {
            UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
        }
    }
}
