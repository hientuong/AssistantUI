//
//  BaseCollectionViewCell.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 02/03/2021.
//

import RxSwift

protocol CollectionViewModelProtocol {
    
}

class BaseCollectionViewCell<T: CollectionViewModelProtocol>: UICollectionViewCell, ReuseID {
    typealias ViewModel = T
    var viewModel: ViewModel!
    var indexPath: IndexPath!
    let disposeBag = DisposeBag()
    
    final func config(with viewModel: T, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        self.setupCell()
    }
    
    func setupCell() {}
}

class BaseCollectionViewModel<T: Codable>: NSObject, CollectionViewModelProtocol {
    var data: T!
    
    init(with data: T) {
        super.init()
        self.data = data
        self.setupViewModel()
    }
    
    func setupViewModel() {}
}
