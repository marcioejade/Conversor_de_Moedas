//
//  ListaMoedasViewController.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 16/10/20.
//

import UIKit

protocol ListaMoedasViewControllerDelegate {
    func enviaValores(codigoMoeda: String, descricaoMoeda: String, ehMoedaOrigem: Bool)
}

class ListaMoedasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ordenarPorCodigoButton: UIButton!
    @IBOutlet weak var ordenarPorNomeButton: UIButton!
    var ehMoedaOrigem: Bool

    init?(coder: NSCoder, ehMoedaOrigem: Bool) {
        self.ehMoedaOrigem = ehMoedaOrigem
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("É necessário passar a origem (ehMoedaOrigem - se veio do botão origem ou destino) para criar este View Controller.")
    }
    
    @IBOutlet weak var listaMoedasTableView: UITableView!
    
    let cambioDados = CambioDados(networking: HTTPNetworking())
    var listaMoedas: Moedas?
    var keysArray: [String] = []
    var delegate: ListaMoedasViewControllerDelegate!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMoedas?.currencies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListaMoedasTableViewCell
        
        let currentKey = keysArray[indexPath.row]
        cell?.codigo.text = currentKey
        cell?.descricao.text = listaMoedas?.currencies?[currentKey]

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentKey = keysArray[indexPath.row]
        delegate.enviaValores(codigoMoeda: currentKey, descricaoMoeda: ((listaMoedas?.currencies?[currentKey]) ?? ""), ehMoedaOrigem: ehMoedaOrigem)
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cambioDados.getMoedas() { moedas in
            self.listaMoedas = moedas
            DispatchQueue.main.async {
                self.keysArray = Array((moedas?.currencies?.keys)!.sorted())
                self.listaMoedasTableView.reloadData()
            }
        }
    }
    
    @IBAction func ordenarPorCodigo(_ sender: Any) {
        ordenarPorCodigoButton.layer.borderWidth = 1
        ordenarPorCodigoButton.layer.cornerRadius = 5
        ordenarPorCodigoButton.layer.borderWidth = 1
        ordenarPorCodigoButton.layer.borderColor = UIColor.systemBlue.cgColor
        ordenarPorNomeButton.layer.borderWidth = 0

        keysArray = Array((listaMoedas?.currencies?.keys)!.sorted())
        listaMoedasTableView.reloadData()
    }
    
    @IBAction func ordenarPorDescricao(_ sender: Any) {
        ordenarPorNomeButton.layer.borderWidth = 1
        ordenarPorNomeButton.layer.cornerRadius = 5
        ordenarPorNomeButton.layer.borderWidth = 1
        ordenarPorNomeButton.layer.borderColor = UIColor.systemBlue.cgColor
        ordenarPorCodigoButton.layer.borderWidth = 0
        
        keysArray = Array((listaMoedas?.currencies?.keys)!.sorted(by: {(listaMoedas?.currencies![$0])! < (listaMoedas?.currencies![$1])!}))
        listaMoedasTableView.reloadData()
    }
}
