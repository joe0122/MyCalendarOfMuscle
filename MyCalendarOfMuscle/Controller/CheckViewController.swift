//
//  CheckViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/23.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class CheckViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dayLabel: UILabel!
    
    let userDefaults = UserDefaults.standard
    let formatter = DateFormatter()
    var traning = [String]()

    var selectDay = ""
    let today = Date()
    
    var dayMenu = [String]()
    var sectionArray = [String]()
    
    var tapYear = String()
    var tapMonth = String()
    var tapDay = String()
    
    var menuData = MenuData()
    let searchModel = SearchModel()
    let calendarJP = CalendarTextJP()
    let calendarHoliday = CalendarHoliDayJP()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light
        
        //今日の日付を月日のStringにする
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: today)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendarJP.calendarTextJP(calendar: calendar)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if userDefaults.stringArray(forKey: selectDay) != nil{
            dayMenu = userDefaults.stringArray(forKey: selectDay)!
        }
        
        if let data = userDefaults.value(forKey: selectDay) as? Data{
            let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            menuData = decodeData!

        }
        
        tableView.reloadData()
        calendar.reloadData()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        if userDefaults.string(forKey: "calName") == nil{
            navigationItem.title = "私の筋トレカレンダー"
        }else{
            navigationItem.title = userDefaults.string(forKey: "calName")
        }
        
        dayLabel.text = "\(selectDay)日のトレーニングメニュー"
        calendar.reloadData()
        tableView.reloadData()

    }
    
    //↓ FScalendarについて
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return calendarHoliday.calendar(calendar, appearance: appearance, titleDefaultColorFor: date)

    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //selectedDayに選択された日付を入れる
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: date)
        
        if let data = userDefaults.value(forKey: selectDay) as? Data{
            let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            menuData = decodeData!
        }
        dayLabel.text = "\(selectDay)日のトレーニングメニュー"
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        var image:UIImage?
        
        if let data = userDefaults.value(forKey: "\(formatter.string(from: date))") as? Data{
            let imageData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            image = searchModel.searchPosition(menuData: imageData!)
        }
        return image
    }
    
    //↓ tableViewについて
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuData.position.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuData.position[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0{
            if menuData.menu1.count == 0{
                return 0
            }else if menuData.menu1.count == 1{
                return 1
            }else{
                return menuData.menu1.count - 1
            }
        }else if section == 1{
            if menuData.menu2.count == 0{
                return 0
            }else if menuData.menu2.count == 1{
                return 1
            }else{
                return menuData.menu2.count - 1
            }
        }else{
            if menuData.menu3.count == 0{
                return 0
            }else if menuData.menu3.count == 1{
                return 1
            }else{
                return menuData.menu3.count - 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        
        if indexPath.section == 0{
            if menuData.menu1.count == 1{
                cell.textLabel?.text = "登録なし"
            }else{
                cell.textLabel?.text = menuData.menu1[indexPath.row + 1]
            }
        }else if indexPath.section == 1{
            if menuData.menu2.count == 1{
                cell.textLabel?.text = "登録なし"
            }else{
                cell.textLabel?.text = menuData.menu2[indexPath.row + 1]
            }
        }else if indexPath.section == 2{
            if menuData.menu3.count == 1{
                cell.textLabel?.text = "登録なし"
            }else{
                cell.textLabel?.text = menuData.menu3[indexPath.row + 1]
            }
        }
        
        return cell
    }
    
    
    @IBAction func jump(_ sender: Any) {
        calendar.currentPage = today
    }

}
