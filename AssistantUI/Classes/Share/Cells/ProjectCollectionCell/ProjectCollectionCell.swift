//
//  ProjectCollectionCell.swift
//  Pods
//
//  Created by user on 06/06/2022.
// 
//
import UIKit
import RxSwift
import RxCocoa

final class ProjectCollectionCell: BaseCollectionViewCell<ProjectCollectionCellViewModel> {
    
    typealias ActionHandler = ((String) -> Void)
    @IBOutlet private weak var coverImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var viewButton: UIButton!
    
    var didTapView: ActionHandler = {_ in}

    override func setupCell() {
        viewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapView("")
            })
            .disposed(by: disposeBag)
    }
}
