//
//  ViewController.swift
//  MysteryNumber
//
//  Created by Jeff Archer on 4/29/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var number: UITextField!
    @IBOutlet var newNumberButton: UIView!
    @IBOutlet weak var minSwitch: UISwitch!
    @IBOutlet weak var maxSwitch: UISwitch!
    @IBOutlet weak var minimum: UITextField!
    @IBOutlet weak var maximum: UITextField!
    @IBOutlet weak var numbersTable: UITableView!

    let MIN : Int = 75;
    let MAX : Int = 279;

    var numbers : [Int] = []
    var sorted : [Int] = []

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        doReset()

        self.minSwitch.isOn = false
        self.maxSwitch.isOn = false

        self.minimum.delegate = self
        self.maximum.delegate = self

        self.numbersTable.delegate = self
        self.numbersTable.dataSource = self
        self.numbersTable.register(UITableViewCell.self, forCellReuseIdentifier: "numCell")
        self.numbersTable.separatorColor = UIColor.white
        self.numbersTable.separatorStyle = UITableViewCell.SeparatorStyle.none;
    }

    override func viewDidAppear(_ animated: Bool) {
        ViewController.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        ViewController.lockOrientation(.all)
    }

    // MARK: - Event Handlers

    @IBAction func onNewNumberClick(_ sender: Any) {
        let num = generateNumber()
        self.number.text = String(num)
        self.numbers.insert(num, at: 0)
        self.sorted.insert(num, at: 0)
        self.sorted.sort(by: >)
        self.numbersTable.reloadData()
        self.numbersTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    }

    @IBAction func onResetClick(_ sender: Any) {
        doReset()
    }

    // MARK: - Helpers

    fileprivate func doReset() {
        self.number.text = "? ? ?"
        self.minimum.text = String(MIN)
        self.maximum.text = String(MAX)
        self.numbers = []
        self.sorted = []
        self.numbersTable.reloadData()
    }

    // MARK: - Numbers

    func generateNumber() -> Int {
        var min : Int = 1
        var max : Int = 300
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
        var random = Int.random(in: min...max)
        while (self.numbers.contains(random)) {
            random = Int.random(in: min...max)
        }
        return random;
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

    // MARK: - numbersTable

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.numbers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.numbersTable.dequeueReusableCell(withIdentifier: "numCell")! as UITableViewCell
        cell.textLabel?.font = UIFont.monospacedSystemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 15) )
        cell.textLabel?.textAlignment = .center
        var leftStr = String(self.numbers[indexPath.row])
        while (leftStr.count < 3) { leftStr.insert(" ", at: leftStr.index(leftStr.startIndex, offsetBy: 0)) }
        var rightStr = String(self.sorted[indexPath.row])
        while (rightStr.count < 3) { rightStr.insert(" ", at: rightStr.index(rightStr.startIndex, offsetBy: 0)) }
        cell.textLabel?.text = String(format: "%@\t\t\t\t\t%@", leftStr, rightStr)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }

    // MARK: - Orientation Lock

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {

        self.lockOrientation(orientation)

        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }

}

//class NumberCell: UITableViewCell {
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        addSubview(cellView)
//        cellView.addSubview(dayLabel)
//        self.selectionStyle = .none
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let cellView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        view.layer.cornerRadius = 10
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    let dayLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Day 1"
//        //label.textColor = UIColor.white
//        //label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//}

