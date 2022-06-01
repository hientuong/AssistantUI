//
//  BaseView.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 01/03/2021.
//

import UIKit

class BaseView: UIView {
    lazy var overlayView: UIView! = UIView(frame: self.contentView.frame)
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let identifier = String(describing: type(of: self))
        Bundle.main.loadNibNamed(identifier,
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.overlayView.backgroundColor = .white
//        contentView.addSubview(self.overlayView)
        reloadView()
    }
    
    func reloadView() {
        
    }
}
