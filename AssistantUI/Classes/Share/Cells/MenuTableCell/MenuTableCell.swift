//
//  MenuTableCell.swift
//  Pods
//
//  Created by user on 07/06/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa

final class MenuTableCell: BaseTableViewCell<MenuTableCellViewModel> {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func setupCell() {
        
    }
}
