//
//  AboutViewController.swift
//  MYX
//
//  Created by Aman on 29/10/21.
//

import UIKit

class AboutViewController: UIViewController {

    //MARK: outlets
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var indexScreen = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setuUI()
        // Do any additional setup after loading the view.
    }
    
    func setuUI(){
        if indexScreen == 0{
            self.txtView.text = whyScreenMsg
            self.titleLbl.text = "Why?"
        }else if indexScreen == 1{
            self.txtView.text = howToPlayMsg
            self.titleLbl.text = "How to play?"
        }else{
            self.txtView.text = gameIdeaMSG
            self.titleLbl.text = "Game ideas"
        }
        
    }

    //MARK: button actions
    @IBAction func crossBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
