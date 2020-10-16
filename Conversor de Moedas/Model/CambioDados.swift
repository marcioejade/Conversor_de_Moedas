//
//  CambioDados.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 14/10/20.
//

import Foundation
import CoreData

class CambioDados {
    var networking: Networking
    var listaValores: Valores?
    var listaMoedas: Moedas?
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getMoedas(completion: @escaping (Moedas?) -> ()) {
        if self.listaMoedas == nil {
            getListaMoedas() { moedas in
                self.listaMoedas = moedas
                completion(moedas)
            }
        } else {
            completion(self.listaMoedas)
        }
    }
    
    func getListaMoedas(completion: @escaping (Moedas?) -> ()) {
        networking.request(from: CurrencyLayer.listaMoedas, parameters: nil) { data, error in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                completion(self.getListaMoedasCoreData())
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let model = try decoder.decode(Moedas.self, from: dataResponse)
                
                completion(model)
                self.setListaMoedasCoreData(listaMoedas: model)
            } catch let parsingError {
                print("Erro Desconhecido - ", parsingError)
                print("JSON String: \(String(data: dataResponse, encoding: .utf8) ?? "")")
                completion(self.getListaMoedasCoreData())
            }
        }
    }
    
    func getValores(completion: @escaping (Valores?) -> ()) {
        networking.request(from: CurrencyLayer.conversao, parameters: nil) { data, error in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                completion(self.getListaValoresCoreData())
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let model = try decoder.decode(Valores.self, from: dataResponse)
                
                completion(model)
                self.setListaValoresCoreData(listaValores: model)
            } catch let parsingError {
                print("Erro Desconhecido - ", parsingError)
                print("JSON String: \(String(data: dataResponse, encoding: .utf8) ?? "")")
                completion(self.getListaValoresCoreData())
            }
        }
    }
    
    func setListaMoedasCoreData(listaMoedas: Moedas) {
        deleteAllData("ListaDeMoedas")
        guard let currencies = listaMoedas.currencies else { return }
        
        for moeda in currencies {
            let coreData = CoreData()
            let context = coreData.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "ListaDeMoedas", in: context)
            let newListaMoedas = NSManagedObject(entity: entity!, insertInto: context)
            
            newListaMoedas.setValue(moeda.key, forKey: "codigo")
            newListaMoedas.setValue(moeda.value, forKey: "nome")
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setListaValoresCoreData(listaValores: Valores) {
        deleteAllData("ListaDeValores")
        guard let quotes = listaValores.quotes else { return }

        for valor in quotes {
            let coreData = CoreData()
            let context = coreData.persistentContainer.viewContext
            
            let entity = NSEntityDescription.entity(forEntityName: "ListaDeValores", in: context)
            let newListaValores = NSManagedObject(entity: entity!, insertInto: context)
            
            newListaValores.setValue(valor.key, forKey: "codigo")
            newListaValores.setValue(valor.value, forKey: "valor")
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func getListaMoedasCoreData() -> Moedas? {
        let coreData = CoreData()
        let context = coreData.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ListaDeMoedas")

        do {
            var strMoeda = ""
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if result.value(forKey: "codigo") != nil {
                    strMoeda += "\""
                    let codigo = result.value(forKey: "codigo") as! String
                    let nome = result.value(forKey: "nome") as! String
                    strMoeda += codigo
                    strMoeda += "\": \""
                    strMoeda += nome
                    strMoeda += "\","
                }
            }
            strMoeda = "{\"success\": true, \"currencies\": {" + strMoeda
            strMoeda += "}}"
            
            let decoder = JSONDecoder()
            //Decode JSON Response Data
            let model = try decoder.decode(Moedas.self, from: strMoeda.data(using: .utf8)!)

            return model
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getListaValoresCoreData() -> Valores? {
        let coreData = CoreData()
        let context = coreData.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ListaDeValores")

        do {
            var strValor = ""
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if result.value(forKey: "codigo") != nil {
                    strValor += "\""
                    let codigo = result.value(forKey: "codigo") as! String
                    let valor = (result.value(forKey: "valor") as! Double).description
                    strValor += codigo
                    strValor += "\": \""
                    strValor += valor
                    strValor += "\","
                }
            }
            strValor = "{\"success\": true, \"quotes\": {" + strValor
            strValor += "}}"
            
            let decoder = JSONDecoder()
            //Decode JSON Response Data
            let model = try decoder.decode(Valores.self, from: strValor.data(using: .utf8)!)

            return model
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    
    func deleteAllData(_ entity:String) {
        let coreData = CoreData()
        let context = coreData.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func calculaCambio(moedaOrigem: String, moedaDestino: String, valor: Double, completion: @escaping (Double?) -> ()) {
        if self.listaValores == nil {
            getValores() { valores in
                self.listaValores = valores
                completion(self.buscaValorMoeda(moedaOrigem: moedaOrigem, moedaDestino: moedaDestino, multiplicador: valor))
            }
        } else {
            completion(self.buscaValorMoeda(moedaOrigem: moedaOrigem, moedaDestino: moedaDestino, multiplicador: valor))
        }
    }    
    private func buscaValorMoeda(moedaOrigem: String, moedaDestino: String, multiplicador: Double) -> Double? {
        if moedaOrigem == moedaDestino {
            return multiplicador
        } else {
            if moedaOrigem == "USD" {
                guard let valor: Double = listaValores?.quotes?[moedaOrigem + moedaDestino] else { return nil }
                return valor * multiplicador
            } else {
                if moedaDestino == "USD" {
                    guard let valorOrigem: Double = listaValores?.quotes?["USD" + moedaOrigem] else { return nil }
                    return (1/valorOrigem * multiplicador)
                } else {
                    guard let valorOrigem: Double = listaValores?.quotes?["USD" + moedaOrigem] else { return nil }
                    guard let valorDestino: Double = listaValores?.quotes?["USD" + moedaDestino] else { return nil }
                    return (1/valorOrigem * valorDestino * multiplicador)
                }
            }
        }
    }
    
}
