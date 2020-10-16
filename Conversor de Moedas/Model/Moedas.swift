//
//  Moedas.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation

struct Moedas: Codable {
    var success: Bool
    var currencies: Dictionary<String, String>?
    var error: Error?
}


