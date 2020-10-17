//
//  Endpoint.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation

protocol Endpoint {
    var path: String { get }
}

enum CurrencyLayer {
    case listaMoedas
    case conversao
}

extension CurrencyLayer: Endpoint {
    var path: String {
        switch self {
            case .listaMoedas: return "http://api.currencylayer.com/list?access_key=e577f514be3b254d7ec08cb2cd789a12"
            case .conversao: return "http://api.currencylayer.com/live?access_key=e577f514be3b254d7ec08cb2cd789a12"
        }
    }
    
    var mock: String {
        switch self {
            case .listaMoedas: return "List"
            case .conversao: return "Live"
        }
    }
}
