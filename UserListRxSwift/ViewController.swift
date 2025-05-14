//
//  ViewController.swift
//  UserListRxSwift
//
//  Created by Venkata Sudhakar Reddy on 13/05/25.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
    
    let tableView = UITableView()
    let viewModel = UsersViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTable()
        viewModel.fetchUsers()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindTable() {
        viewModel.users
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, user, cell in
                cell.textLabel?.text = "\(user.firstName) \(user.lastName)"
                //api call image load with cache
                if let imageView = cell.imageView {
                    self.viewModel.apiService.fetchImage(urlString: user.avatar)
                        .observe(on: MainScheduler.instance)
//                        .bind(to: imageView.rx.image)
                        .subscribe(onNext: { image in
                            imageView.image = image
                            cell.setNeedsLayout()
                        })
                        .disposed(by: self.disposeBag)
                }
                //Kingfisher image load
                /*if let url = URL(string: user.avatar) {
                    cell.imageView?.kf.setImage(with: url, completionHandler: { _ in
                        cell.setNeedsLayout()
                    })
                }*/
            }
            .disposed(by: disposeBag)
        
        viewModel.error
            .subscribe(onNext: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .subscribe(onNext: { loading in
                print("Loading: \(loading)")
            })
            .disposed(by: disposeBag)
    }
}

