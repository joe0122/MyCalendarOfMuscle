//
//  NextViewController.swift
//  MyCalendarOfMuscle
//
//  Created by 矢嶋丈 on 2020/10/19.
//

import UIKit

class NameChangeController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var calNameText: UITextField!

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var interCount = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calNameText.delegate = self
        self.overrideUserInterfaceStyle = .light
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
