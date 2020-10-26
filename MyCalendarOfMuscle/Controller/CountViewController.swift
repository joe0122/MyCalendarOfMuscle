//
//  CountViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/19.
//

import UIKit
import Charts

class CountViewController: UIViewController {
        
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var minusB: UIButton!
    @IBOutlet weak var plusB: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    
    let formatter = DateFormatter()
    var today = String()
    
    var thisMonth = String()
    var thisYear = String()
    
    var year = Int()
    var month = Int()

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var udeCount = Double()
    var kataCount = Double()
    var muneCount = Double()
    var haraCount = Double()
    var senakaCount = Double()
    var ashiCount = Double()
    var yuuCount = Double()
    
    var position = [String]()
    var posiCount = [Double]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ライトモードのみ、グラフが見づらいため
        self.overrideUserInterfaceStyle = .light
        
        
        minusB.frame = CGRect(x: 15, y: screenHeight/5, width: 30, height: 40)
        plusB.frame = CGRect(x: screenWidth - 45, y: screenHeight/5, width: 30, height: 40)

        monthLabel.frame = CGRect(x: screenWidth/6, y: screenHeight/5, width: screenWidth * 2/3, height: 40)
        monthLabel.textAlignment = .center
        
        pieChartView.frame = CGRect(x: 0, y: screenHeight/4, width: screenWidth, height: 400)

        formatter.dateStyle = .short
        formatter.timeStyle = .none
        today = formatter.string(from: Date())
        thisMonth = String(today.split(separator: "/")[1])
        thisYear = String(today.split(separator: "/")[0])
        
        month = Int(thisMonth)!
        year = Int(thisYear)!
        print(month)
        print(thisYear)
        monthLabel.text = "\(thisYear)年\(thisMonth)月"
        
        traningCheck(month: month, year: year)
        
        position = ["腕","肩","胸","腹","背","脚","有酸素"]
        posiCount = [udeCount,kataCount,muneCount,haraCount,senakaCount,ashiCount,yuuCount]
        
