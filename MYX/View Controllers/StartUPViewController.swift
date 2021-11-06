//
//  StartUPViewController.swift
//  MYX
//
//  Created by Aman on 09/10/21.
//

import UIKit

class StartUPViewController: UIViewController {

    @IBOutlet weak var gifImage: UIImageView!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

}
