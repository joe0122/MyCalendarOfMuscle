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
    
    let userDefaults = UserDefaults.standard
    
    var menuData = MenuData()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ライトモードのみ、グラフが見づらいため
        self.overrideUserInterfaceStyle = .light

        formatter.dateStyle = .short
        formatter.timeStyle = .none
        today = formatter.string(from: Date())
        thisMonth = String(today.split(separator: "/")[1])
        thisYear = String(today.split(separator: "/")[0])
        
        month = Int(thisMonth)!
        year = Int(thisYear)!
        monthLabel.text = "\(thisYear)年\(thisMonth)月"
                
        position = ["腕","肩","胸","腹","背","脚","有酸素"]
        posiCount = [udeCount,kataCount,muneCount,haraCount,senakaCount,ashiCount,yuuCount]
        
        traningCheck(month: month, year: year)
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
        
        for i in 1...31{
            
            if i<10{
                if let data = userDefaults.value(forKey: "\(year)/\(month)/0\(i)") as? Data{
                    let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
                    menuData = decodeData!
            }else{
                if let data = userDefaults.value(forKey: "\(year)/\(month)/\(i)") as? Data{
                    let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
                    menuData = decodeData!
            }
                switch menuData.position.count {
                case 1:
                    if menuData.position[0] == "腕"{
                        udeCount += 1
                    }else if menuData.position[0] == "肩"{
                        kataCount += 1
                    }else if menuData.position[0] == "胸"{
                        muneCount += 1
                    }else if menuData.position[0] == "腹"{
                        haraCount += 1
                    }else if menuData.position[0] == "背"{
                        senakaCount += 1
                    }else if menuData.position[0] == "脚"{
                        ashiCount += 1
                    }else if menuData.position[0] == "有"{
                        yuuCount += 1
                    }
                case 2:
                    for j in 0..<2{
                        if menuData.position[j] == "腕"{
                            udeCount += 1
                        }else if menuData.position[j] == "肩"{
                            kataCount += 1
                        }else if menuData.position[j] == "胸"{
                            muneCount += 1
                        }else if menuData.position[j] == "腹"{
                            haraCount += 1
                        }else if menuData.position[j] == "背"{
                            senakaCount += 1
                        }else if menuData.position[j] == "脚"{
                            ashiCount += 1
                        }else if menuData.position[j] == "有"{
                            yuuCount += 1
                        }
                    }
                case 3:
                    for k in 0..<3{
                        if menuData.position[k] == "腕"{
                            udeCount += 1
                        }else if menuData.position[k] == "肩"{
                            kataCount += 1
                        }else if menuData.position[k] == "胸"{
                            muneCount += 1
                        }else if menuData.position[k] == "腹"{
                            haraCount += 1
                        }else if menuData.position[k] == "背"{
                            senakaCount += 1
                        }else if menuData.position[k] == "脚"{
                            ashiCount += 1
                        }else if menuData.position[k] == "有"{
                            yuuCount += 1
                        }
                    }
                default:
                    break
                }
                menuData = MenuData()
            }
        }
    }
        posiCount = [udeCount,kataCount,muneCount,haraCount,senakaCount,ashiCount,yuuCount]
}
    func setPie(position: [String], count: [Double]){
        
        pieChartView.reloadInputViews()

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
    }
    
}
