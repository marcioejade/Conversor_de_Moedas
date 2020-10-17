//
//  Networking.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation

// 1.
protocol Networking {
    typealias CompletionHandler = (Data?, Swift.Error?) -> Void

    func request(from: CurrencyLayer, parameters: [String: String]?, completion: @escaping CompletionHandler)
}

// 2.
struct HTTPNetworking: Networking {
    // 3.
    func request(from: CurrencyLayer, parameters: [String: String]?, completion: @escaping CompletionHandler) {
        
        var strUrl = from.path
        if parameters != nil {
            let parametros = parameters!
            for parametro in parametros {
                strUrl += "&" + parametro.key + "=" + parametro.value
            }
        }
        guard let url = URL(string: strUrl) else {
            print("Erro URL")
            return
        }
        let request = createRequest(from: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    // 4.
    private func createRequest(from url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        return request
    }
    
    // 5.
    private func createDataTask(from request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, httpResponse, error in
            completion(data, error)
        }
    }
}

struct MockNetworking: Networking {
    func request(from: CurrencyLayer, parameters: [String: String]?, completion: @escaping CompletionHandler) {
        let data = readJson(name: from.mock)
        completion(data, nil)
    }
    func readJson(name: String) -> Data? {
        var data: Data?
        if let path = Bundle.main.path(forResource: name, ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            } catch let error {
                // handle error
                print(error.localizedDescription)
                return nil
            }
        }
        return data
    }
}
