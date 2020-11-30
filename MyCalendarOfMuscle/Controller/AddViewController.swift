//
//  AddViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/19.
//

import UIKit

class AddViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var setField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tourokuButton: UIButton!
    
    @IBOutlet weak var traningNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var juuryoLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var kgLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    
    var selectData = [String]()
    var selectDay = String()
    var pushMenu = String()
    var traning = [String]()
    
    var menuArray = [String]()
    var selectMenu = [String]()
    
    let userDefaults = UserDefaults.standard
    
    var menuData = MenuData()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        nameField.delegate = self
        weightField.delegate = self
        setField.delegate = self
        
        editButton.setTitle("編集", for: .normal)
        menuArray.removeAll()
        
        if UserDefaults.standard.stringArray(forKey: pushMenu) != nil{
            menuArray = UserDefaults.standard.stringArray(forKey: pushMenu)!
        }
        
        if let data = userDefaults.value(forKey: selectDay) as? Data{
            let decodeData = try? PropertyListDecoder().decode(MenuData.self, from: data)
            menuData = decodeData!
        }
        
        tableView.allowsMultipleSelection = true
        
        //日付の表示と部位の部分だけのテキストカラーを変えている
        if pushMenu == "腕"{
        traningNameLabel.text = "腕トレのメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemRed, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        
        }else if pushMenu == "肩"{
        traningNameLabel.text = //"肩トレのメニュー(\(selectDay.dropFirst(5)))"
        "肩トレのメニュー(10/20)"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        }else if pushMenu == "胸"{
        traningNameLabel.text = "胸トレのメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        }else if pushMenu == "腹"{
        traningNameLabel.text = "腹トレのメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        }else if pushMenu == "背"{
        traningNameLabel.text = "背中トレのメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemPurple, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        }else if pushMenu == "脚"{
        traningNameLabel.text = "脚トレのメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemTeal, range: NSMakeRange(0, 1))
        traningNameLabel.attributedText = firstText
        }else if pushMenu == "有"{
        //有酸素の場合のみ単位を変更
        juuryoLabel.text = "距離"
        setLabel.text = "時間"
        countLabel.text = "分"
        
        traningNameLabel.text = "有酸素のメニュー(\(selectDay.dropFirst(5)))"
        traningNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        let firstText = NSMutableAttributedString(string: traningNameLabel.text!)
        firstText.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: NSMakeRange(0, 3))
        traningNameLabel.attributedText = firstText
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = menuArray[indexPath.row]
        cell.backgroundColor = .clear
        
        var selectMenuArray = [String]()
        
        if menuData.menu1[0] == pushMenu{
            selectMenuArray.append(contentsOf: menuData.menu1.dropFirst())
        }else if menuData.menu2[0] == pushMenu{
            selectMenuArray.append(contentsOf: menuData.menu2.dropFirst())
        }else if menuData.menu3[0] == pushMenu{
            selectMenuArray.append(contentsOf: menuData.menu3.dropFirst())
        }
        
        let a = UserDefaults.standard.stringArray(forKey: "\(pushMenu)\(selectDay)")
        
        //すでに選択されていたトレーニングに予めチェックマークをつけておく
        if a != nil{
            for i in 0..<a!.count{
                if cell.textLabel?.text == a![i]{
                    cell.accessoryType = .checkmark
                    cell.backgroundColor = .clear
                    selectMenu.append((cell.textLabel?.text)!)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
            cell?.selectionStyle = .none
            selectMenu.remove(at: selectMenu.firstIndex(of: (cell?.textLabel?.text)!)!)
        }else{
            cell?.accessoryType = .checkmark
            cell?.selectionStyle = .none
            selectMenu.append((cell?.textLabel?.text)!)
        }
        print(selectMenu)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
            cell?.selectionStyle = .none
            selectMenu.remove(at: selectMenu.firstIndex(of: (cell?.textLabel?.text)!)!)
        }else{
            cell?.accessoryType = .checkmark
            cell?.selectionStyle = .none
            selectMenu.append((cell?.textLabel?.text)!)
        }
        print(selectMenu)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            menuArray.remove(at: indexPath.row)
            UserDefaults.standard.set(menuArray, forKey: pushMenu)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func addAction(_ sender: Any) {
                
        if nameField.text != ""{
            //有酸素の場合だけ単位が違うので、分岐
            if pushMenu == "有"{
                if weightField.text != "" && setField.text != ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!))キロ \(String(describing: setField.text!))分")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                }else if weightField.text != "" && setField.text == ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!))キロ")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                }else if weightField.text == "" && setField.text != ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: setField.text!))分")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                }else{
                    menuArray.append("\(String(describing: nameField.text!))")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                }
            //有酸素以外の場合
            }else{
                //重量、セット数ともに値が入力された時
                if weightField.text != "" && setField.text != ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!))キロ \(String(describing: setField.text!))回")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                //重量のみが入力された時
                }else if weightField.text != "" && setField.text == ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!))キロ")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                //セット数のみが入力された時
                }else if weightField.text == "" && setField.text != ""{
                    menuArray.append("\(String(describing: nameField.text!)) \(String(describing: setField.text!))回")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                //メニューのみが入力された時
                }else{
                    menuArray.append("\(String(describing: nameField.text!))")
                    UserDefaults.standard.set(menuArray, forKey: pushMenu)
                }
            }
            
        //メニューが入力されていない時のアラート
        }else{
            Alert()
        }
        
        nameField.text = ""
        weightField.text = ""
        setField.text = ""
        
        nameField.endEditing(true)
        weightField.endEditing(true)
        setField.endEditing(true)

        tableView.reloadData()
        
    }
    @IBAction func touroku(_ sender: Any) {
        
        if menuData.menu1[0] == pushMenu{
            menuData.menu1.insert(contentsOf: selectMenu, at: 1)
        }else if menuData.menu2[0] == pushMenu{
            menuData.menu2.insert(contentsOf: selectMenu, at: 1)
        }else if menuData.menu3[0] == pushMenu{
            menuData.menu3.insert(contentsOf: selectMenu, at: 1)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func editAction(_ sender: Any) {
        
        let string = editButton.titleLabel?.text
            if string == "編集"{
                tableView.setEditing(true, animated: true)
                editButton.setTitle("完了", for: UIControl.State.normal)
            } else {
                tableView.setEditing(false, animated: true)
                editButton.setTitle("編集", for: UIControl.State.normal)
            }
        
        selectMenu.removeAll()
        /*リロードの理由は、セルを選択した状態で編集ボタンを押すと
        内部的には選択されていないが、チェックが入った状態のままになってしまうから*/
        tableView.reloadData()

    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        weightField.resignFirstResponder()
        setField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameField.endEditing(true)
        weightField.endEditing(true)
        setField.endEditing(true)
    }
    
    func Alert(){
        let alert = UIAlertController(title: "メニューが入力されていません！", message: "メニューは必須項目となっています。", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}

