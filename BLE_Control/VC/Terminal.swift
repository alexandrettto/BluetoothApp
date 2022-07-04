//
//  Terminal.swift
//  BLE_Control
//
//  Created by iMac 5K on 15.02.2022.
//

import UIKit

class Terminal: UIViewController,UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var BTBACK: UIButton!
    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var messages: UITextView!
    @IBOutlet weak var READ: UIButton!
   

    
    
    
    
    
    var history_text = ""
    func updatestyle(){
        BTBACK.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 30)
        BTBACK.backgroundColor  = .systemGray2
        BTBACK.setTitleColor(.black, for: .normal)
        READ.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 30)
        READ.backgroundColor  = .systemGray2
        READ.setTitleColor(.blue, for: .normal)
        BTBACK.layer.cornerRadius = 35
        READ.layer.cornerRadius = 35
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // Do any additional setup after loading the view.
        
        messages.textContainerInset = UIEdgeInsets.zero
        messages.textContainer.lineFragmentPadding = 10
        BTBACK.setTitle("BACK", for: .normal)
        messages.delegate = self
        txt.delegate = self
        messages.isScrollEnabled = true
        messages.isEditable = false
        messages.isSelectable = false
        
        
        updatestyle()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        BLEcontrol.sharedInstance.startSCAN()
    }
    
    deinit{
        //Stop Listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func READ_BT(_ sender: Any) {
        history_text = history_text +  "[RECIEVED]"+BLEcontrol.sharedInstance.read_value+"\n"
        messages.text = history_text
    }
    @objc func keyboardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height
            
        } else {
            view.frame.origin.y = 0
        }
            
            
        
        
    }
        
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // dismiss keyboard
        return true
    }
    
    @IBAction func send_txt(_ sender: Any) {
        let text: String = txt.text ?? ""
        print(text)
        BLEcontrol.sharedInstance.writeOutgoingValue(data: text+"\n")
        history_text = history_text + "[SENDED] "+text+"\n"
        messages.text = history_text
        messages.textContainer.lineBreakMode = .byCharWrapping
      
    }
    

    

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}
