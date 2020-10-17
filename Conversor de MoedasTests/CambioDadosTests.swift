//
//  CambioDadosTests.swift
//  Conversor de MoedasTests
//
//  Created by Marcio Izar Bastos de Oliveira on 17/10/20.
//

import XCTest
@testable import Conversor_de_Moedas

class VideoDadosTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDeveCarregarListaMoedas() {
        let expectation2 = expectation(description: "foobar")
        let moedasDados = CambioDados(networking: MockNetworking())
        moedasDados.getMoedas() { moedas in
//            DispatchQueue.main.async {
                XCTAssertLessThan(100, moedas?.currencies?.count as! Int)
                XCTAssertEqual("Brazilian Real", moedas?.currencies?["BRL"])
//            }
            }
        expectation2.fulfill()
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testDeveCarregarCalcularCambio() {
        let expectation2 = expectation(description: "foobar")
        let moedasDados = CambioDados(networking: MockNetworking())
        moedasDados.calculaCambio(moedaOrigem: "USD", moedaDestino: "BRL", valor: 2.00) { calculo in
            XCTAssertEqual(11.144996, calculo!, accuracy: 0.000001)
        }
        moedasDados.calculaCambio(moedaOrigem: "BRL", moedaDestino: "USD", valor: 1.00) { calculo in
            XCTAssertEqual(0.17945273, calculo!, accuracy: 0.000001)
        }
        moedasDados.calculaCambio(moedaOrigem: "BRL", moedaDestino: "AED", valor: 2.13) { calculo in
            XCTAssertEqual(calculo!, 1.4039371122250739, accuracy: 0.0000001)
        }
        moedasDados.calculaCambio(moedaOrigem: "AFN", moedaDestino: "AFN", valor: 3.0) { calculo in
            XCTAssertEqual(3.0, calculo)
        }
        expectation2.fulfill()
        waitForExpectations(timeout: 15, handler: nil)
    }
    
}
