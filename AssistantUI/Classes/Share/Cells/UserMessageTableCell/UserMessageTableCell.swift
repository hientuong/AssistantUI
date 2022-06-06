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
    @IBOutlet private weak var weatherView: WeatherView!
    @IBOutlet private weak var collectionView: UICollectionView!

    override func setupCell() {
        collectionView.register(nibWithCellClass: ProjectCollectionCell.self)
    }
}

extension UserMessageTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/1.5
        return CGSize(width: width, height: 284)
    }
}
