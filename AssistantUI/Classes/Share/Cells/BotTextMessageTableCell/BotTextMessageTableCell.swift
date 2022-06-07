//
//  BotTextMessageTableCell.swift
//  Pods
//
//  Created by user on 06/06/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa

final class BotTextMessageTableCell: BaseTableViewCell<BotTextMessageTableCellViewModel> {
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var weatherView: WeatherView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewConstraintHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(nibWithCellClass: ProjectCollectionCell.self)
        collectionView.register(nibWithCellClass: ArticleCollectionCell.self)
        tableView.register(type: MenuTableCell.self)
        tableView.rx.observe(CGSize.self, "contentSize")
                    .subscribe(onNext: { [weak self] size in
                        if let size = size {
                            self?.tableViewConstraintHeight.constant = size.height
                        }
                    })
                    .disposed(by: disposeBag)
    }

    override func setupCell() {
        checkDataType()
        messageLabel.text = viewModel.data.value
    }
    
    private func checkDataType() {
        guard let type = viewModel.data.type else { return }
        messageView.isHidden = false
        weatherView.isHidden = true
        collectionView.isHidden = true
        tableView.isHidden = true
        switch type {
        case .text:
            break
        case .carousel:
            messageView.isHidden = true
            collectionView.isHidden = false
        case .list:
            messageView.isHidden = true
            tableView.isHidden = false
        default:
            break
        }
    }
}

extension UserMessageTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width/1.5
        return CGSize(width: width, height: 284)
    }
}
