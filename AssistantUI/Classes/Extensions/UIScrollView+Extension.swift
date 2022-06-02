//
//  UIScrollView+Extension.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 26/08/2021.
//

import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
