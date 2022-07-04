//
//  InitVC.swift
//  BLE_Control
//
//  Created by iMac 5K on 19.02.2022.
//

import UIKit

class InitVC: UIViewController {

    @IBOutlet weak var but_con: UIButton!
    @IBOutlet weak var lb_up: UILabel!
    @IBOutlet weak var car_but: UIButton!
    
    @IBOutlet weak var conn: UILabel!
    @IBOutlet weak var terminal_but: UIButton!
    @IBOutlet weak var lb_connect: UILabel!
    
    var con = "No connection"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLEcontrol.sharedInstance.startCentralManager() // start BLE
        
        updatefonts()
    }
    
    
    func updatefonts(){
        car_but.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 30)
        terminal_but.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 30)
        but_con.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 20)
        but_con.backgroundColor = .systemBlue
        but_con.setTitleColor(.black, for: .normal)
        but_con.layer.cornerRadius = 20
        car_but.layer.cornerRadius = 20
        terminal_but.layer.cornerRadius = 20
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatefonts()

    }
    
    
    @IBAction func car_connect(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "car_B") as? car_c else { return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func connect(_ sender: Any) {
        BLEcontrol.sharedInstance.startSCAN()
        con = "Connected"
        conn.text = con
    }
    
    @IBAction func terminal_go(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Terminal") as? Terminal else { return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        //vc.modalPresentationStyle = .fullScreen
        //vc.modalTransitionStyle = .crossDissolve
        //present(vc,animated: true)
    
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
