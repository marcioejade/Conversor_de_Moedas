//
//  ListaMoedasTableViewCell.swift
//  Conversor de Moedas
//
//  Created by Marcio Izar Bastos de Oliveira on 16/10/20.
//

import UIKit

class ListaMoedasTableViewCell: UITableViewCell {
    @IBOutlet weak var codigo: UILabel!
    @IBOutlet weak var descricao: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
