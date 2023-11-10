//
//  BankCell.swift
//  PruebaTecnica
//
//  Created by MacBookMBA17 on 10/11/23.
//

import UIKit

class BankCell: UITableViewCell {

    @IBOutlet weak var imageBank: UIImageView!
    @IBOutlet weak var nameBank: UILabel!
    @IBOutlet weak var detalle: UILabel!
    @IBOutlet weak var age: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
