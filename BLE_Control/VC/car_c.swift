//
//  car_c.swift
//  BLE_Control
//
//  Created by iMac 5K on 18.02.2022.
//

import UIKit

class car_c: UIViewController {
    
    @IBOutlet weak var speed_lb: UILabel!
    @IBOutlet weak var slidercar: UISlider!
    @IBOutlet weak var car_back: UIButton!

    var speed: Int = 0
    
    func stylebutton(){
        speed_lb.font = UIFont(name: "Georgia-Bold", size: 30)
        speed_lb.text = "Speed: \(speed)"
        car_back.titleLabel?.font = UIFont(name: "Georgia-Bold", size: 30)
        car_back.backgroundColor  = .systemGray2
        car_back.setTitleColor(.black, for: .normal)
        car_back.layer.cornerRadius = 35
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        slidercar.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        stylebutton()
        //slidercar.layer.position.y = 350
        //slidercar.layer.position.x = 300
    }
    
    
    @IBAction func slideraction(_ sender: Any) {
        speed = Int(slidercar.value)
        speed_lb.text = "Speed: \(speed)"
        BLEcontrol.sharedInstance.writeOutgoingValue(data: String(speed)+" \n")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        stylebutton()
        BLEcontrol.sharedInstance.startSCAN()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stylebutton()
    }
    @IBAction func car_backk(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
