//
//  DisplayViewController.swift
//  Pods
//
//  Created by user on 03/06/2022.
// 
//

import UIKit
import RxSwift
import RxCocoa
import AssistantAPI

final class AssistantViewController: BaseViewController<AssistantViewModel> {
    enum ViewMode {
        case waiting
        case voice
        case message
    }
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var bottomButtons: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var mainViewHeightConstraint: NSLayoutConstraint!

    private var viewMode = BehaviorSubject<ViewMode>(value: .waiting)
    private let voiceCommand = PublishSubject<String>()
    private var mockMessageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        tableView.register(type: UserMessageTableCell.self, bundle: Bundle(for: UserMessageTableCell.self))
        tableView.register(type: BotTextMessageTableCell.self, bundle: Bundle(for: BotTextMessageTableCell.self))
        
        closeButton.rx.tap
            .throttle(.microseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                Assistant.shared.dismiss()
            })
            .disposed(by: disposeBag)
        
        viewMode
            .bind(to: self.viewModeBinding)
            .disposed(by: disposeBag)
        Assistant.shared.commandObser
            .subscribe(onNext: { [weak self] command in
                self?.viewMode.onNext(.voice)
                self?.mockMessageCount += 1
                self?.voiceCommand.onNext(self?.getMockMessage() ?? "")
                print("test command \(command)")
            })
            .disposed(by: disposeBag)
    }

    override func bind() {
        let input = AssistantViewModel.Input(voiceCommand: voiceCommand.asDriverOnErrorJustComplete())
        let output = viewModel.transform(input: input)
        
        output.messages
            .drive(tableView.rx.items) { tableView, index, element in
                if element.type == nil {
                    let cell = tableView.createCell(UserMessageTableCell.self,
                                                    UserMessageTableCellViewModel(with: element),
                                                    IndexPath(row: index, section: 0))
                    return cell
                } else {
                    let cell = tableView.createCell(BotTextMessageTableCell.self,
                                                    BotTextMessageTableCellViewModel(with: element),
                                                    IndexPath(row: index, section: 0))
                    return cell
                }
            }.disposed(by: disposeBag)
        
        output.error
            .drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    private var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            
        })
    }
    
    private func getMockMessage() -> String {
        switch mockMessageCount {
        case 1:
            return "xin chào!"
        case 2:
            return "Cho tôi hỏi Ocean Park rộng bao nhiêu ha?"
        case 3:
            return "Cho hỏi Ocean Park ở đâu?"
        case 4:
            return "Tại sao gọi Ocean Park là thành phố 15 phút?"
        default:
            return "xin chào!"
        }
    }
}

extension AssistantViewController {
    private var viewModeBinding: Binder<ViewMode> {
        return Binder(self, binding: { [weak self] (vc, mode) in
            switch mode {
            case .waiting:
                self?.closeButton.isHidden = true
                self?.bottomButtons.isHidden = true
                self?.mainViewHeightConstraint.constant = 0
            case .voice:
                UIView.animate(withDuration: 0.5, animations: {
                    self?.closeButton.isHidden = false
                    self?.bottomButtons.isHidden = false
                    self?.mainViewHeightConstraint.constant = self?.view.height ?? 300
                    self?.view.layoutIfNeeded()
                })
                
            case .message:
                break
            }
        })
    }
}

extension AssistantViewController {
    static func createViewController() -> AssistantViewController {
            let viewModel = AssistantViewModel()
            let viewController = AssistantViewController.newInstance(with: viewModel)
            return viewController
        }
}
