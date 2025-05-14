//
//  APIService.swift
//  UserListRxSwift
//
//  Created by Venkata Sudhakar Reddy on 13/05/25.
//

import Foundation
import RxCocoa
import RxSwift

protocol APIRequestProtocol {
    func fetchUsers<T: Codable>(_ type: T.Type, from url: URL) -> Observable<T>
    func fetchImage(urlString: String) -> Observable<UIImage?>
}

class APIService: APIRequestProtocol {
    
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchUsers<T: Codable>(_ type: T.Type, from url: URL) -> Observable<T> {
        return Observable.create { observer in
            let task = self.session.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    observer.onError(error ?? NSError(domain: "No Data", code: -1, userInfo: nil))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decoded)
                } catch {
                    observer.onError(error)
                }

                observer.onCompleted()
            }

            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func fetchImage(urlString: String) -> Observable<UIImage?> {
            if let cachedImage = imageCache.object(forKey: urlString as NSString) {
                return Observable.just(cachedImage)
            }

            guard let url = URL(string: urlString) else {
                return Observable.just(nil)
            }

            let request = URLRequest(url: url)

            return URLSession.shared.rx.data(request: request)
                .map { [weak self] data in
                    if let image = UIImage(data: data) {
                        self?.imageCache.setObject(image, forKey: urlString as NSString)
                        return image
                    }
                    return nil
                }
                .catchAndReturn(nil)
        }

    
    
}
