//
//  UsersViewModel.swift
//  UserListRxSwift
//
//  Created by Venkata Sudhakar Reddy on 13/05/25.
//

import Foundation
import RxSwift
import RxCocoa

class UsersViewModel {
    let users = BehaviorRelay<[User]>(value: [])
    let error = PublishSubject<String>()
    var isLoading = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    public let apiService = APIService()
    

    func fetchUsers() {
        isLoading.accept(true)
        let baseURL = URL(string: "https://dummyjson.com/users")!
        apiService.fetchUsers(UsersResponse.self, from: baseURL)
            .map { $0.users }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                self?.users.accept(users)
                self?.isLoading.accept(false)
            }, onError: { [weak self] error in
                self?.error.onNext(error.localizedDescription)
                self?.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
