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
import SDWebImage

final class MenuTableCell: BaseTableViewCell<MenuTableCellViewModel> {
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.sd_imageTransition = SDWebImageTransition.fade(duration: 0.5)
    }

    override func setupCell() {
        iconView.sd_setImage(with: URL(string: viewModel.data.imgUrl),
                              placeholderImage: nil,
                              options: [ .retryFailed, .continueInBackground, .waitStoreCache],
                              completed: nil)
        titleLabel.text = viewModel.data.title
        descriptionLabel.text = viewModel.data.subtitle
    }
}
