//
//  NextViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/19.
//

import UIKit

class NextViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var calNameText: UITextField!

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var interCount = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ラベルとボタンの位置とサイズ
        button.frame = CGRect(x: screenWidth/4, y: screenHeight/2, width: screenWidth/2, height: 60)
        label.frame = CGRect(x: 0, y: screenHeight/3, width: screenWidth, height: 40)
        calNameText.frame = CGRect(x: screenWidth/6, y: screenHeight/2.4, width: screenWidth * 2/3, height: 40)
        
        
        calNameText.delegate = self
        calNameText.borderStyle = .roundedRect
        self.overrideUserInterfaceStyle = .light
        button.backgroundColor = .systemOrange
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowOpacity = 0.5
        
        interCount = UserDefaults.standard.integer(forKey: "interCount")
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationItem.title = "戻る"
    }
    
    @IBAction func button(_ sender: UIButton) {
        
        let calVC = self.storyboard?.instantiateViewController(identifier: "calView") as! ViewController
        
        if calNameText.text == ""{
            calNameText.text = "私の筋トレカレンダー"
            calVC.userDefaults.set(calNameText.text, forKey: "calName")
        }else{
            calVC.userDefaults.set(calNameText.text, forKey: "calName")
        }
        
        interCount += 1
        print(interCount)
        
        UserDefaults.standard.set(interCount, forKey: "interCount")
        self.navigationController?.popViewController(animated: true)
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
