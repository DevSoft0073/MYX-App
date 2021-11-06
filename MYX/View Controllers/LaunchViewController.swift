//
//  LaunchViewController.swift
//  MYX
//
//  Created by Aman on 08/10/21.
//

import UIKit

class LaunchViewController: UIViewController {
    //MARK: outlets
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var emailFld: DefaultTextField!
    @IBOutlet weak var passwordFld: DefaultTextField!
    @IBOutlet weak var signBtn: UIButton!
    
    let firebaseControllerHandle  : FIRController = FIRController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordFld.isSecureTextEntry = true

//        self.signupBtn.setAttributedText(startingText: "Don’t have an account?", textColor: .darkGray, font: UIFont(name: AppDefaultNames.sansHebrewRegular, size: 14)!, lastText: "Create account", secondaryTextColor: .black, secondaryFont: UIFont(name: AppDefaultNames.sansHebrewBold, size: 14)!)
    }
    
    override func viewDidLayoutSubviews() {
        self.backView.roundCorners([.topLeft,.topRight], radius: 40)
    }

    //MARK: login
    //MARK: login firebase
    func loginAuth(){
        if emailFld.text!.isEmpty {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter email address", ["Ok"], completion: nil)
        } else if emailFld.text!.isValidEmail(emailFld.text!) == false {
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter valid email address", ["Ok"], completion: nil)
        }else if passwordFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter password", ["Ok"], completion: nil)
        }else{
            firebaseControllerHandle.loginUser(emailFld.text, password: passwordFld.text!) { (userId) in
               //
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    
    //MARK: Button actions
    
    @IBAction func signupBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.loginAuth()
    }
    
}
