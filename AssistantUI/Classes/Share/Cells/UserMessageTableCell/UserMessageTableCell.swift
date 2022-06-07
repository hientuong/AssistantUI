//
//  UserMessageTableCell.swift
//  Pods
//
//  Created by user on 06/06/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa
import SwifterSwift
import Alamofire

final class UserMessageTableCell: BaseTableViewCell<UserMessageTableCellViewModel> {
    @IBOutlet private weak var messageLabel: UILabel!

    override func setupCell() {
        messageLabel.text = viewModel.data.value
    }
}
