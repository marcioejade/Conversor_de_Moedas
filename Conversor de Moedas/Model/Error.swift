//
//  Error.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation

struct Error: Codable {
    var code: Int
    var info: String?
}
