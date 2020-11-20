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
    
    let menuLabel2 = UILabel()

    let userDefaults = UserDefaults.standard
    let formatter = DateFormatter()
    var traning = [String]()

    var selectDay = ""
    let today = Date()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var tableView = UITableView()
    var dayMenu = [String]()
    var sectionArray = [String]()
    
    //腕や肩などの部位(keyで扱うため)
    var dayPosition1 = String()
    var dayPosition2 = String()
    var dayPosition3 = String()
    //細かい部位ごとの登録してあるその日のトレーニングメニュー
    var dayPosiMenu1 = [String]()
    var dayPosiMenu2 = [String]()
    var dayPosiMenu3 = [String]()
    
    var tapYear = String()
    var tapMonth = String()
    var tapDay = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.overrideUserInterfaceStyle = .light

        //ナビゲーションバーの詳細
        let naviBarHeight = navigationController?.navigationBar.frame.size.height
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        let tabHeight = tabBarController?.tabBar.frame.size.height
        
        //カレンダーのサイズ
        calView2.frame = CGRect(x: 0, y: naviBarHeight! + statusHeight, width: screenWidth, height: screenHeight/2)
        
        //今日の日付を月日のStringにする
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        //ラベルの詳細
        menuLabel2.layer.frame = CGRect(x: 0, y: calView2.frame.size.height + naviBarHeight! + statusHeight, width: screenWidth, height: 20)
        menuLabel2.text = "日のトレーニングメニュー"
        menuLabel2.textAlignment = .center
        menuLabel2.textColor = .white
        menuLabel2.font = .boldSystemFont(ofSize: 15)
        menuLabel2.backgroundColor = .systemOrange
        self.view.addSubview(menuLabel2)
        
        
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
        
        self.view.addSubview(tableView)

        tableView.frame = CGRect(x: 0, y: statusHeight + naviBarHeight! + screenHeight/2 + 20, width: screenWidth, height: screenHeight - (statusHeight + naviBarHeight! + screenHeight/2 + 20 + tabHeight!))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        if userDefaults.stringArray(forKey: selectDay) != nil{
            dayMenu = userDefaults.stringArray(forKey: selectDay)!
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        if userDefaults.string(forKey: "calName") == nil{
            navigationItem.title = "私の筋トレカレンダー"
        }else{
            navigationItem.title = userDefaults.string(forKey: "calName")
        }
        
        
        if userDefaults.stringArray(forKey: "tapDate") != nil{
        
            let dateArray = userDefaults.stringArray(forKey: "tapDate")
            
            let a = Calendar.current
            let b = a.date(from: DateComponents(year: Int(dateArray![0])!, month: Int(dateArray![1])!, day: Int(dateArray![2])!))
            calView2.select(b)
            
        }
        
        if userDefaults.string(forKey: "day") != nil{
            selectDay = userDefaults.string(forKey: "day")!
            menuLabel2.text = "\(selectDay.dropFirst(5))日のトレーニングメニュー"
        }
        
        //ここから下はdidselect(FScalendar)の時と同じプログラムで、ホームからタブで遷移した際にホームで選択していた日付のメニューを表示させるようにした。
        dayPosition1.removeAll()
        dayPosition2.removeAll()
        dayPosition3.removeAll()
        
        dayPosiMenu1.removeAll()
        dayPosiMenu2.removeAll()
        dayPosiMenu3.removeAll()
        
        dayMenu.removeAll()
        
        //nil判定
        if userDefaults.stringArray(forKey: selectDay) != nil{
            dayMenu = userDefaults.stringArray(forKey: selectDay)!
        }else if userDefaults.stringArray(forKey: selectDay) == nil{
            dayMenu.removeAll()
            userDefaults.set(dayMenu, forKey: selectDay)
        }
        //この関数でメニューの詳細を管理するString配列,tableViewのsectionを作成
        sectionCreate()
        
        switch dayMenu.count {
        case 1:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
        case 2:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)") != nil{
                dayPosiMenu2 = userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)")!
            }
        case 3:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)") != nil{
                dayPosiMenu2 = userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition3)\(selectDay)") != nil{
                dayPosiMenu3 = userDefaults.stringArray(forKey: "\(dayPosition3)\(selectDay)")!
            }
            
        default:
            break
        }
        
        tableView.reloadData()
        calView2.reloadData()

    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //selectedDayに選択された日付を入れる
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: date)
        
        //シュミレーターと実機でselectDayの取り方が変わる
        //コメントアウトしてる方はシュミレータで正しく動く方
        menuLabel2.text = "\(selectDay.dropFirst(5))日のトレーニングメニュー"
        
        //menuLabel2.text = "\(selectDay.dropLast(3))日のトレーニングメニュー"
        
        dayPosition1.removeAll()
        dayPosition2.removeAll()
        dayPosition3.removeAll()
        
        dayPosiMenu1.removeAll()
        dayPosiMenu2.removeAll()
        dayPosiMenu3.removeAll()
        
        dayMenu.removeAll()
        
        //nil判定
        if userDefaults.stringArray(forKey: selectDay) != nil{
            dayMenu = userDefaults.stringArray(forKey: selectDay)!
        }else if userDefaults.stringArray(forKey: selectDay) == nil{
            dayMenu.removeAll()
            userDefaults.set(dayMenu, forKey: selectDay)
        }
        
        //この関数でメニューの詳細を管理するString配列,tableViewのsectionを作成
        sectionCreate()
        
        switch dayMenu.count {
        case 1:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
        case 2:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)") != nil{
                dayPosiMenu2 = userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)")!
            }
        case 3:
            if userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)") != nil{
                dayPosiMenu1 = userDefaults.stringArray(forKey: "\(dayPosition1)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)") != nil{
                dayPosiMenu2 = userDefaults.stringArray(forKey: "\(dayPosition2)\(selectDay)")!
            }
            if userDefaults.stringArray(forKey: "\(dayPosition3)\(selectDay)") != nil{
                dayPosiMenu3 = userDefaults.stringArray(forKey: "\(dayPosition3)\(selectDay)")!
            }
            
        default:
            break
        }
        
        tableView.reloadData()
        calView2.reloadData()

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dayMenu.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0{
            if dayPosiMenu1.count == 0{
                return 1
            }else{
                return dayPosiMenu1.count
            }
        }else if section == 1{
            if dayPosiMenu2.count == 0{
                return 1
            }else{
                return dayPosiMenu2.count
            }
        }else{
            if dayPosiMenu3.count == 0{
                return 1
            }else{
                return dayPosiMenu3.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        sectionCreate()
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        
        if indexPath.section == 0{
            if dayPosiMenu1.count == 0{
                cell.textLabel?.text = "登録なし"
            }else{
                cell.textLabel?.text = dayPosiMenu1[indexPath.row]
            }
        }else if indexPath.section == 1{
            if dayPosiMenu2.count == 0{
                cell.textLabel?.text = "登録なし"
            }else{
                //print(dayPosiMenu2)
                cell.textLabel?.text = dayPosiMenu2[indexPath.row]
            }
        }else if indexPath.section == 2{
            if dayPosiMenu3.count == 0{
                cell.textLabel?.text = "登録なし"
            }else{
                cell.textLabel?.text = dayPosiMenu3[indexPath.row]
            }
        }
        
        return cell
    }
    
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if userDefaults.stringArray(forKey: formatter.string(from: date)) == nil{
            return nil
        }else{
            
            let a = userDefaults.stringArray(forKey: formatter.string(from: date))!
            
            if a.count == 0{
                return nil
            }else if a.count == 1{
                if a.contains("腕"){
                    return udeImg
                }else if a.contains("肩"){
                    return kataImg
                }else if a.contains("胸"){
                    return muneImg
                }else if a.contains("腹"){
                    return haraImg
                }else if a.contains("背"){
                    return senakaImg
                }else if a.contains("脚"){
                    return ashiImg
                }else if a.contains("有"){
                    return yuuImg
                }
            }else if a.count == 2{
                if a.contains("腕"){
                    if a.contains("肩"){
                        return udekata
                    }else if a.contains("胸"){
                        return udemune
                    }else if a.contains("腹"){
                        return udehara
                    }else if a.contains("背"){
                        return udesenaka
                    }else if a.contains("脚"){
                        return udeashi
                    }else if a.contains("有"){
                        return udeyuu
                    }
                }else if a.contains("肩"){
                    if a.contains("胸"){
                        return katamune
                    }else if a.contains("腹"){
                        return katahara
                    }else if a.contains("背"){
                        return katasenaka
                    }else if a.contains("脚"){
                        return kataashi
                    }else if a.contains("有"){
                        return katayuu
                    }
                }else if a.contains("胸"){
                    if a.contains("腹"){
                        return munehara
                    }else if a.contains("背"){
                        return munesenaka
                    }else if a.contains("脚"){
                        return muneashi
                    }else if a.contains("有"){
                        return muneyuu
                    }
                }else if a.contains("腹"){
                    if a.contains("背"){
                        return harasenaka
                    }else if a.contains("脚"){
                        return haraashi
                    }else if a.contains("有"){
                        return harayuu
                    }
                }else if a.contains("背"){
                    if a.contains("脚"){
                        return senakaashi
                    }else if a.contains("有"){
                        return senakayuu
                    }
                }else{
                        return ashiyuu
                    }
            }else if a.count == 3{
                if a.contains("腕") && a.contains("肩"){
                    if a.contains("胸"){
                        return udekatamune
                    }else if a.contains("腹"){
                        return udekatahara
                    }else if a.contains("背"){
                        return udekatasenaka
                    }else if a.contains("脚"){
                        return udekataashi
                    }else if a.contains("有"){
                        return udekatayuu
                    }
                }else if a.contains("腕") && a.contains("胸"){
                    if a.contains("腹"){
                        return udemunehara
                    }else if a.contains("背"){
                        return udemunesenaka
                    }else if a.contains("脚"){
                        return udemuneashi
                    }else if a.contains("有"){
                        return udemuneyuu
                    }
                }else if a.contains("腕") && a.contains("腹"){
                    if a.contains("背"){
                        return udeharasenaka
                    }else if a.contains("脚"){
                        return udeharaashi
                    }else if a.contains("有"){
                        return udeharayuu
                    }
                }else if a.contains("腕") && a.contains("背"){
                    if a.contains("脚"){
                        return udesenakaashi
                    }else if a.contains("有"){
                        return udesenakayuu
                    }
                }else if a.contains("腕") && a.contains("脚"){
                    return udeashiyuu
                }else if a.contains("肩") && a.contains("胸"){
                    if a.contains("腹"){
                        return katamunehara
                    }else if a.contains("背"){
                        return katamunesenaka
                    }else if a.contains("脚"){
                        return katamuneashi
                    }else if a.contains("有"){
                        return katamuneyuu
                    }
                }else if a.contains("肩") && a.contains("腹"){
                    if a.contains("背"){
                        return kataharasenaka
                    }else if a.contains("脚"){
                        return kataharaashi
                    }else if a.contains("有"){
                        return kataharayuu
                    }
                }else if a.contains("肩") && a.contains("背"){
                    if a.contains("脚"){
                        return katasenakaashi
                    }else if a.contains("有"){
                        return katasenakayuu
                    }
                }else if a.contains("肩") && a.contains("脚"){
                    return kataashiyuu
                }else if a.contains("胸") && a.contains("腹"){
                    if a.contains("背"){
                        return muneharasenaka
                    }else if a.contains("脚"){
                        return muneharaashi
                    }else if a.contains("有"){
                        return muneharayuu
                    }
                }else if a.contains("胸") && a.contains("背"){
                    if a.contains("脚"){
                        return munesenakaashi
                    }else{
                        return munesenakayuu
                    }
                }else if a.contains("胸") && a.contains("脚"){
                    return muneashiyuu
                }else if a.contains("腹") && a.contains("背"){
                    if a.contains("脚"){
                        return harasenakaashi
                    }else{
                        return harasenakayuu
                    }
                }else if a.contains("腹") && a.contains("脚"){
                    return haraashiyuu
                }else{
                    return senakaashiyuu
                }
            }
            return UIImage()
        }
    }
    
    @IBAction func jump(_ sender: Any) {
        calView2.currentPage = today

    }
    
    
    //カレンダーの休日判定↓ まあまあ長い
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
    
    
    func sectionCreate(){
        
        let a = dayMenu
        sectionArray.removeAll()
        
        /*セクションを作るのだが、どうしてもセクションの順とその日のトレーニング画像の順と揃えるため
        このような面倒くさい関数にしてしまった。*/
        
        switch a.count {
        case 0:
            sectionArray = [""]
        case 1:
            //print("1だよ")
            if a.contains("腕"){
                sectionArray.append("腕")
                dayPosition1 = "腕"
            }else if a.contains("肩"){
                sectionArray.append("肩")
                dayPosition1 = "肩"
            }else if a.contains("胸"){
                sectionArray.append("胸")
                dayPosition1 = "胸"
            }else if a.contains("腹"){
                sectionArray.append("腹")
                dayPosition1 = "腹"
            }else if a.contains("背"){
                sectionArray.append("背")
                dayPosition1 = "背"
            }else if a.contains("脚"){
                sectionArray.append("脚")
                dayPosition1 = "脚"
            }else if a.contains("有"){
                sectionArray.append("有酸素")
                dayPosition1 = "有"
            }
        case 2:
            //print("2だよ")
            if a.contains("腕"){
                if a.contains("肩"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                }else if a.contains("胸"){
                    sectionArray.append("腕")
                    sectionArray.append("胸")
                    dayPosition1 = "腕"
                    dayPosition2 = "胸"
                }else if a.contains("腹"){
                    sectionArray.append("腕")
                    sectionArray.append("腹")
                    dayPosition1 = "腕"
                    dayPosition2 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("腕")
                    sectionArray.append("背")
                    dayPosition1 = "腕"
                    dayPosition2 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("腕")
                    sectionArray.append("脚")
                    dayPosition1 = "腕"
                    dayPosition2 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腕")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腕"
                    dayPosition2 = "有"
                }
            }else if a.contains("肩"){
                if a.contains("胸"){
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    dayPosition1 = "肩"
                    dayPosition2 = "胸"
                }else if a.contains("腹"){
                    sectionArray.append("肩")
                    sectionArray.append("腹")
                    dayPosition1 = "肩"
                    dayPosition2 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("肩")
                    sectionArray.append("背")
                    dayPosition1 = "肩"
                    dayPosition2 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("肩")
                    sectionArray.append("脚")
                    dayPosition1 = "肩"
                    dayPosition2 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("肩")
                    sectionArray.append("有酸素")
                    dayPosition1 = "肩"
                    dayPosition2 = "有"
                }
            }else if a.contains("胸"){
                if a.contains("腹"){
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    dayPosition1 = "胸"
                    dayPosition2 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("胸")
                    sectionArray.append("背")
                    dayPosition1 = "胸"
                    dayPosition2 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("胸")
                    sectionArray.append("脚")
                    dayPosition1 = "胸"
                    dayPosition2 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("胸")
                    sectionArray.append("有酸素")
                    dayPosition1 = "胸"
                    dayPosition2 = "有"
                }
            }else if a.contains("腹"){
                if a.contains("背"){
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    dayPosition1 = "腹"
                    dayPosition2 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("腹")
                    sectionArray.append("脚")
                    dayPosition1 = "腹"
                    dayPosition2 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腹")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腹"
                    dayPosition2 = "有"
                }
            }else if a.contains("背"){
                if a.contains("脚"){
                    sectionArray.append("背")
                    sectionArray.append("脚")
                    dayPosition1 = "背"
                    dayPosition2 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("背")
                    sectionArray.append("有酸素")
                    dayPosition1 = "背"
                    dayPosition2 = "有"
                }
            }else{
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "脚"
                dayPosition2 = "有"
                }
        case 3:
            //print("3だよ")
            if a.contains("腕") && a.contains("肩"){
                if a.contains("胸"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                    dayPosition3 = "胸"
                }else if a.contains("腹"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    sectionArray.append("腹")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                    dayPosition3 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    sectionArray.append("背")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    sectionArray.append("脚")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腕")
                    sectionArray.append("肩")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腕"
                    dayPosition2 = "肩"
                    dayPosition3 = "有"
                }
            }else if a.contains("腕") && a.contains("胸"){
                if a.contains("腹"){
                    sectionArray.append("腕")
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    dayPosition1 = "腕"
                    dayPosition2 = "胸"
                    dayPosition3 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("腕")
                    sectionArray.append("胸")
                    sectionArray.append("背")
                    dayPosition1 = "腕"
                    dayPosition2 = "胸"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("腕")
                    sectionArray.append("胸")
                    sectionArray.append("脚")
                    dayPosition1 = "腕"
                    dayPosition2 = "胸"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腕")
                    sectionArray.append("胸")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腕"
                    dayPosition2 = "胸"
                    dayPosition3 = "有"
                }
            }else if a.contains("腕") && a.contains("腹"){
                if a.contains("背"){
                    sectionArray.append("腕")
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    dayPosition1 = "腕"
                    dayPosition2 = "腹"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("腕")
                    sectionArray.append("腹")
                    sectionArray.append("脚")
                    dayPosition1 = "腕"
                    dayPosition2 = "腹"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腕")
                    sectionArray.append("腹")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腕"
                    dayPosition2 = "腹"
                    dayPosition3 = "有"
                }
            }else if a.contains("腕") && a.contains("背"){
                if a.contains("脚"){
                    sectionArray.append("腕")
                    sectionArray.append("背")
                    sectionArray.append("脚")
                    dayPosition1 = "腕"
                    dayPosition2 = "背"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("腕")
                    sectionArray.append("背")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腕"
                    dayPosition2 = "背"
                    dayPosition3 = "有"
                }
            }else if a.contains("腕") && a.contains("脚"){
                sectionArray.append("腕")
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "腕"
                dayPosition2 = "脚"
                dayPosition3 = "有"
            }else if a.contains("肩") && a.contains("胸"){
                if a.contains("腹"){
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    dayPosition1 = "肩"
                    dayPosition2 = "胸"
                    dayPosition3 = "腹"
                }else if a.contains("背"){
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    sectionArray.append("背")
                    dayPosition1 = "肩"
                    dayPosition2 = "胸"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    sectionArray.append("脚")
                    dayPosition1 = "肩"
                    dayPosition2 = "胸"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("肩")
                    sectionArray.append("胸")
                    sectionArray.append("有酸素")
                    dayPosition1 = "肩"
                    dayPosition2 = "胸"
                    dayPosition3 = "有"
                }
            }else if a.contains("肩") && a.contains("腹"){
                if a.contains("背"){
                    sectionArray.append("肩")
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    dayPosition1 = "肩"
                    dayPosition2 = "腹"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("肩")
                    sectionArray.append("腹")
                    sectionArray.append("脚")
                    dayPosition1 = "肩"
                    dayPosition2 = "腹"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("肩")
                    sectionArray.append("腹")
                    sectionArray.append("有酸素")
                    dayPosition1 = "肩"
                    dayPosition2 = "腹"
                    dayPosition3 = "有"
                }
            }else if a.contains("肩") && a.contains("背"){
                if a.contains("脚"){
                    sectionArray.append("肩")
                    sectionArray.append("背")
                    sectionArray.append("脚")
                    dayPosition1 = "肩"
                    dayPosition2 = "背"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("肩")
                    sectionArray.append("背")
                    sectionArray.append("有酸素")
                    dayPosition1 = "肩"
                    dayPosition2 = "背"
                    dayPosition3 = "有"
                }
            }else if a.contains("肩") && a.contains("脚"){
                sectionArray.append("肩")
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "肩"
                dayPosition2 = "脚"
                dayPosition3 = "有"
            }else if a.contains("胸") && a.contains("腹"){
                if a.contains("背"){
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    dayPosition1 = "胸"
                    dayPosition2 = "腹"
                    dayPosition3 = "背"
                }else if a.contains("脚"){
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    sectionArray.append("脚")
                    dayPosition1 = "胸"
                    dayPosition2 = "腹"
                    dayPosition3 = "脚"
                }else if a.contains("有"){
                    sectionArray.append("胸")
                    sectionArray.append("腹")
                    sectionArray.append("有酸素")
                    dayPosition1 = "胸"
                    dayPosition2 = "腹"
                    dayPosition3 = "有"
                }
            }else if a.contains("胸") && a.contains("背"){
                if a.contains("脚"){
                    sectionArray.append("胸")
                    sectionArray.append("背")
                    sectionArray.append("脚")
                    dayPosition1 = "胸"
                    dayPosition2 = "背"
                    dayPosition3 = "脚"
                }else{
                    sectionArray.append("胸")
                    sectionArray.append("背")
                    sectionArray.append("有酸素")
                    dayPosition1 = "胸"
                    dayPosition2 = "背"
                    dayPosition3 = "有"
                }
            }else if a.contains("胸") && a.contains("脚"){
                sectionArray.append("胸")
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "胸"
                dayPosition2 = "脚"
                dayPosition3 = "有"
            }else if a.contains("腹") && a.contains("背"){
                if a.contains("脚"){
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    sectionArray.append("脚")
                    dayPosition1 = "腹"
                    dayPosition2 = "背"
                    dayPosition3 = "脚"
                }else{
                    sectionArray.append("腹")
                    sectionArray.append("背")
                    sectionArray.append("有酸素")
                    dayPosition1 = "腹"
                    dayPosition2 = "背"
                    dayPosition3 = "有"
                }
            }else if a.contains("腹") && a.contains("脚"){
                sectionArray.append("腹")
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "腹"
                dayPosition2 = "脚"
                dayPosition3 = "有"
            }else{
                sectionArray.append("背")
                sectionArray.append("脚")
                sectionArray.append("有酸素")
                dayPosition1 = "背"
                dayPosition2 = "脚"
                dayPosition3 = "有"
                }
        default:
            break
        }
    }//関数のとじかっこ
    
}
