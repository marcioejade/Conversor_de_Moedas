//
//  Valor.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation

struct Valores: Codable {
    var success: Bool
    var timestamp: Int?
    var quotes: Dictionary<String, Double>?
    var error: Error?
}

