//
//  BaseCellViewModel.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 01/03/2021.
//

import UIKit
import RxSwift

protocol CellViewModelProtocol {
    
}

class BaseTableViewCell<T: CellViewModelProtocol>: UITableViewCell, TableViewCellProtocol {
    typealias ViewModel = T
    var viewModel: T!
    var indexPath: IndexPath!
    let disposeBag = DisposeBag()
    
    final func config(with viewModel: ViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath
        self.setupCell()
    }
    
    func setupCell() {}
}

class BaseCellViewModel<T: Codable>: NSObject, CellViewModelProtocol {
    var data: T!
    
    init(with data: T) {
        super.init()
        self.data = data
        self.setupViewModel()
    }
    
    func setupViewModel() {}
}
