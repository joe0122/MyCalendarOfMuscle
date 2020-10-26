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
    
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var kgLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tourokuLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tourokuButton: UIButton!
    
    @IBOutlet weak var traningNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var selectData = [String]()
    var selectDay = String()
    var pushMenu = String()
    
    var menuArray = [String]()
    var selectMenu = [String]()
    
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        nameField.delegate = self
        weightField.delegate = self
        setField.delegate = self
        
        editButton.setTitle("編集", for: .normal)
        
        //レイアウト
        traningNameLabel.frame = CGRect(x: screenWidth/6, y: 40, width: screenWidth/1.5, height: 50)
        editButton.frame = CGRect(x: screenWidth * 5/6, y: 50, width: 50, height: 30)
        
        menuLabel.frame = CGRect(x: 25, y: screenHeight/6 + 5, width: screenWidth/5, height: 30)
        nameField.frame = CGRect(x: screenWidth/5 + 25, y: screenHeight/6, width: screenWidth/2.5, height: 40)
        
        weightLabel.frame = CGRect(x: 25, y: screenHeight/6 + 55, width: screenWidth/5, height: 30)
        weightLabel.textAlignment = .center
        weightField.frame = CGRect(x: screenWidth/5 + 25, y: screenHeight/6 + 50, width: screenWidth/3, height: 40)
        kgLabel.frame = CGRect(x: screenWidth/5 + screenWidth/3 + 30, y: screenHeight/6 + 60, width: 40, height: 20)
        
        setLabel.frame = CGRect(x: 25, y: screenHeight/6 + 105, width: screenWidth/5, height: 30)
        setField.frame = CGRect(x: screenWidth/5 + 25, y: screenHeight/6 + 100, width: screenWidth/3, height: 40)
        countLabel.frame = CGRect(x: screenWidth/5 + screenWidth/3 + 30, y: screenHeight/6 + 110, width: 25, height: 20)
        
        addButton.frame = CGRect(x: screenWidth - 100, y: screenHeight/6 + 55, width: 85, height: 40)
        tourokuButton.frame = CGRect(x: screenWidth/3, y:  screenHeight/6 + 150, width: 130, height: 45)
        tourokuLabel.frame = CGRect(x: 0, y: screenHeight/6 + 200, width: screenWidth, height: 45)
        tourokuLabel.text = "※セルを選択して登録を押してください\n(しない場合は'登録なし'となります)"
        
        tableView.frame = CGRect(x: 0, y: screenHeight/6 + 250, width: screenWidth, height: screenHeight/6 + 250)
        
        
        
        menuArray.removeAll()
        
        
        if UserDefaults.standard.stringArray(forKey: pushMenu) != nil{
            menuArray = UserDefaults.standard.stringArray(forKey: pushMenu)!
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
            traningNameLabel.text = "肩トレのメニュー(\(selectDay.dropFirst(5)))"
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .checkmark
            cell?.backgroundColor = .clear
        selectMenu.append((cell?.textLabel?.text)!)
        print(selectMenu)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = .none
            cell?.backgroundColor = .clear
        selectMenu.remove(at: selectMenu.firstIndex(of: (cell?.textLabel?.text)!)!)
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
            //すでに登録されているメニューを持ってくる
            if UserDefaults.standard.stringArray(forKey: pushMenu) != nil{
                menuArray = UserDefaults.standard.stringArray(forKey: pushMenu)!
            }
            //重量とセット数が入力されている場合
            if weightField.text != "" && setField.text != ""{
                menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!))キロ \(String(describing: setField.text!))回")
                UserDefaults.standard.set(menuArray, forKey: pushMenu)
                
            //メニューのみ入力されている場合は単位のキロと回を付けないようにする
            }else if weightField.text == "" && setField.text == ""{
                menuArray.append("\(String(describing: nameField.text!)) \(String(describing: weightField.text!)) \(String(describing: setField.text!))")
                UserDefaults.standard.set(menuArray, forKey: pushMenu)

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
        UserDefaults.standard.set(selectMenu, forKey: "\(pushMenu)\(selectDay)")
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

