//
//  ViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/19.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
//import GoogleMobileAds

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance /*GADBannerViewDelegate*/{
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var ude: UIButton!
    @IBOutlet weak var kata: UIButton!
    @IBOutlet weak var mune: UIButton!
    @IBOutlet weak var hara: UIButton!
    @IBOutlet weak var senaka: UIButton!
    @IBOutlet weak var ashi: UIButton!
    @IBOutlet weak var yuu: UIButton!
    
    let formatter = DateFormatter()
    //userdefaultsに保存するために一旦格納する場所
    var traning = [String]()

    //日付をStringにした場合の入れ物
    var selectDay = ""
    let today = Date()

    let userDefaults = UserDefaults.standard
    
    var selectArray = [String]()
    
    var menuData = MenuData()
    
    let searchModel = SearchModel()
    
    let calendarTextJP = CalendarTextJP()
    let calendarHoliday = CalendarHoliDayJP()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ライトモードのみにする
        self.overrideUserInterfaceStyle = .light
        
        //ボタンを丸にして影をつける
        ButtuonShadow(position: ude)
        ButtuonShadow(position: kata)
        ButtuonShadow(position: mune)
        ButtuonShadow(position: hara)
        ButtuonShadow(position: senaka)
        ButtuonShadow(position: ashi)
        ButtuonShadow(position: yuu)
        
        //今日の日付を月日のStringにする
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: today)
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendarTextJP.calendarTextJP(calendar: calendar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if userDefaults.string(forKey: "calName") == nil{
            navigationItem.title = "私の筋トレカレンダー"
        }else{
            navigationItem.title = userDefaults.string(forKey: "calName")
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //selectedDayに選択された日付を入れる
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: date)
    }
    
    @IBAction func ude(_ sender: Any) {
        buttonPush(position: "腕")
    }
    @IBAction func kata(_ sender: Any) {
        buttonPush(position: "肩")
    }
    @IBAction func mune(_ sender: Any) {
        buttonPush(position: "胸")
    }
    @IBAction func hara(_ sender: Any) {
        buttonPush(position: "腹")
    }
    @IBAction func senaka(_ sender: Any) {
        buttonPush(position: "背")
    }
    @IBAction func ashi(_ sender: Any) {
        buttonPush(position: "脚")
    }
    @IBAction func yuu(_ sender: Any) {
        buttonPush(position: "有")
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日や土日の色を変更
        return calendarHoliday.calendar(calendar, appearance: appearance, titleDefaultColorFor: date)

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
    
    
    func saveDB(){
        userDefaults.set(try? PropertyListEncoder().encode(menuData), forKey: selectDay)
    }
    
    
    func buttonPush(position:String){
        
        let addTable = self.storyboard?.instantiateViewController(withIdentifier: "addTable") as! AddViewController
        addTable.selectDay = selectDay
        addTable.pushMenu = position
        
        menuData = MenuData()
        
        //Data型をuserdefaultsに入れているので、デコードして型を元に戻す。
        if let data = userDefaults.value(forKey: "\(selectDay)") as? Data{
            let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            menuData = decodeData!
        }
        
        //その日付のトレーニングの数
        switch menuData.position.count {
        case 0:
            menuData.position.append(position)
            menuData.menu1.append(position)
            present(addTable, animated: true, completion: nil)
        case 1:
            //その日付のトレーニングにタップしたトレーニングが既にあるか
            if menuData.position.contains(position){
                hensyuOrTorikeshi(position: position)
            }else{
                menuData.position.append(position)
                menuData.menu2.append(position)
                present(addTable, animated: true, completion: nil)
            }
        case 2:
            if menuData.position.contains(position){
                hensyuOrTorikeshi(position: position)
            }else{
                menuData.position.append(position)
                menuData.menu3.append(position)
                present(addTable, animated: true, completion: nil)
            }
        case 3:
            if menuData.position.contains(position){
                hensyuOrTorikeshi(position: position)
            }else{
                Alert()
            }
        default:
            break
        }
        saveDB()
        addTable.menuData = menuData
        calendar.reloadData()
        }
    
    
    func Alert(){
        let alert = UIAlertController(title: "これ以上は選択できません！", message: "1日3つまでの登録となります", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func ButtuonShadow(position: UIButton){
        //ボタンに影をつけて丸にする
        position.layer.cornerRadius = position.bounds.width/2
        position.layer.shadowColor = UIColor.black.cgColor
        position.layer.shadowRadius = 3
        position.layer.shadowOffset = CGSize(width: 2, height: 2)
        position.layer.shadowOpacity = 0.5
    }
    
    
    func hensyuOrTorikeshi(position:String){
        
        let addTable = self.storyboard?.instantiateViewController(withIdentifier: "addTable") as! AddViewController
        
        let alert = UIAlertController(title: "\(position)トレを取消 / \(position)トレを編集", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action1 = UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: {
            (action: UIAlertAction!) in
            self.menuData.position.remove(at: self.menuData.position.firstIndex(of: position)!)
            
            if self.menuData.menu1.first == position{
                self.menuData.menu1.removeAll()
            }else if self.menuData.menu2.first == position{
                self.menuData.menu2.removeAll()
            }else{
                self.menuData.menu3.removeAll()
            }
            
            self.saveDB()
            self.calendar.reloadData()
        })
        
        let action2 = UIAlertAction(title: "編集", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            addTable.selectDay = self.selectDay
            addTable.pushMenu = position
            self.present(addTable, animated: true, completion: nil)
        })
        
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backNow(_ sender: Any) {
        //今日の日付にジャンプ
        calendar.currentPage = today
    }
}


//カレンダーで使う画像をリサイズするためのエクステンション
extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}