        setPie(position: position, count: posiCount)

        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationItem.title = "戻る"

    }
    
    @IBAction func minus(_ sender: Any) {
        
        if month == 1{
            month = 12
            year -= 1
        }else{
            month -= 1
        }
        monthLabel.text = "\(year)年\(month)月"
        traningCheck(month: month, year: year)
        setPie(position: position, count: posiCount)

    }
    
    @IBAction func plus(_ sender: Any) {
        if month == 12{
            month = 1
            year += 1
        }else{
            month += 1
        }
        monthLabel.text = "\(year)年\(month)月"
        traningCheck(month: month, year: year)
        setPie(position: position, count: posiCount)
    }
    
    func traningCheck(month: Int,year: Int){
        
        udeCount = 0
        kataCount = 0
        muneCount = 0
        haraCount = 0
        senakaCount = 0
        ashiCount = 0
        yuuCount = 0
        
        var traning = [String]()

        
        for i in 1...31{
            
            if  month < 10{
                if i < 10{
                    if UserDefaults.standard.stringArray(forKey: "\(year)/0\(month)/0\(i)") != nil{
                        traning = UserDefaults.standard.stringArray(forKey: "\(year)/0\(month)/0\(i)")!
                    }else{
                        traning = [""]
                    }
                }else{
                    if UserDefaults.standard.stringArray(forKey: "\(year)/0\(month)/\(i)") != nil{
                        traning = UserDefaults.standard.stringArray(forKey: "\(year)/0\(month)/\(i)")!
                    }else{
                        traning = [""]
                    }
                }
            }else{
                if i < 10{
                    if UserDefaults.standard.stringArray(forKey: "\(year)/\(month)/0\(i)") != nil{
                        traning = UserDefaults.standard.stringArray(forKey: "\(year)/\(month)/0\(i)")!
                    }else{
                        traning = [""]
                    }
                }else{
                    if UserDefaults.standard.stringArray(forKey: "\(year)/\(month)/\(i)") != nil{
                        traning = UserDefaults.standard.stringArray(forKey: "\(year)/\(month)/\(i)")!
                    }else{
                        traning = [""]
                        }
                    }
                }
            
                switch traning.count {
                case 1:
                    if traning[0] == "腕"{
                        udeCount += 1
                    }else if traning[0] == "肩"{
                        kataCount += 1
                    }else if traning[0] == "肩"{
                        kataCount += 1
                    }else if traning[0] == "胸"{
                        muneCount += 1
                    }else if traning[0] == "腹"{
                        haraCount += 1
                    }else if traning[0] == "背"{
                        senakaCount += 1
                    }else if traning[0] == "脚"{
                        ashiCount += 1
                    }else if traning[0] == "有"{
                        yuuCount += 1
                    }
                case 2:
                    for j in 0...1{
                        if traning[j] == "腕"{
                            udeCount += 1
                        }else if traning[j] == "肩"{
                            kataCount += 1
                        }else if traning[j] == "肩"{
                            kataCount += 1
                        }else if traning[j] == "胸"{
                            muneCount += 1
                        }else if traning[j] == "腹"{
                            haraCount += 1
                        }else if traning[j] == "背"{
                            senakaCount += 1
                        }else if traning[j] == "脚"{
                            ashiCount += 1
                        }else if traning[j] == "有"{
                            yuuCount += 1
                        }
                    }
                case 3:
                    for j in 0...2{
                        if traning[j] == "腕"{
                            udeCount += 1
                        }else if traning[j] == "肩"{
                            kataCount += 1
                        }else if traning[j] == "肩"{
                            kataCount += 1
                        }else if traning[j] == "胸"{
                            muneCount += 1
                        }else if traning[j] == "腹"{
                            haraCount += 1
                        }else if traning[j] == "背"{
                            senakaCount += 1
                        }else if traning[j] == "脚"{
                            ashiCount += 1
                        }else if traning[j] == "有"{
                            yuuCount += 1
                        }
                    }
                    
                default:
                    break
                }

        }
        
        posiCount = [udeCount,kataCount,muneCount,haraCount,senakaCount,ashiCount,yuuCount]
        
    }
    
    func setPie(position: [String], count: [Double]){
        
        
        pieChartView.removeFromSuperview()

        pieChartView.rotationEnabled = false
        pieChartView.centerText = "腕:\(Int(udeCount))回\n肩:\(Int(kataCount))回\n胸:\(Int(muneCount))回\n腹:\(Int(haraCount))回\n背中:\(Int(senakaCount))回\n脚:\(Int(ashiCount))回\n有酸素:\(Int(yuuCount))回\n合計:\(Int(udeCount + kataCount + muneCount + haraCount + senakaCount + ashiCount + yuuCount))回"
        
        pieChartView.legend.font = UIFont(name: "AmericanTypewriter-Bold", size: 13)!
        pieChartView.legend.formSize = 15
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.horizontalAlignment = .center
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.multiplier = 1.0
        pieChartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.usePercentValuesEnabled = true
        
        var dataEntries = [PieChartDataEntry]()
        
        var dataEntry = PieChartDataEntry()

        for i in 0..<position.count{
            if count[i] != 0{
                dataEntry = PieChartDataEntry(value: count[i], label: position[i])
                dataEntries.append(dataEntry)
            }else{
                dataEntry = PieChartDataEntry(value: 0, label: "")
                dataEntries.append(dataEntry)
            }
            
        }
        
        let colors = [
            UIColor.systemRed,
            UIColor.systemGreen,
            UIColor.systemYellow,
            UIColor.systemBlue,
            UIColor.systemPurple,
            UIColor.systemTeal,
            UIColor.systemOrange
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "データ項目")
        let data = PieChartData(dataSet: dataSet)
        
        dataSet.valueFont = .boldSystemFont(ofSize: 20)
        dataSet.entryLabelFont = .boldSystemFont(ofSize: 30)
        dataSet.colors = colors
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        pieChartView.data = data

        view.addSubview(pieChartView)
    }
    
}
