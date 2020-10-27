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
    
    
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var cal: FSCalendar!
    
    //それぞれのボタンのインスタンス
    let ude = UIButton()
    let kata = UIButton()
    let hara = UIButton()
    let mune = UIButton()
    let senaka = UIButton()
    let ashi = UIButton()
    let yuu = UIButton()

    //カレンダーとボタンの部分の区切りのため
    let menuLabel = UILabel()
    
    let formatter = DateFormatter()
    //userdefaultsに保存するために一旦格納する場所
    var traning = [String]()

    //日付をStringにした場合の入れ物
    var selectDay = ""
    let today = Date()

    let userDefaults = UserDefaults.standard
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
            
    override func viewDidLoad() {
        super.viewDidLoad()
        //ライトモードのみにする
        self.overrideUserInterfaceStyle = .light
        
        //ナビゲーションバーの詳細
        let naviBarHeight = navigationController?.navigationBar.frame.size.height
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        
        //カレンダーのサイズ
        calView.frame = CGRect(x: 0, y: naviBarHeight! + statusHeight, width: screenWidth, height: screenHeight/2)
        
        //上段４つのボタンのサイズと場所
        ude.frame = CGRect(x: screenWidth/6 - screenWidth/10, y: screenHeight * 2/3, width: screenWidth/6, height: screenWidth/6)
        kata.frame = CGRect(x: screenWidth/10 * 3, y: screenHeight * 2/3, width: screenWidth/6, height: screenWidth/6)
        mune.frame = CGRect(x: screenWidth/2 + screenWidth/22, y: screenHeight * 2/3, width: screenWidth/6, height: screenWidth/6)
        hara.frame = CGRect(x: screenWidth - (screenWidth/6 + screenWidth/17), y: screenHeight * 2/3, width: screenWidth/6, height: screenWidth/6)
        
        //下段３つのボタンのサイズと場所
        senaka.frame = CGRect(x: screenWidth/6, y: screenHeight * 3.1/4, width: screenWidth/6, height: screenWidth/6)
        ashi.frame = CGRect(x: screenWidth/2 - screenWidth/12, y: screenHeight * 3.1/4, width: screenWidth/6, height: screenWidth/6)
        yuu.frame = CGRect(x: screenWidth - screenWidth/6 * 2, y: screenHeight * 3.1/4, width: screenWidth/6, height: screenWidth/6)
        
        ude.backgroundColor = .systemRed
        kata.backgroundColor = .systemGreen
        hara.backgroundColor = .systemBlue
        mune.backgroundColor = .systemYellow
        senaka.backgroundColor = .systemPurple
        ashi.backgroundColor = .systemTeal
        yuu.backgroundColor = .systemOrange
        
        ude.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        kata.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        hara.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        mune.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        senaka.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        ashi.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 22)
        yuu.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 48)

        ude.addTarget(self, action: #selector(udeAction(_:)), for: UIControl.Event.touchUpInside)
        kata.addTarget(self, action: #selector(kataAction(_:)), for: UIControl.Event.touchUpInside)
        hara.addTarget(self, action: #selector(haraAction(_:)), for: UIControl.Event.touchUpInside)
        mune.addTarget(self, action: #selector(muneAction(_:)), for: UIControl.Event.touchUpInside)
        senaka.addTarget(self, action: #selector(senakaAction(_:)), for: UIControl.Event.touchUpInside)
        ashi.addTarget(self, action: #selector(ashiAction(_:)), for: UIControl.Event.touchUpInside)
        yuu.addTarget(self, action: #selector(yuuAction(_:)), for: UIControl.Event.touchUpInside)
        
        //ボタンを丸にして影をつける
        ButtuonShadow(position: ude)
        ButtuonShadow(position: kata)
        ButtuonShadow(position: mune)
        ButtuonShadow(position: hara)
        ButtuonShadow(position: senaka)
        ButtuonShadow(position: ashi)
        ButtuonShadow(position: yuu)

        ude.setTitle("腕", for: .normal)
        kata.setTitle("肩", for: .normal)
        mune.setTitle("胸", for: .normal)
        hara.setTitle("腹", for: .normal)
        senaka.setTitle("背", for: .normal)
        ashi.setTitle("脚", for: .normal)
        yuu.setTitle("🏃‍♂️", for: .normal)

        
        self.view.addSubview(ude)
        self.view.addSubview(kata)
        self.view.addSubview(hara)
        self.view.addSubview(mune)
        self.view.addSubview(ashi)
        self.view.addSubview(senaka)
        self.view.addSubview(yuu)
        
        //今日の日付を月日のStringにする
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        selectDay = formatter.string(from: today)
        //print(selectDay)
        
        //今日の日付のデータがなければ保存する
        if userDefaults.stringArray(forKey: selectDay) == nil{
            saveDB(SD: selectDay)
        }
        
        
        //ラベルの詳細
        menuLabel.layer.frame = CGRect(x: 0, y: calView.frame.size.height + naviBarHeight! + statusHeight, width: screenWidth, height: 20)
        menuLabel.text = "トレーニングメニュー"
        menuLabel.textAlignment = .center
        menuLabel.textColor = .white
        menuLabel.font = .boldSystemFont(ofSize: 15)
        menuLabel.backgroundColor = .systemOrange
        self.view.addSubview(menuLabel)
        
        
        cal.dataSource = self
        cal.delegate = self
        
        //曜日のラベルを日本語表記に
        cal.calendarWeekdayView.weekdayLabels[0].text = "日"
        cal.calendarWeekdayView.weekdayLabels[1].text = "月"
        cal.calendarWeekdayView.weekdayLabels[2].text = "火"
        cal.calendarWeekdayView.weekdayLabels[3].text = "水"
        cal.calendarWeekdayView.weekdayLabels[4].text = "木"
        cal.calendarWeekdayView.weekdayLabels[5].text = "金"
        cal.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        //曜日のラベルの色を変更(平日を黒、土曜を青、日曜を赤)
        cal.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
        cal.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
        cal.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
        cal.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
        cal.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
        cal.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
        cal.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
        
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
        //print(selectDay)
        
        //日付を値渡しする
        let checkVC = self.storyboard?.instantiateViewController(withIdentifier: "checkVC") as! CheckViewController
        checkVC.selectDay = selectDay
        
    }
    
    
    @objc func udeAction(_ sender: Any) {buttonPush(position: "腕")}
    @objc func kataAction(_ sender: Any) {buttonPush(position: "肩")}
    @objc func haraAction(_ sender: Any) {buttonPush(position: "腹")}
    @objc func muneAction(_ sender: Any) {buttonPush(position: "胸")}
    @objc func senakaAction(_ sender: Any) {buttonPush(position: "背")}
    @objc func ashiAction(_ sender: Any) {buttonPush(position: "脚")}
    @objc func yuuAction(_ sender: Any) {buttonPush(position: "有")}
    
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if userDefaults.stringArray(forKey: formatter.string(from: date)) == nil{
            return nil
        }else{
            
            let a = userDefaults.stringArray(forKey: formatter.string(from: date))!
            
            //トレーニングがない時
            if a.count == 0{
                return nil
            }else if a.count == 1{
                //トレーニングが１つの時
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
                //トレーニングが２つの時
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
                //トレーニングが３つの時
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
    
    
    func saveDB(SD:String){
        userDefaults.set(traning, forKey: SD)
        traning.removeAll()
    }
    
    
    func buttonPush(position:String){
        
        let addTable = self.storyboard?.instantiateViewController(withIdentifier: "addTable") as! AddViewController
        
        addTable.pushMenu = position
        
        if userDefaults.stringArray(forKey: selectDay) == nil{
            userDefaults.set(traning, forKey: selectDay)
        }
        
        traning = userDefaults.stringArray(forKey: selectDay)!
        //まだ選択した日にトレーニングが追加できる場合
        if traning.count <= 2{
            //選択した部位が含まれている
            if traning.contains(position){
                
                //編集するか取り消すかのアラート
                let alert = UIAlertController(title: "\(position)トレを取消 / \(position)トレを編集", message: "", preferredStyle: UIAlertController.Style.alert)
                
                //取り消しならデータからトレーニングを削除
                let action1 = UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: {
                    (action: UIAlertAction!) in
                    var a = self.userDefaults.stringArray(forKey: self.selectDay)!
                    a.remove(at: a.firstIndex(of: position)!)
                    //print(a)
                    self.userDefaults.set(a, forKey: self.selectDay)
                    self.cal.reloadData()
                })
                //編集なら編集画面へ遷移
                let action2 = UIAlertAction(title: "編集", style: UIAlertAction.Style.default, handler: {
                    (action: UIAlertAction!) in
                    addTable.selectDay = self.selectDay
                    self.present(addTable, animated: true, completion: nil)
                })
                
                alert.addAction(action1)
                alert.addAction(action2)
                present(alert, animated: true, completion: nil)
                saveDB(SD: selectDay)
                
            }else{
                //選択した部位が含まれていない
                traning.append(position)
                saveDB(SD: selectDay)
    
                addTable.selectDay = selectDay
                self.present(addTable, animated: true, completion: nil)
            }
            
        }else if traning.count == 3 && traning.contains(position){
            //選択した日付のトレーニングが上限かつ、選択したトレーニングが含まれている
            
            let alert = UIAlertController(title: "\(position)トレを取消 / \(position)トレを編集", message: "", preferredStyle: UIAlertController.Style.alert)
            
            let action1 = UIAlertAction(title: "取消", style: UIAlertAction.Style.destructive, handler: {
                (action: UIAlertAction!) in
                var a = self.userDefaults.stringArray(forKey: self.selectDay)!
                a.remove(at: a.firstIndex(of: position)!)
                //print(a)
                self.userDefaults.set(a, forKey: self.selectDay)
                self.cal.reloadData()
            })
            
            let action2 = UIAlertAction(title: "編集", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) in
                addTable.selectDay = self.selectDay
                self.present(addTable, animated: true, completion: nil)
            })
            
            alert.addAction(action1)
            alert.addAction(action2)
            present(alert, animated: true, completion: nil)
            
        }else{
            //３つ以上は登録させていないのでアラート
            Alert()
        }
        
        cal.reloadData()
        
    }
    
    @IBAction func backNow(_ sender: Any) {
        //今日の日付にジャンプ
        cal.currentPage = today
    }
    
   
    //カレンダーの休日判定↓

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
    

    func Alert(){
        let alert = UIAlertController(title: "これ以上は選択できません！", message: "1日3つまでの登録となります", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func ButtuonShadow(position: UIButton){
        //ボタンに影をつけて丸にする
        position.layer.cornerRadius = screenWidth/12
        position.layer.shadowColor = UIColor.black.cgColor
        position.layer.shadowRadius = 3
        position.layer.shadowOffset = CGSize(width: 2, height: 2)
        position.layer.shadowOpacity = 0.5
        
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




