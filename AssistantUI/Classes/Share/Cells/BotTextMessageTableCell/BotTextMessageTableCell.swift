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
import SDWebImage
import AssistantAPI

protocol BotTextMessageCellDelegate {
    func didUpdateListUI()
}

final class BotTextMessageTableCell: BaseTableViewCell<BotTextMessageTableCellViewModel> {
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var mediaView: UIImageView!
    @IBOutlet private weak var weatherView: WeatherView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewConstraintHeight: NSLayoutConstraint!
    
    var delegate: BotTextMessageCellDelegate?
    
    private var isnit = true
    private var listData: [MenuTableCellViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageView.isHidden = true
        weatherView.isHidden = true
        collectionView.isHidden = true
        tableView.isHidden = true
        mediaView.isHidden = true
    }
    
    override func setupCell() {
        guard let type = viewModel.data.type else { return }
        checkDataType(type)
        fillData(type)
    }
    
    private func configUI() {
        collectionView.register(nibWithCellClass: ProjectCollectionCell.self)
        collectionView.register(nibWithCellClass: ArticleCollectionCell.self)
        tableView.register(type: MenuTableCell.self, bundle: Bundle(for: MenuTableCell.self))
        mediaView.sd_imageTransition = SDWebImageTransition.fade(duration: 0.5)
        tableView.rx.observe(CGSize.self, "contentSize")
                    .subscribe(onNext: { [weak self] size in
                        guard let self = self,
                              let size = size else { return }
                        let oldSize = self.tableViewConstraintHeight.constant ?? 0
                        self.tableViewConstraintHeight.constant = size.height
                        if size.height > oldSize, size.height > 0 {
                            self.delegate?.didUpdateListUI()
                        }
                    })
                    .disposed(by: disposeBag)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fillData(_ type: BotMessageType) {
        switch type {
        case .text:
            messageLabel.text = viewModel.data.value
        case .carousel:
            break
        case .list:
            guard let data = viewModel.data.getBotMessageValueObject() as? BotMessageList else {
                return
            }
            listData = data.items?.map{MenuTableCellViewModel(with: $0)} ?? []
        case .media:
            guard let media = viewModel.data.getBotMessageValueObject() as? BotMessageMedia else {
                return
            }
            mediaView.sd_setImage(with: URL(string: media.imgUrl),
                                  placeholderImage: nil,
                                  options: [ .retryFailed, .continueInBackground, .waitStoreCache],
                                  completed: nil)
        default:
            break
        }
    }
    
    private func checkDataType(_ type: BotMessageType) {
        messageView.isHidden = true
        weatherView.isHidden = true
        collectionView.isHidden = true
        tableView.isHidden = true
        mediaView.isHidden = true
        switch type {
        case .text:
            messageView.isHidden = false
        case .carousel:
            collectionView.isHidden = false
        case .list:
            tableView.isHidden = false
        case .media:
            mediaView.isHidden = false
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

extension BotTextMessageTableCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = listData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withClass: MenuTableCell.self, for: indexPath)
        cell.config(with: element, indexPath: indexPath)
        return cell
    }
}
