//
//  HomeViewController.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit
import JJFloatingActionButton
import Charts
import TinyConstraints
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var noMsgLbl: UILabel!
    @IBOutlet weak var percentView: UIView!
//    @IBOutlet weak var percentageLbl: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scoreLbl: UILabel!
//    @IBOutlet weak var compareLbl: UILabel!
    @IBOutlet weak var thirtyDaysBtn: UIButton!
    @IBOutlet weak var sixtyDaysBtn: UIButton!
    @IBOutlet weak var allBtn: UIButton!
    
    @IBOutlet weak var lineChartBtn: UIButton!
    @IBOutlet weak var pieChartBtn: UIButton!
    @IBOutlet weak var graphBackView: UIView!
    @IBOutlet weak var allDot: UILabel!
    @IBOutlet weak var sixtyDot: UILabel!
    @IBOutlet weak var buttonBackView: UIView!
    
    @IBOutlet weak var thirtyDot: UILabel!
    
    let firebaseControllerHandle  : FIRController = FIRController()
    var currentScore : Float = 0
    
    var monthlyData : [OverAllWeekData] = [OverAllWeekData]()
    var allData : [WeekData] = [WeekData]()
    var backupAllData : [WeekData] = [WeekData]()
    
    lazy var lineChartView : LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.gridColor = .clear
        yAxis.axisLineColor = .white
        yAxis.labelFont = UIFont(name: AppDefaultNames.sansHebrewBold, size: 12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .outsideChart
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: AppDefaultNames.sansHebrewBold, size: 12)!
        chartView.xAxis.setLabelCount(0, force: false)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .white
        chartView.animate(xAxisDuration: 2.5)
        chartView.gridBackgroundColor = .clear
        chartView.xAxis.gridColor = .clear
        chartView.noDataText = self.noMsgLbl.text ?? ""
        chartView.noDataTextColor = .white
        return chartView
    }()
    
    
   lazy var pieChartView : PieChartView = {
        let chartView = PieChartView()
    chartView.holeColor = .clear
    chartView.transparentCircleRadiusPercent = 0
    chartView.legend.enabled = false
    chartView.chartDescription?.enabled = false
    chartView.minOffset = 16
        return chartView
    }()
    
    var yValues : [ChartDataEntry] = [ChartDataEntry]()
    
    var randomClrs = ["C0C0C0","728FCE","2554C7","1589FF","C6DEFF","C9DFEC","D5D6EA","E3F9A6","FAEBD7","FED8B1","FBE7A1","FFF380","E2A76F","E6BF83","FFA07A","C5908E","FFE6E8","FFB6C1","EE82EE","6960EC","5453A6","7F38EC","CCCCFF","D891EF","E9E4D4","FFFAFA"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkDB()
        self.addFloatingButton()
        self.addInfoButton()
        self.nameLbl.text = "Welcome, \(UserManager.shared.fullName ?? "")"
        self.noMsgLbl.isHidden = true
        self.sixtyDot.isHidden = true
        self.thirtyDot.isHidden = true
        self.setupChartView()
        self.yValues.removeAll()
        self.setDataInChart()
        let months = ["", "", "", "", "", ""]
        let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        setChart(dataPoints: months, values: unitsSold)

    }
    
    
    
    override func viewDidLayoutSubviews() {
        self.percentView.layer.cornerRadius = 20
        self.percentView.addShadow()
        self.lineChartBtn.addShadow()
        self.pieChartBtn.addShadow()
        self.pieChartBtn.layer.cornerRadius = 20
        self.lineChartBtn.layer.cornerRadius = 20
        
        self.thirtyDaysBtn.addShadow()
        self.thirtyDaysBtn.layer.cornerRadius = 20
        self.thirtyDaysBtn.layer.cornerRadius = 20

        self.sixtyDaysBtn.addShadow()
        self.sixtyDaysBtn.layer.cornerRadius = 20
        self.sixtyDaysBtn.layer.cornerRadius = 20

        self.allBtn.addShadow()
        self.allBtn.layer.cornerRadius = 20
        self.allBtn.layer.cornerRadius = 20


    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWeeksData()
    }
    
    
    //Create chart View
    func setupChartView(){
        self.view.addSubview(lineChartView)
        self.lineChartView.width(to: graphBackView)
        self.lineChartView.height(to: graphBackView)
        self.lineChartView.center(in: graphBackView)
        
        self.view.addSubview(pieChartView)
        self.pieChartView.width(to: graphBackView)
        self.pieChartView.height(to: graphBackView)
        self.pieChartView.center(in: graphBackView)
        self.pieChartView.isHidden = true
    }
    
    func setDataInChart(){
        lineChartView.clear()
        let set1  = LineChartDataSet(entries: yValues, label: "Total Points")
        set1.drawCirclesEnabled = false
        set1.mode = .horizontalBezier
        set1.lineWidth = 1
        set1.valueTextColor = .white
        set1.setColor(UIColor.white)
        let gradientColors = [AppTheme.defaultBlue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations:[CGFloat] = [1.0, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        set1.fill = Fill.fillWithRadialGradient(gradient!)
        set1.drawFilledEnabled = true

        
        let data = LineChartData(dataSet: set1)
        
        data.setDrawValues(false)
        lineChartView.legend.font = UIFont(name: AppDefaultNames.sansFontNameBold, size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        lineChartView.legend.textColor = .white

        lineChartView.data = data
        if data.entryCount == 0{
            lineChartView.clear()
        }
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [ChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry1 = PieChartDataEntry(value: values[i], label: dataPoints[i])

            dataEntries.append(dataEntry1)
        }

        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Total Points")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        pieChartView.legend.textColor = .white
//        pieChartDataSet.selectionShift = 10
        pieChartView.legend.font = UIFont(name: AppDefaultNames.sansFontNameBold, size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        pieChartView.holeRadiusPercent = 0.75
        var colors: [UIColor] = []

        for _ in 0..<dataPoints.count {
            colors.append(UIColor.colorFromHex(randomClrs.randomElement()!))
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        formatter.zeroSymbol = ""
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        
        
        pieChartDataSet.colors = colors
        pieChartDataSet.yValuePosition = .outsideSlice
        pieChartDataSet.xValuePosition = .outsideSlice
        pieChartDataSet.valueLineColor = .white
        pieChartDataSet.valueColors = [UIColor.white]
        let legend = pieChartView.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical
        legend.xEntrySpace = 10.0
        legend.yEntrySpace = 8.0
        

        if dataEntries.count == 0{
            self.pieChartView.clear()
            self.pieChartView.noDataText = self.noMsgLbl.text ?? ""
            self.pieChartView.noDataTextColor = .white
        }
     }
   
    
    //MARK: update count
    func fetchTotalScore(){
//        self.compareLbl.isHidden = true
//        self.percentageLbl.isHidden = true
        firebaseControllerHandle.fetchCurrentWeekGames { (data) in
            var count = 0
            for dataDict in data{
                    let point = dataDict.points
                    let intCount = Int(point) ?? 0
                    count += intCount
            }
            self.scoreLbl.text = "\(count)"
            self.currentScore = Float(count)
            
        }
    }
    
    func getWeeksData(){
        DispatchQueue.main.async {
            UIApplication.topViewController()?.showLoader()
        }
//        self.barChartView.isHidden = true
        let savedDate = "\(Date().getCurrentMonth())-\(Date().getCurrenYear())"

        firebaseControllerHandle.getWeeksDataForChart(weekNDate: savedDate) { (data) in
            DispatchQueue.main.async {
                UIApplication.topViewController()?.hideLoader()
                self.allData.removeAll()
                self.yValues.removeAll()
                self.allData = data
                self.backupAllData = data
                self.setGraph()
            }
            print("data for chart",data)
                
        }
    }
    
    func fetchLimitedMonthData(isSIxty : Bool){
        var oldTimeStamp : Timestamp?
        if isSIxty{
            let fromDate = Calendar.current.date(byAdding: .day, value: -60, to: Date())
            oldTimeStamp = Timestamp(date: fromDate!)
        }else{
            let fromDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
            oldTimeStamp = Timestamp(date: fromDate!)
        }
//        print("here is old time and date ",oldTimeStamp?.dateValue())
        firebaseControllerHandle.fetchLimitedData(startDateFrom: oldTimeStamp!) { (data) in
            DispatchQueue.main.async {
                self.allData = data
                self.setGraph()
            }
        }
        
    }
    
    
    func setGraph(){
        var entry : [ChartDataEntry] = [ChartDataEntry]()
        var index = 0.0
        
        for data in self.allData{
//            data.
            entry.append(ChartDataEntry(x: index, y: Double(data.points) ?? 0.0))
            index += 1.0
        }
        self.yValues.removeAll()
        self.yValues = entry
        self.setDataInChart()
        
        
        
        
        var gamesTotal = [String]()
        var gamesPoints = [Double]()
        self.getTotalPoints { (totalPoints) in
            UserManager.shared.totalPoints = "\(totalPoints)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [AppDefaultNames.everySundayNotificaitonID,AppDefaultNames.everyMondayNotificaitonID])
            self.setNotificationSunday()
            print("here is total sum",totalPoints)
            for data in self.backupAllData{
                let str = "\(data.points)\n\(data.name)"
                gamesTotal.append(str)
                let percent = (Double(data.points)! / Double(totalPoints)) * 100
                gamesPoints.append(percent)
            }
            
            self.setChart(dataPoints: gamesTotal, values: gamesPoints)

        }

        
        
        
    }
    func getTotalPoints(completionHandler : @escaping ((_ totalPoints : Double) -> Void)){
        var count = 0.0
        for data in self.backupAllData{
            count += Double(data.points) ?? 0.0
        }
        completionHandler(count)
    }
    
    
    func setNotificationSunday(){
        let sundayDate = Date.today().next(.sunday)
        appDelegate().scheduleNotification(at: sundayDate, identifierUnic: AppDefaultNames.everySundayNotificaitonID, body: DefaultsNotificationContent.everySundayMsg, titles: "Congratulations \(UserManager.shared.fullName ?? "")!")
        
        let mondayDate = Date.today().next(.monday)
        appDelegate().scheduleNotification(at: mondayDate, identifierUnic: AppDefaultNames.everyMondayNotificaitonID, body: DefaultsNotificationContent.everyMondayMsg, titles: "Are you ready?")

        
    }
    
    func fetchAverage(){
        firebaseControllerHandle.getLastWeekAverage { (msg) in
            print(msg as Any)
            if msg == ""{
//                self.compareLbl.isHidden = true
//                self.percentageLbl.isHidden = true
            }else{
//                self.compareLbl.isHidden = false
//                self.percentageLbl.isHidden = false
                let intLastCount = Float(msg ?? "0") ?? 0
                let average =   self.calculatePercentage(value: Double(intLastCount), percentageVal: Double(self.currentScore))
                if intLastCount == 0{
//                    self.percentageLbl.isHidden = true
//                    self.compareLbl.isHidden = true
                }else{
//                    self.percentageLbl.isHidden = false
//                    self.compareLbl.isHidden = false
                    if intLastCount < self.currentScore{
//                        self.percentageLbl.textColor = .systemGreen
//                        self.percentageLbl.text = "+\(average)%"

                    }else{
//                        self.percentageLbl.textColor = .systemRed
//                        self.percentageLbl.text = "-\(average)%"

                    }
                    print("here is our average",average)
//                    self.percentageLbl.text = "\(average)%"
                }
            }
        }
    }
    
    //Calucate percentage based on given values
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
    //check
    func checkDB(){
        firebaseControllerHandle.checkIsUSerAddGameFirstTime { (isFirstTime) in
            print(isFirstTime)
            self.fetchTotalScore()
        }
    }
    //MARK: push
    func pushToAddGameVC(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddGameViewController") as? AddGameViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    //MARK: push
    func pushToAddPoints(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddPointsViewController") as? AddPointsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //MARK: push
    func pushtoObjectiveVC(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ObjectivesViewController") as? ObjectivesViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func pushToAboutScreen(index : Int){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController{
            vc.indexScreen = index
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    func addFloatingButton(){
        let actionButton = JJFloatingActionButton()
        actionButton.buttonImage = UIImage(named: "add")

        actionButton.addItem(title: "Add Game", image: UIImage(named: "ic_place")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.pushToAddGameVC()
            }
        }
        
        
        
        actionButton.addItem(title: "Add Points", image: UIImage(named: "ic_system")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.pushToAddPoints()
        }
        
        
        actionButton.addItem(title: "Logout", image: UIImage(named: "ic_cloud")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            displayALertWithTitles(title: AppDefaultNames.name, message: "Are you sure want to Logout?", ["Log Out","Cancel"]) { (index) in
                if index == 0{
                    self.firebaseControllerHandle.logout()
                }
            }
        }
        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        actionButton.buttonColor = .clear
        actionButton.itemSizeRatio = CGFloat(0.75)
        actionButton.buttonImageSize = CGSize(width: 42, height: 42)

        actionButton.configureDefaultItem { item in
            item.titlePosition = .leading
            
            item.titleLabel.font = UIFont(name: AppDefaultNames.sansHebrewBold, size: 16)
            item.titleLabel.textColor = .white
            item.imageView.tintColor = AppTheme.defaultBlue
            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.4)
            item.layer.shadowRadius = CGFloat(2)
        }
        actionButton.display(inViewController: self)
    }
    
    func addInfoButton(){
        let actionButton = JJFloatingActionButton()

       
        
     
        
        actionButton.addItem(title: "Game Ideas", image: UIImage(named: "gameIdeas")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.pushToAboutScreen(index: 2)
        }
        
        actionButton.addItem(title: "How to play?", image: UIImage(named: "how")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
            self.pushToAboutScreen(index: 1)

        }
        actionButton.addItem(title: "Why?", image: UIImage(named: "why")?.withRenderingMode(.alwaysTemplate)) { item in
            print("hello")
            self.pushToAboutScreen(index: 0)
        }
        
        actionButton.buttonImageSize = CGSize(width: 42, height: 42)
        view.addSubview(actionButton)
        actionButton.buttonImage = UIImage(named: "info")
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        actionButton.buttonColor = .clear
        actionButton.itemSizeRatio = CGFloat(0.75)
        
        actionButton.configureDefaultItem { item in
            item.titlePosition = .trailing
            
            item.titleLabel.font = UIFont(name: AppDefaultNames.sansHebrewBold, size: 16)
            item.titleLabel.textColor = .white
            item.imageView.tintColor = AppTheme.defaultBlue
            item.layer.shadowColor = UIColor.white.cgColor
            item.layer.shadowOffset = CGSize(width: 0, height: 1)
            item.layer.shadowOpacity = Float(0.7)
            item.layer.shadowRadius = CGFloat(2)
        }
        actionButton.display(inViewController: self)
    }
    
    
    @IBAction func lineChartBtn(_ sender: UIButton) {
        self.pieChartView.isHidden = true
        self.lineChartView.isHidden = false
        self.buttonBackView.isHidden = false
    }
    @IBAction func pieChartBtn(_ sender: UIButton) {
        self.pieChartView.isHidden = false
        self.lineChartView.isHidden = true
        self.buttonBackView.isHidden = true
    }
    
    @IBAction func allBtn(_ sender: UIButton) {

        self.allDot.isHidden = false
        self.sixtyDot.isHidden = true
        self.thirtyDot.isHidden = true
        self.getWeeksData()

    }
    @IBAction func sixtyBtn(_ sender: UIButton) {
        self.sixtyDot.isHidden = false
        self.thirtyDot.isHidden = true
        self.allDot.isHidden = true
        self.fetchLimitedMonthData(isSIxty: true)

    }
    @IBAction func thirtyBtn(_ sender: UIButton) {
        self.sixtyDot.isHidden = true
        self.thirtyDot.isHidden = false
        self.allDot.isHidden = true
        self.fetchLimitedMonthData(isSIxty: false)
    }
}


extension HomeViewController: ChartViewDelegate{
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView == pieChartView{
            print(highlight.dataIndex)
        }
    }
}
