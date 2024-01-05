//
//  ViewController.swift
//  MysteryNumber
//
//  Created by Jeff Archer on 4/29/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var number: UITextField!
    @IBOutlet var newNumberButton: UIView!
    @IBOutlet var minSwitch: UISwitch!
    @IBOutlet var maxSwitch: UISwitch!
    @IBOutlet var minimum: UITextField!
    @IBOutlet var maximum: UITextField!
    @IBOutlet var numbersTable: UITableView!

    let DEFAULT_MIN: Int = 99
    let DEFAULT_MAX: Int = 300

    var numbers: [Int] = []
    var sorted: [Int] = []

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        doReset()
        loadDefaults()

        minimum.delegate = self
        maximum.delegate = self

        numbersTable.delegate = self
        numbersTable.dataSource = self
        numbersTable.register(UITableViewCell.self, forCellReuseIdentifier: "numCell")
        numbersTable.separatorColor = UIColor.white
        numbersTable.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    func loadDefaults() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "init") == false {
            minimum.text = String(DEFAULT_MIN)
            maximum.text = String(DEFAULT_MAX)
            minSwitch.isOn = false
            maxSwitch.isOn = false
        } else {
            minimum.text = defaults.string(forKey: "minimum")
            maximum.text = defaults.string(forKey: "maximum")
            minSwitch.isOn = defaults.bool(forKey: "minOn")
            maxSwitch.isOn = defaults.bool(forKey: "maxOn")
        }
    }

    func saveDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(minimum.text, forKey: "minimum")
        defaults.set(maximum.text, forKey: "maximum")
        defaults.set(minSwitch.isOn, forKey: "minOn")
        defaults.set(maxSwitch.isOn, forKey: "maxOn")
        defaults.set(true, forKey: "init")
    }

    func enableUI(_ isEnabled: Bool) {
        minSwitch.isEnabled = isEnabled
        maxSwitch.isEnabled = isEnabled
        minimum.isEnabled = isEnabled
        maximum.isEnabled = isEnabled
    }

    // MARK: - Event Handlers

    @IBAction func onEditEnd(_ sender: Any) {
        saveDefaults()
    }

    @IBAction func onNewNumberClick(_ sender: UIButton) {
        enableUI(false)
        let num = generateNumber()
        number.text = String(num)
        numbers.insert(num, at: 0)
        sorted.insert(num, at: 0)
        sorted.sort(by: >)
        numbersTable.reloadData()
        numbersTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    }

    @IBAction func onResetClick(_ sender: UIButton) {
        doReset()
    }

    // MARK: - Helpers

    fileprivate func doReset() {
        number.text = "? ? ?"
        numbers = []
        sorted = []
        numbersTable.reloadData()
        enableUI(true)
    }

    // MARK: - Numbers

    func generateNumber() -> Int {
        var min: Int = 1
        var max: Int = 300
        if minSwitch.isOn {
            getLimitValue(textField: minimum, defValue: DEFAULT_MIN, value: &min)
        }
        if maxSwitch.isOn {
            getLimitValue(textField: maximum, defValue: DEFAULT_MAX, value: &max)
        }
        if max < min {
            (min, max) = (max, min)
            minimum.text = String(min)
            maximum.text = String(max)
        }
        var random = Int.random(in: min ... max)
        while numbers.contains(random) {
            random = Int.random(in: min ... max)
        }
        return random
    }

    fileprivate func getLimitValue(textField: UITextField, defValue: Int, value: inout Int) {
        let text: String = textField.text ?? String(defValue)
        let minVal: Int = Int(text) ?? defValue
        if (minVal >= 0) && (minVal <= 300) {
            value = minVal
        } else {
            value = defValue
        }
        textField.text = String(value)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    // MARK: - numbersTable

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = numbersTable.dequeueReusableCell(withIdentifier: "numCell")! as UITableViewCell
        cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 15))
        cell.textLabel?.textAlignment = .center
        var leftStr = String(numbers[indexPath.row])
        while leftStr.count < 3 { leftStr.insert(" ", at: leftStr.index(leftStr.startIndex, offsetBy: 0)) }
        var rightStr = String(sorted[indexPath.row])
        while rightStr.count < 3 { rightStr.insert(" ", at: rightStr.index(rightStr.startIndex, offsetBy: 0)) }
        cell.textLabel?.text = String(format: "%@\t\t\t\t\t%@", leftStr, rightStr)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
