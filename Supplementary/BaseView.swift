//
//  BaseView.swift
//  Shapify

import UIKit

open class BaseView: UIView {
    public init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { nil }
    
    func switchInteraction(allowed: Bool) {
        guard let tabVc = self.window?.rootViewController as? UITabBarController else { return }
        tabVc.tabBar.isUserInteractionEnabled = allowed
        isUserInteractionEnabled = allowed
    }
}
