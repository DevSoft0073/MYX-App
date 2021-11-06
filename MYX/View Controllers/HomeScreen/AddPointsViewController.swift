//
//  AddPointsViewController.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit

class AddPointsViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    var totalGames : [GameModel] = [GameModel]()
    let firebaseControllerHandle  : FIRController = FIRController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchLists()
    }
    
    override func viewDidLayoutSubviews() {
        self.backView.roundCorners([.topLeft,.topRight], radius: 40)
    }
    
    //MARK: register  Nibs
    func registerNibs(){
        tblView.register(UINib(nibName: "AddPointsCell", bundle: nil), forCellReuseIdentifier: "AddPointsCell")
        tblView.tableFooterView = UIView()
        tblView.estimatedRowHeight = 100
        
    }
    
    //MARK: fetch List
    func fetchLists(){
        firebaseControllerHandle.fetchCurrentWeekGames { (model) in
            self.totalGames.removeAll()
            self.totalGames = model
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }

//MARK: Button actions
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  

}


extension AddPointsViewController : UITableViewDelegate,UITableViewDataSource{
    
    @objc func addPointBtnTap(_ sender : UIButton){
        firebaseControllerHandle.updatePointInGame(data: self.totalGames[sender.tag]) { (msg) in
            print(msg ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPointsCell") as? AddPointsCell
        let data = self.totalGames[indexPath.row]
        cell?.nameLbl.text = data.name
        cell?.pointsLbl.text = data.points
        cell?.addBtn.tag = indexPath.row
        cell?.addBtn.addTarget(self, action: #selector(addPointBtnTap(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
