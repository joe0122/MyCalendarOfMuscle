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
    
    
    @IBOutlet weak var calView2: FSCalendar!
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light

        //ナビゲーションバーの詳細
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        //今日の日付を月日のStringにする
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: today)
        
        calView2.dataSource = self
        calView2.delegate = self
        
        //曜日のラベルを日本語表記に
        calView2.calendarWeekdayView.weekdayLabels[0].text = "日"
        calView2.calendarWeekdayView.weekdayLabels[1].text = "月"
        calView2.calendarWeekdayView.weekdayLabels[2].text = "火"
        calView2.calendarWeekdayView.weekdayLabels[3].text = "水"
        calView2.calendarWeekdayView.weekdayLabels[4].text = "木"
        calView2.calendarWeekdayView.weekdayLabels[5].text = "金"
        calView2.calendarWeekdayView.weekdayLabels[6].text = "土"
        //曜日のラベルの色を変更(平日を黒、土曜を青、日曜を赤)
        calView2.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        calView2.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
        calView2.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
        calView2.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
        calView2.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
        calView2.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
        calView2.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if userDefaults.stringArray(forKey: selectDay) != nil{
            dayMenu = userDefaults.stringArray(forKey: selectDay)!
        }
        
        if let data = userDefaults.value(forKey: selectDay) as? Data{
            let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            menuData = decodeData!
            print(menuData.position)

        }
        
        print(menuData.position)
        tableView.reloadData()
        calView2.reloadData()
                
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
        calView2.reloadData()
        tableView.reloadData()

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
                //print(dayPosiMenu2)
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
    
    @IBAction func jump(_ sender: Any) {
        calView2.currentPage = today
    }
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }

        return nil
    }
}
