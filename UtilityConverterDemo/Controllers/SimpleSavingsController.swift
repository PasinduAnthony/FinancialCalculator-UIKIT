//
//  SimpleSavingsController.swift
//  UtilityConverterDemo
//
//  Created by Pasindu on 2022-03-21.
//

import UIKit

class SimpleSavingsController: UIViewController, ReusableProtocol {
    //radio buttons
    @IBOutlet weak var principalAmountBtn: UIButton!
    @IBOutlet weak var interestBtn: UIButton!
    @IBOutlet weak var futureValueBtn: UIButton!
    @IBOutlet weak var noOfPaymentsBtn: UIButton!
    @IBOutlet weak var yearSwitch: UISwitch!
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var keyboardView: UIView!
    @IBOutlet var TableView: UITableView!
    
    @IBOutlet weak var testTextField: UITextField!
    var didTap = false
    
    @IBOutlet var keyboard: ReusableView!
    
    @IBOutlet var textfields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning userdefault values to textfields, radio buttons, and switch
        if(UserDefaults.standard.double(forKey: "principalAmount") != 0.0){
            textfields[0].text = "\(UserDefaults.standard.double(forKey: "principalAmount"))"
            textfields[1].text = "\((UserDefaults.standard.double(forKey: "interest") * 100 ))"
            textfields[2].text = "\(UserDefaults.standard.double(forKey: "futureValue"))"
            textfields[3].text = "\(UserDefaults.standard.double(forKey: "noPayments"))"
            yearSwitch.setOn(UserDefaults.standard.bool(forKey: "switchOn"), animated: false)
            if UserDefaults.standard.integer(forKey: "buttonSelected") == 1 {
                principalAmountBtn.isSelected = true
            }else if UserDefaults.standard.integer(forKey: "buttonSelected") == 2 {
                interestBtn.isSelected = true
                principalAmountBtn.isSelected = false
            }else if UserDefaults.standard.integer(forKey: "buttonSelected") == 3{
                futureValueBtn.isSelected = true
                principalAmountBtn.isSelected = false
            }else if UserDefaults.standard.integer(forKey: "buttonSelected") == 4{
                noOfPaymentsBtn.isSelected = true
                principalAmountBtn.isSelected = false
            }
        }
        // keyboard deligate
        keyboard.delegate = self
        // to disable apple keyboard
        textfields.forEach { textfield in
            textfield.inputView = UIView()
            textfield.inputAccessoryView = UIView()
            print(textfield.text as Any)
        }
    }
    
    //this function was implemented to hide and unhide keyboard but not implemented in the final product
    func PressedHide(){
        if(didTap)
        {
            didTap = false
            
            UIView.transition(with: keyboard, duration: 0.6,
                                options: .transitionFlipFromBottom,
                              animations: { [self] in
                self.keyboard.isHidden = false
                            })
        }
        else{
            UIView.transition(with: keyboard, duration: 0.6,
                                options: .transitionFlipFromTop,
                              animations: { [self] in
                self.keyboard.isHidden = true
                            })
            didTap = true
        }
    }
    
    //------------- Calculate Radio Button Action -------------------
    @IBAction func principalAmountBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.text = ""
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            interestBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            interestBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func interestBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.text = ""
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            principalAmountBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            principalAmountBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func futureValueBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.text = ""
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            principalAmountBtn.isSelected = false
            interestBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            principalAmountBtn.isSelected = false
            interestBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func noofPaymentsBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.text = ""
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            principalAmountBtn.isSelected = false
            interestBtn.isSelected = false
            futureValueBtn.isSelected = false
        }else{
            sender.isSelected = true
            principalAmountBtn.isSelected = false
            interestBtn.isSelected = false
            futureValueBtn.isSelected = false
        }
    }
    //------------- End Of Calculate Radio Button Action -------------------
    
    @IBAction func clearMemoryFun(_ sender: UIButton) {
        //alert
        let alert = UIAlertController(title: "Clear Memory", message: "Are you sure you want to clear?", preferredStyle: .actionSheet)
        
        let okayAction = UIAlertAction(title: "Okay", style:.destructive){
            (action) in
            //clear userdefault
            if let appDomain = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
             }
            self.textfields[0].text = ""
            self.textfields[1].text = ""
            self.textfields[2].text = ""
            self.textfields[3].text = ""
            self.yearSwitch.setOn(true, animated: true)
        }
        
        alert.addAction(okayAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel){
            (action) in
        }
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true){
            
        }
            
    }
    
    @IBAction func yearSwitchSelected(_ sender: UISwitch) {
        if yearSwitch.isOn {
            testTextField.text = "switchOn"
            calculate(textfield: testTextField)
        } else {
            testTextField.text = "switchOff"
            calculate(textfield: testTextField)
        }
    }
    
    func setUserDefaults(principalAmount:Double, interest:Double, futureValue:Double, noPayments:Double, switchOn:Bool, buttonSelected: Int){
        
        UserDefaults.standard.set(principalAmount, forKey: "principalAmount")
        UserDefaults.standard.set(interest, forKey: "interest")
        UserDefaults.standard.set(futureValue, forKey: "futureValue")
        UserDefaults.standard.set(noPayments, forKey: "noPayments")
        UserDefaults.standard.set(switchOn, forKey: "switchOn")
        UserDefaults.standard.set(buttonSelected, forKey: "buttonSelected")
    }
    
    func calculate(textfield: UITextField) {
        //getting values from textfields
        let principalAmount = Double((getTextFieldByTag(tag: 0)?.text!)! ) ?? 0
        var interest = Double((getTextFieldByTag(tag: 1)?.text!)! ) ?? 0
        let futureValue = Double((getTextFieldByTag(tag: 2)?.text!)! ) ?? 0
        var noPayments = Double((getTextFieldByTag(tag: 3)?.text!)! ) ?? 0
        
        //interest is displayed as a precentage
        interest = interest / 100
        let n = 12 //constant
        
        var switchOn = false
        if(!yearSwitch.isOn){
            //monthly
            print("The Switch is off")
            switchOn = false
            noPayments = (Double((getTextFieldByTag(tag: 3)?.text!)! ) ?? 0) * 0.0833334
        }else{
            //yearly
            print("The Switch is on")
            switchOn = true
            noPayments = Double((getTextFieldByTag(tag: 3)?.text!)! ) ?? 0
        }
        
        if principalAmountBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 0)?.text = ""
            getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = false
           
            //checks if other fields are not empty
            if (interest != 0) && (noPayments != 0) && (futureValue != 0){
                var calc = interest / Double(n)
                calc = calc + 1
                calc = pow(calc, (Double(n) * noPayments))
                calc = futureValue / calc
                //rounding to 2 decimal places
                calc = Double(round(100*calc)/100)
                
                let textfield = textfields.filter { tf in
                    return tf.tag == 0
                }.first
                
                //handle infinity values
                if (calc.isFinite){
                    textfield?.text = "\(calc)"
                }else if calc.isNaN{
                    calc = 0
                    textfield?.text = "\(calc)"
                }
                //setting userdefaults by calling function
                setUserDefaults(principalAmount: Double(calc), interest: interest, futureValue: futureValue, noPayments: noPayments, switchOn:switchOn, buttonSelected:1)
            }
        }else if interestBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 1)?.text = ""
            getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = false
            
            if (futureValue != 0) && (noPayments != 0) {
                var calc = futureValue / principalAmount
                calc = pow(calc, 1/(Double(n) * noPayments))
                calc = calc - 1
                calc = calc * Double(n)
                calc = calc * 100
                //rounding to 2 decimal places
                calc = Double(round(100*calc)/100)
                
                let textfield = textfields.filter { tf in
                    return tf.tag == 1
                }.first
                
                if (calc.isFinite){
                    textfield?.text = "\(calc)"
                }else if calc.isNaN{
                    calc = 0
                    textfield?.text = "\(calc)"
                }
                //setting userdefaults by calling function
                setUserDefaults(principalAmount: principalAmount, interest: Double(calc), futureValue: futureValue, noPayments: noPayments, switchOn:switchOn, buttonSelected:2)
            }
        }else if futureValueBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 2)?.text = ""
            getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = false
            
            // FutureValue Calcutaion
            var calc = interest / Double(n)
            calc = calc + 1
            calc = pow(calc, (Double(n) * noPayments))
            calc = calc * principalAmount
            //rounding to 2 decimal places
            calc = Double(round(100*calc)/100)
            
            let textfield = textfields.filter { tf in
                return tf.tag == 2
            }.first

            if (calc.isFinite){
                textfield?.text = "\(calc)"
            }else if calc.isNaN{
                calc = 0
                textfield?.text = "\(calc)"
            }
            //setting userdefaults by calling function
            setUserDefaults(principalAmount: principalAmount, interest: interest, futureValue: Double(calc), noPayments: noPayments, switchOn:switchOn, buttonSelected:3)
        }else if noOfPaymentsBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 3)?.text = ""
            getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
            
            //Number of payments
            var calc = interest / Double(n)
            calc = calc + 1
            calc = log10(calc)
            calc = Double(n) * calc
            calc = log10(futureValue/principalAmount) / calc
            calc = calc / 12
            //checks if the value is months or not
            if (switchOn == true) {
                calc = calc * 12
            }
            //rounding to 2 decimal places
            calc = Double(round(100*calc)/100)
            
            let textfield = textfields.filter { tf in
                return tf.tag == 3
            }.first

            if (calc.isFinite){
                textfield?.text = "\(calc)"
            }else if calc.isNaN{
                calc = 0
                textfield?.text = "\(calc)"
            }
            //setting userdefaults by calling function
            setUserDefaults(principalAmount: principalAmount, interest: interest, futureValue: futureValue, noPayments: Double(calc), switchOn:switchOn, buttonSelected:4)
        }else{
            //enable all textfields
            getTextFieldByTag(tag: 0)?.text = ""
            getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
            getTextFieldByTag(tag: 1)?.text = ""
            getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
            getTextFieldByTag(tag: 2)?.text = ""
            getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
            getTextFieldByTag(tag: 3)?.text = ""
            getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        }
    
    }
    
    func getTextFieldByTag(tag: Int) -> UITextField? {
        let textfield = textfields.filter { tf in
            return tf.tag == tag
        }.first
        return textfield
    }
    
    
    @IBAction func didPressHide(_ sender: Any) {
        PressedHide()
        textfields.forEach { textfield in
            textfield.inputView = UIView()
            if let text = textfield.text, text.isEmpty {
                print("Text field is empty")
                let alert = UIAlertController(title: "Error", message: "Fields can't be empty", preferredStyle: .actionSheet)
                
                let okayAction = UIAlertAction(title: "Okay", style:.cancel){
                    (action) in
                    print(action)
                }
                
                alert.addAction(okayAction)
                
                present(alert, animated: true, completion: nil)
            }else{
                
            }
        }
    }
    
    func changeWeight(textfield: UITextField) {
        calculate(textfield: textfield)
    }

    func didPressNumber(_ number: String) {
        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first

        if let tf = textfield {
            tf.text! += "\(number)"
            changeWeight(textfield: tf)
        }
    }

    func didPressDecemialNegative(_ value: String) {

        if value == "-" {
            return
        }

        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first

        if let tf = textfield {
            if (tf.text?.count ?? 0) > 0 {
                tf.text! += "."
            }
        }
    }

    func didPressDelete() {
        let textfield = textfields.filter { tf in
            return tf.isFirstResponder
        }.first
        if let tf = textfield {
            if (tf.text?.count ?? 0) > 0 {
                _ = tf.text!.removeLast()
            }
                calculate(textfield: tf)
        }
    }
}
