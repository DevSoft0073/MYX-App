//
//  ObjectiveCell.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit

class ObjectiveCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.backgroundColor = UIColor.colorFromHex("F3F3F3")
        self.backView.cornerRadius = 10

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
