//
//  CollectionViewCell.swift
//  Shapify

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CollectionCell"
    
    private lazy var cellWidth = .screenWidth - 50
    private lazy var cellHeight = .screenWidth - 130
    
    private lazy var bgView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setHeight(cellHeight)
        $0.setWidth(cellWidth)
        $0.layer.cornerRadius = .screenWidth * 0.1
    }
    
    private let dateLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 18, isBold: true)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let matchLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .appFont(ofSize: 16, isBold: true)
        $0.textAlignment = .center
        $0.text = "Closest match:"
        $0.numberOfLines = 0
    }
    
    private lazy var imageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setWidth(cellWidth / 4)
        $0.setHeight(cellWidth / 4)
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
    
    private lazy var rightArrowView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setHeight(cellWidth * 0.17)
        $0.setWidth(cellWidth * 0.085)
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "rightArrow")!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(bgView)
        bgView.addSubviews([dateLabel, matchLabel, imageView, titleLabel, artistLabel, rightArrowView])

        NSLayoutConstraint.activate([
            bgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: cellHeight * 0.06),
            dateLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellWidth * 0.03),
            dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellWidth * 0.03),
            
            matchLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: cellHeight * 0.03),
            matchLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            matchLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellWidth * 0.03),
            matchLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellWidth * 0.03),
            
            imageView.topAnchor.constraint(equalTo: matchLabel.bottomAnchor, constant: cellHeight * 0.03),
            imageView.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: cellHeight * 0.03),
            titleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellWidth * 0.03),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellWidth * 0.03),
            
            artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: cellHeight * 0.03),
            artistLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor),
            artistLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: cellWidth * 0.03),
            artistLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1 * cellWidth * 0.03),
            
            rightArrowView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            rightArrowView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -1.5 * Constants.defaultMargin)
        ])
    }
    
    func fillWith(tracks: [Track], index: Int) {
        let bgColor = UIColor.CollectionColor(at: index)
        let labelColor = bgColor.isLight() ? UIColor.shapifyBlack : UIColor.white

        bgView.backgroundColor = bgColor

        dateLabel.text = tracks.first?.date ?? "Result"
        dateLabel.textColor = labelColor
        
        matchLabel.textColor = labelColor
        
        titleLabel.text = tracks.first?.title ?? ""
        titleLabel.textColor = labelColor

        artistLabel.text = tracks.first?.subtitle ?? ""
        artistLabel.textColor = labelColor
        
        imageView.loadImage(urlString: tracks.first?.images?.coverart)
    }
}
