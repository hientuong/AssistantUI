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

final class AssistantViewController: BaseViewController<AssistantViewModel> {
    enum ViewMode {
        case waiting
        case voice
        case message
    }
    
    @IBOutlet private weak var closeButton: UIView!
    @IBOutlet private weak var bottomButtons: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var mainViewHeightConstraint: NSLayoutConstraint!

    private var viewMode = BehaviorSubject<ViewMode>(value: .waiting)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configUI() {
        viewMode
            .bind(to: self.viewModeBinding)
            .disposed(by: disposeBag)
        Assistant.shared.commandObser
            .subscribe(onNext: { [weak self] command in
                self?.viewMode.onNext(.voice)
                print("test command \(command)")
            })
            .disposed(by: disposeBag)
    }

    override func bind() {
        let input = AssistantViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.error.drive(errorBinding)
            .disposed(by: disposeBag)
    }
    
    private var errorBinding: Binder<Error> {
        return Binder(self, binding: { (vc, error) in
            
        })
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
                    self?.mainViewHeightConstraint.constant = 300
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
