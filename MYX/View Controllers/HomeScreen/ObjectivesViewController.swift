//
//  ObjectivesViewController.swift
//  MYX
//
//  Created by Aman on 10/10/21.
//

import UIKit
import FirebaseFirestore
//import Date

class ObjectivesViewController: UIViewController {

    @IBOutlet weak var barChartView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    
    var monthlyData : [OverAllWeekData] = [OverAllWeekData]()
    let firebaseControllerHandle  : FIRController = FIRController()
    private var datePicker: UIDatePicker?
    var chartGraph :BeautifulBarChart?
    var allData : [WeekData] = [WeekData]()
    var seletcedYear = 0
    var selectedMonth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNibs()
        self.getWeeksData()
        self.yearLbl.text = "\(Date().getCurrenYear())"
        self.monthLbl.text = Date().monthAsString()
        self.seletcedYear = Date().getCurrenYear()
        self.selectedMonth = Date().getCurrentMonth()
        self.yearLbl.textColor = AppTheme.defaultBlue
        self.monthLbl.textColor = AppTheme.defaultYellow
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.addChartWithvalues()
    }
    
    override func viewDidLayoutSubviews() {
        self.backView.roundCorners([.topLeft,.topRight], radius: 40)
        self.barChartView.addBottomShadow()
        self.barChartView.cornerRadius = 10
        
    }

    //MARK: register nibs
    
    func registerNibs(){
    
        tblView.register(UINib(nibName: "ObjectiveCell", bundle: nil), forCellReuseIdentifier: "ObjectiveCell")
        tblView.register(UINib(nibName: "ObjectiveHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ObjectiveHeaderView")
        tblView.register(UINib(nibName: "ObjectiveFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ObjectiveFooterView")
        UITableViewHeaderFooterView.appearance().backgroundColor = .clear
        tblView.showsVerticalScrollIndicator = false
        tblView.showsHorizontalScrollIndicator = false
        tblView.backgroundColor = .clear
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    func getWeeksData(){
        DispatchQueue.main.async {
            UIApplication.topViewController()?.showLoader()
        }
        self.barChartView.isHidden = true
        let savedDate = "\(Date().getCurrentMonth())-\(Date().getCurrenYear())"

        firebaseControllerHandle.getWeeksDataForChart(weekNDate: savedDate) { (data) in
            DispatchQueue.main.async {
                UIApplication.topViewController()?.hideLoader()
                self.allData = data
                self.filterDataInWeeks()
                self.addChartWithvalues(data: self.monthlyData)
                self.tblView.reloadData()
            }
            print("data for chart",data)
                
        }
    }
    
    func addChartWithvalues(data: [OverAllWeekData]){
        chartGraph = BeautifulBarChart(frame: barChartView.frame)

        chartGraph?.center = CGPoint(x: self.barChartView.frame.size.width  / 2, y: self.barChartView.frame.size.height  / 2)
        self.barChartView.addSubview(chartGraph!)
        chartGraph?.layoutIfNeeded()
        self.barChartView.isHidden = false
        self.barChartView.layoutIfNeeded()
        self.updateChartValues(data: data)
    }
    
    func updateChartValues(data: [OverAllWeekData]){
        
        var chartData : [DataEntry] = [DataEntry]()
        var indexx = 1
        for weekData in data{
            var count : Double = 0
            for points in weekData.weekData{
                let intPOint = Double(points.points) ?? 0
                count += intPOint
            }
            var heightt = count / 10
            if heightt > 0{
                heightt = heightt / 10
            }
            chartData.append(DataEntry(color: AppTheme.defaultBlue, height: Float(heightt), textValue: "\(Int(count))", title: "\(weekData.week)"))
            indexx += 1
        }
        chartGraph?.updateDataEntries(dataEntries: chartData, animated: true)

    }
    
    
    //MARK: open date picker
    private func setupDatePicker() {
        let picker = datePicker ?? UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        picker.maximumDate = Date()

        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        let size = self.view.frame.size
        picker.frame = CGRect(x: 0.0, y: size.height - 200, width: size.width, height: 200)
        picker.backgroundColor = UIColor.white
        self.datePicker = picker
        self.view.addSubview(self.datePicker!)
    }

    @objc func dueDateChanged(sender:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
//        print("action")
        
        let yearDateformat = DateFormatter()
        yearDateformat.dateFormat = "YYYY"
        
        self.monthLbl.text = dateFormatter.string(from: sender.date)
        self.yearLbl.text = yearDateformat.string(from: sender.date)

        let dateFormatterIntForMonth = DateFormatter()
        dateFormatterIntForMonth.dateFormat = "MM"

        
        
        let dateStr = "\(dateFormatterIntForMonth.string(from: sender.date))-\(self.yearLbl.text ?? "")"
        firebaseControllerHandle.getWeeksDataForChart(weekNDate: dateStr) { (data) in
            DispatchQueue.main.async {
                UIApplication.topViewController()?.hideLoader()
                self.allData = data
                self.filterDataInWeeks()
//                self.updateChartValues(data: data)
                self.tblView.reloadData()
            }
            
        }
    }
    
    
    func filterDataInWeeks(){
        let dateComponents = NSDateComponents()
        dateComponents.year = self.seletcedYear
        dateComponents.month = self.selectedMonth
        let calendar = NSCalendar.current
        let date = calendar.date(from: dateComponents as DateComponents)

        let range = calendar.range(of: .day, in: .month, for: date!)
        print(range?.count as Any)
        
        let totalWeeks = Date().numberOfWeeksInMonth(Date())
        
        print("total weeks",totalWeeks)
        
        
        
        let dt = Date()
        let gregorian = Calendar(identifier: .gregorian)
        var comp = gregorian.dateComponents([.era, .year, .month, .day], from: dt)

        let days = gregorian.range(
            of: .day,
            in: .month,
            for: dt)
        var weeklyData :[OverAllWeekData] = [OverAllWeekData]()
        var weekArray :[WeekData] = [WeekData]()

        
        var finalData : [OverAllWeekData] = [OverAllWeekData]()
        var weekNumber = 0
        
        for i in 1..<(days!.count + 1) {
            comp.day = i
            print("dayyyyy",i)
            let checkDate = gregorian.date(from: comp)
            if self.isTodayMonday(checkDate) {
                if let date = gregorian.date(from: comp) {
                    
                    weekNumber += 1
                    print("week Number ",weekNumber)
                    if weekArray.count > 0{
                        weeklyData.append(OverAllWeekData(weekArray, weekCount: "Week \(weekNumber)"))
                        finalData.insert(contentsOf: weeklyData, at: finalData.count)
                    }
                    weekArray.removeAll()
                    weeklyData.removeAll()
                    let matchingData = self.allData.filter({Calendar.current.isDate($0.timeStamp.dateValue(), inSameDayAs: date) })
                    print(matchingData.count)
                    if matchingData.count > 0{
                        weekArray.insert(contentsOf: matchingData, at: weekArray.count)

//                        weeklyData.append(OverAllWeekData(matchingData,weekCount: "Week \(weekNumber)"))
                    }
                    
                }
            }else{
                if let date = gregorian.date(from: comp) {
                    let matchingData = self.allData.filter({Calendar.current.isDate($0.timeStamp.dateValue(), inSameDayAs: date) })
                    print(matchingData.count)
                    if matchingData.count > 0{
                        weekArray.insert(contentsOf: matchingData, at: weekArray.count)
//                        weeklyData.append(OverAllWeekData(matchingData,weekCount: "Week \(weekNumber)"))
                    }
//                    if i == 1{
//                        weekNumber += 1
//                    }
                    
                    if i == days?.count{
                        weekNumber += 1
                        print("last week ",weekNumber)
                        if weekArray.count > 0{
                            weeklyData.append(OverAllWeekData(weekArray, weekCount: "Week \(weekNumber)"))
                            finalData.insert(contentsOf: weeklyData, at: finalData.count)
                        }

                    }

                }
            }
            
        }
        
        print("now reload")
        DispatchQueue.main.async {
            self.updateChartValues(data: finalData)
            self.monthlyData = finalData
            self.tblView.reloadData()

        }
        
    }
    
    
    func isTodayMonday(_ dt: Date?) -> Bool {
        var isMonday: Bool
        let datef = DateFormatter()
        datef.dateFormat = "EEEE"
        var strDate: String? = nil
        if let dt = dt {
            strDate = datef.string(from: dt)
        }
        if strDate == "Monday" {
            if let dt = dt {
                print("monday date \(dt)")
            }
            isMonday = true
        } else {
            isMonday = false
        }
        return isMonday
    }

    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func filterBtn(_ sender: UIButton) {
        if self.view.subviews.contains(where: { $0 is UIDatePicker }) {
              self.datePicker?.removeFromSuperview()
          } else {
              datePicker = nil
              setupDatePicker()
          }
        
    }
}

extension ObjectivesViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        self.monthlyData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.monthlyData[section].weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectiveCell") as? ObjectiveCell
        let dat = monthlyData[indexPath.section].weekData[indexPath.row]
        cell?.nameLbl.text = dat.name
        cell?.countLbl.text = dat.points
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ObjectiveHeaderView") as? ObjectiveHeaderView
        let data = monthlyData[section]
        let weekText = "\(data.week)"
        customView?.WeekLbl.text = weekText
        customView?.contentView.backgroundColor = .clear
        return customView!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let customView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ObjectiveFooterView") as? ObjectiveFooterView
        customView?.contentView.backgroundColor = .clear
        let data = monthlyData[section].weekData
        var count = 0
        for allData in data{
            let inTCount = Int(allData.points) ?? 0
            count += inTCount
        }
        customView?.totalLbl.text = "The sum of week points \(count)"

        return customView!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}
