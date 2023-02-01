//
//  UIViewExtensions.swift
//  Shapify

import UIKit

extension UIView {
    
    func setWidth(_ width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({
            addSubview($0)
        })
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UICollectionViewLayout {
    
    static func defaultFlowLayout (
        scrollDirection: UICollectionView.ScrollDirection = .vertical,
        minimumSpacing: CGFloat,
        cellSize: CGSize,
        headerSize: CGSize? = nil
    ) -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout().then {
            $0.scrollDirection = scrollDirection
            $0.minimumLineSpacing = minimumSpacing
            $0.itemSize = cellSize
            if let size = headerSize {
                $0.headerReferenceSize = size
            }
        }
    }
}

extension UIImageView {
    
    func loadImage(urlString: String?, placeholder: UIImage = UIImage(named: "collection")!) {
        DispatchQueue.main.async {
            self.image = placeholder
        }
        
        guard let str = urlString,
              let url = URL(string: str)
        else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
