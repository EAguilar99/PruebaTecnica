//
//  ViewController.swift
//  PruebaTecnica
//
//  Created by MacBookMBA17 on 10/11/23.
//

import UIKit

class ViewController: UIViewController {
    var getAllBanks = Bank()
    var banks = [Results]()
    var existe = false
    
    @IBOutlet weak var tableBanks: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        let existe = validarDatos()
        self.tableBanks.delegate = self
        self.tableBanks.dataSource = self
        self.tableBanks.register(UINib(nibName: "BankCell", bundle: .main), forCellReuseIdentifier: "banks")

           
    }
    
    func validarDatos() -> Bool{
        if banks.count > 0 {
            existe = true
            loadData()
        }else{
            existe = false
            updateUI()
        }
        return existe
    }
    
    func loadData(){
        banks = getAllBanks.GetAllCoreData()
    }
    
    func save(banks: [Results]){
        for i in 0..<banks.count{
            getAllBanks.AddCoreData(bank: banks[i])
        }
    }

    func updateUI()
    {
        getAllBanks.GetAll{result, error in
            if let resultSource = result{
                self.banks = resultSource
                self.save(banks: self.banks)
                DispatchQueue.main.async {
                    self.tableBanks.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if existe{
            let alert = UIAlertController(title: "", message: "Los datos se han obtenido de la BD", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "", message: "Los datos se han optenido de la API", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let alertController = UIAlertController(title: "Detalles del Banco", message: "\(banks[indexPath.row].bankName!) \n \(banks[indexPath.row].description!)", preferredStyle: .alert)
        
        let url = URL(string: banks[indexPath.row].url!)!
        let imageView = UIImageView(frame: CGRect(x: 60, y: 100, width: 150, height: 150))
        imageView.load(url: url)
             
             alertController.view.addSubview(imageView)
             
        let heightConstraint = NSLayoutConstraint(item: alertController.view!,
                                                         attribute: NSLayoutConstraint.Attribute.height,
                                                         relatedBy: NSLayoutConstraint.Relation.equal,
                                                         toItem: nil,
                                                         attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                         multiplier: 1,
                                                         constant: 300)

               alertController.view.addConstraint(heightConstraint)
        
        
             let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
             alertController.addAction(okAction)
             
             present(alertController, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "banks") as! BankCell
        
        let urlImage = URL(string: banks[indexPath.row].url!)!
        
        cell.imageBank.layer.cornerRadius = 20
        cell.imageBank.load(url: urlImage)
        cell.nameBank.text = banks[indexPath.row].bankName
        cell.detalle.text = ("Descripcion:\(banks[indexPath.row].description!)")
        cell.age.text = ("Edad: \(String(banks[indexPath.row].age!)) años")
        
        return cell
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
