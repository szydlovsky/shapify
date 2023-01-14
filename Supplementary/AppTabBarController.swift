//
//  AppTabBarController.swift
//  Shapify

import UIKit

final class AppTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let searchNav = UINavigationController(
            rootViewController: SearchViewController(
                viewModel: SearchViewModel()
            )
        )
        let searchImg = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchSelectedImg = UIImage(named: "searchSelected")?.withRenderingMode(.alwaysOriginal)
        let searchTabBarItem = UITabBarItem(
            title: "Search",
            image: searchImg,
            selectedImage: searchSelectedImg
        ).then {
            $0.setTabBarItemAppearance()
        }
        searchNav.tabBarItem = searchTabBarItem
        
        //Collection
        let collectionNav = UINavigationController(
            rootViewController: CollectionViewController()
        )
        let collectionImg = UIImage(named: "collection")?.withRenderingMode(.alwaysOriginal)
        let collectionSelectedImg = UIImage(named: "collectionSelected")?.withRenderingMode(.alwaysOriginal)
        let collectionTabBarItem = UITabBarItem(
            title: "Collection",
            image: collectionImg,
            selectedImage: collectionSelectedImg
        ).then {
            $0.setTabBarItemAppearance()
        }
        collectionNav.tabBarItem = collectionTabBarItem
        
        self.tabBar.backgroundColor = .shapifyGreen
        self.tabBar.clipsToBounds = true
        self.viewControllers = [searchNav, collectionNav]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let height = .screenHeight * 0.1
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = view.frame.height - height
        
        tabBar.unselectedItemTintColor = .shapifyBlack
    }
}

extension UITabBarItem {
    func setTabBarItemAppearance() {
        let inset = .screenHeight * 0.002
        imageInsets = UIEdgeInsets(top: inset, left: 0, bottom: -inset, right: 0)
        setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.appFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.shapifyBlack
            ],
            for: .normal
        )
        setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.appFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.shapifyLightBackground
            ],
            for: .selected
        )
    }
}
