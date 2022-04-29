//
//  ViewController.swift
//  MysteryNumber
//
//  Created by Jeff Archer on 4/29/22.
//

import UIKit

class ViewController: UIViewController {
    
    let MIN : Int = 100;
    let MAX : Int = 300;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        number.text = "299"
        minimum.text = String(MIN)
        maximum.text = String(MAX)
        minSwitch.isOn = false
        maxSwitch.isOn = false
    }

    @IBAction func onNewNumberClick(_ sender: Any) {
        let num = generateNumber()
        number.text = String(num)
    }
    
    func generateNumber() -> Int {
        var min = MIN
        var max = MAX
        if (minSwitch.isOn) {
            let text : String = minimum.text ?? String(MIN)
            let minVal : Int = Int(text) ?? MIN
            if ((minVal >= 0) && (minVal < 300)) {
                min = minVal
            }
            minimum.text = String(min)
        }
        if (maxSwitch.isOn) {
            let text : String = maximum.text ?? String(MAX)
            let maxVal : Int = Int(text) ?? MAX
            if ((maxVal >= 0) && (maxVal < 300)) {
                max = maxVal
            }
            maximum.text = String(max)
        }
        let random = Int.random(in: min...max)
        return random;
    }
    
    @IBOutlet weak var number: UITextField!
    @IBOutlet var newNumberButton: UIView!
    @IBOutlet weak var minSwitch: UISwitch!
    @IBOutlet weak var maxSwitch: UISwitch!
    @IBOutlet weak var minimum: UITextField!
    @IBOutlet weak var maximum: UITextField!
}

