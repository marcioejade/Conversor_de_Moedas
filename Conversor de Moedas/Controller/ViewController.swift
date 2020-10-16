//
//  ViewController.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import UIKit

class ViewController: UIViewController, ListaMoedasViewControllerDelegate {
    
    let cambioDados = CambioDados(networking: HTTPNetworking())
    var listaValores: Valores?

    @IBOutlet weak var moedaOrigemButton: UIButton!
    @IBOutlet weak var moedaDestinoButton: UIButton!
    @IBOutlet weak var valorFinalLabel: UILabel!
    @IBOutlet weak var dataAtualizacao: UILabel!
    @IBOutlet weak var valorEntrada: UITextField!
    var moedaOrigem = ""
    var moedaDestino = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        valorEntrada.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @IBAction func escolheMoedaOrigem(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ListaMoedasViewController", creator: { coder in
            return ListaMoedasViewController(coder: coder, ehMoedaOrigem: true)
        }) else {
            fatalError("Problemas em carregar ListaVideoViewController do storyboard.")
        }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func escolheMoedaDestino(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ListaMoedasViewController", creator: { coder in
            return ListaMoedasViewController(coder: coder, ehMoedaOrigem: false)
        }) else {
            fatalError("Problemas em carregar ListaVideoViewController do storyboard.")
        }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func enviaValores(codigoMoeda: String, descricaoMoeda: String, ehMoedaOrigem: Bool) {
        let texto = "\(codigoMoeda) - \(descricaoMoeda)"
        if ehMoedaOrigem {
            moedaOrigemButton.setTitle(texto, for: .normal)
            moedaOrigem = codigoMoeda
        } else {
            moedaDestinoButton.setTitle(texto, for: .normal)
            moedaDestino = codigoMoeda
        }
        if let valor1 = Double(valorEntrada.text ?? "0.0") {
            if moedaOrigem != "" && moedaDestino != "" {
                cambioDados.calculaCambio(moedaOrigem: moedaOrigem, moedaDestino: moedaDestino, valor: valor1) { calculo in
                    DispatchQueue.main.async {
                        if calculo == nil {
                            self.valorFinalLabel.text = "0,00"
                            self.dataAtualizacao.text = "Problemas em buscar as informações."
                        } else {
                            let currencyFormatter = NumberFormatter()
                            currencyFormatter.usesGroupingSeparator = true
                            currencyFormatter.numberStyle = .decimal
                            currencyFormatter.decimalSeparator = ","
                            currencyFormatter.alwaysShowsDecimalSeparator = true
                            currencyFormatter.maximumFractionDigits = 2
                            currencyFormatter.groupingSeparator = "."
                            self.valorFinalLabel.text = currencyFormatter.string(from: NSNumber(value: calculo!))
                        }
                    }
                }
                
            }
        }
    }
    
    @objc func textFieldDidChange() {
        if let valor1 = Double(valorEntrada.text ?? "0.0") {
            if moedaOrigem != "" && moedaDestino != "" {
                cambioDados.calculaCambio(moedaOrigem: moedaOrigem, moedaDestino: moedaDestino, valor: valor1) { calculo in
                    DispatchQueue.main.async {
                        if calculo == nil {
                            self.valorFinalLabel.text = "0,00"
                            self.dataAtualizacao.text = "Problemas em buscar as informações."
                        } else {
                            let currencyFormatter = NumberFormatter()
                            currencyFormatter.usesGroupingSeparator = true
                            currencyFormatter.numberStyle = .decimal
                            currencyFormatter.decimalSeparator = ","
                            currencyFormatter.alwaysShowsDecimalSeparator = true
                            currencyFormatter.maximumFractionDigits = 2
                            currencyFormatter.groupingSeparator = "."
                            self.valorFinalLabel.text = currencyFormatter.string(from: NSNumber(value: calculo!))
                        }
                    }
                }
            }
        }
    }
}

