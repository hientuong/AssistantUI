//
//  SectionModel+Extension.swift
//  Stil
//
//  Created by Gà Nguy Hiểm on 10/08/2021.
//

import RxDataSources

struct SectionModel {
    var items: [SectionItem]
}

enum SectionItem {
//    case event(viewModel: EventTableCellViewModel)
//    case partner(viewModel: EventPartnerTableCellViewModel)
//    case community(viewModel: CommunityTableCellViewModel)
}

extension SectionModel: SectionModelType {
    init(original: SectionModel, items: [SectionItem]) {
        self = original
        self.items = items
    }
}
