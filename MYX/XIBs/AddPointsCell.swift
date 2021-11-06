//
//  AddPointsCell.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit

class AddPointsCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gameLbl: UIView!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backView.backgroundColor = UIColor.colorFromHex("F3F3F3")
        self.backView.cornerRadius = 17
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
