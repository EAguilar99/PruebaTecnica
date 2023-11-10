//
//  GetAllBanks.swift
//  PruebaTecnica
//
//  Created by MacBookMBA17 on 10/11/23.
//

import Foundation
import CoreData
import UIKit

class Bank
{
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func GetAll(resp: @escaping([Results]?,Error?)-> Void){
        
        let url = URL(string: "https://dev.obtenmas.com/catom/api/challenge/banks")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){data, response, error in
            
            let httpResponse = response as! HTTPURLResponse
            if 200 == httpResponse.statusCode
            {
                if let dataSource = data{
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode([Results].self, from: dataSource)
                    resp(result,nil)
                }
            }
        }.resume()
    }
    
    func AddCoreData(bank: Results){
        
        do{
            
            let context = appDelegate.persistentContainer.viewContext
            let entidad = NSEntityDescription.entity(forEntityName: "Banks", in: context)
            let bankCoreData = NSManagedObject(entity: entidad!, insertInto: context)
            let imageData = try Data(contentsOf: URL(string: bank.url!)!)
            //print(imageData)
            
            bankCoreData.setValue(imageData, forKey: "image")
            bankCoreData.setValue(bank.bankName, forKey: "bankName")
            bankCoreData.setValue(bank.description, forKey: "descripcion")
            bankCoreData.setValue(bank.age, forKey: "age")
            bankCoreData.setValue(bank.url, forKey: "url")
            
            try context.save()
            //print("Guardado")
            
        }catch let error{
            print("Error al guardad \(error)")
        }
    }
    
    func GetAllCoreData() -> [Results]{
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Banks")
        var banksArray  = [Results]()
        do{
            
            let banks = try context.fetch(request)
            for objBank in  banks as! [NSManagedObject]{
                
                var bank = Results()
                bank.bankName = (objBank.value(forKey: "bankName") as! String)
                bank.description = objBank.value(forKey: "descripcion") as! String
                bank.age = objBank.value(forKey: "age") as! Int
                bank.url = objBank.value(forKey: "url") as! String
                bank.image = objBank.value(forKey: "image") as? Data
                
                banksArray.append(bank)
            }
            
        }catch let error{
            print(error)
        }
        return banksArray
    }
    
    
}




