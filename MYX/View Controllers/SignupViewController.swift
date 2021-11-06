//
//  SignupViewController.swift
//  MYX
//
//  Created by Aman on 09/10/21.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextFld: DefaultTextField!
    @IBOutlet weak var passwordFld: DefaultTextField!
    @IBOutlet weak var retyprPwdFld: DefaultTextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameFld: DefaultTextField!
    
    let firebaseControllerHandle  : FIRController = FIRController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordFld.isSecureTextEntry = true
        self.retyprPwdFld.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.backView.roundCorners([.topLeft,.topRight], radius: 40)
    }

    //MARK: Create user
    func createUser(){
        if nameFld.text!.isEmpty{
           displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter your name", ["Ok"]) { (index) in
               
           }
       }
        else if emailTextFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter your email address", ["Ok"]) { (index) in
                
            }
        }else if emailTextFld.text!.isValidEmail(emailTextFld.text!) == false{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter valid email address", ["Ok"]) { (index) in
                
            }
            
        }
        else if passwordFld.text!.isEmpty || retyprPwdFld.text!.isEmpty{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Please enter password", ["Ok"]) { (index) in
                
            }
            
        }else if passwordFld.text! != retyprPwdFld.text{
            displayALertWithTitles(title: AppDefaultNames.name, message: "Password doesn't match", ["Ok"]) { (index) in
                
            }
        }else{
            firebaseControllerHandle.createAndSaveUser(name: nameFld.text!, emailAddress: emailTextFld.text!, password: passwordFld.text!) { (uid) in
                //
                print("User created")
                let date = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
                appDelegate().scheduleNotification(at: date!, identifierUnic: AppDefaultNames.firstTimeNotificaitonID, body: DefaultsNotificationContent.firstTimeMsg , titles: "Welcome to the Ultimate Game \(UserManager.shared.fullName ?? "")")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                    self.navigationController?.pushViewController(vc, animated: true)
                }

            }
        }
    }
    
    
    @IBAction func createBtn(_ sender: UIButton) {
        self.createUser()
    }
    

    @IBAction func signInBtn(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

}
