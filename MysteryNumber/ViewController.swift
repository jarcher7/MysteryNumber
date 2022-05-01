//
//  ViewController.swift
//  MysteryNumber
//
//  Created by Jeff Archer on 4/29/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let MIN : Int = 75;
    let MAX : Int = 279;

    override func viewDidLoad() {
        super.viewDidLoad()

        doReset()

        minSwitch.isOn = false
        maxSwitch.isOn = false

        minimum.delegate = self
        maximum.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        ViewController.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        ViewController.lockOrientation(.all)
    }

    @IBAction func onNewNumberClick(_ sender: Any) {
        let num = generateNumber()
        number.text = String(num)
    }

    @IBAction func onResetClick(_ sender: Any) {
        doReset()
    }

    func generateNumber() -> Int {
        var min : Int = MIN
        var max : Int = MAX
        if (minSwitch.isOn) {
            getLimitValue(textField: minimum, defValue: MIN, value: &min)
        }
        if (maxSwitch.isOn) {
            getLimitValue(textField: maximum, defValue: MAX, value: &max)
        }
        if (max < min) {
            (min, max) = (max, min)
            minimum.text = String(min)
            maximum.text = String(max)
        }
        let random = Int.random(in: min...max)
        return random;
    }

    fileprivate func doReset() {
        number.text = "? ? ?"
        minimum.text = String(MIN)
        maximum.text = String(MAX)
    }

    fileprivate func getLimitValue(textField: UITextField, defValue: Int, value: inout Int) {
        let text : String = textField.text ?? String(defValue)
        let minVal : Int = Int(text) ?? defValue
        if ((minVal >= 0) && (minVal <= 300)) {
            value = minVal
        } else {
            value = defValue
        }
        textField.text = String(value)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    @IBOutlet weak var number: UITextField!
    @IBOutlet var newNumberButton: UIView!
    @IBOutlet weak var minSwitch: UISwitch!
    @IBOutlet weak var maxSwitch: UISwitch!
    @IBOutlet weak var minimum: UITextField!
    @IBOutlet weak var maximum: UITextField!

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }

}

