//
//  CompoundSavingsController.swift
//  UtilityConverterDemo
//
//  Created by Pasindu on 2022-03-19.
//

import UIKit

class CompoundSavingsController: UIViewController, ReusableProtocol {
    //radio buttons
    @IBOutlet weak var principalAmountBtn: UIButton!
    @IBOutlet weak var monthlyPaymentBtn: UIButton!
    @IBOutlet weak var futureValueBtn: UIButton!
    @IBOutlet weak var noOfPaymentsBtn: UIButton!
    @IBOutlet weak var yearSwitch: UISwitch!
    
    @IBOutlet weak var keyboard: ReusableView!
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet var textfields: [UITextField]!
    
    var didTap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning userdefault values to textfields, radio buttons, and switch
        if(UserDefaults.standard.double(forKey: "principalAmountC") != 0.0){
            textfields[0].text = "\(UserDefaults.standard.double(forKey: "principalAmountC"))"
            textfields[1].text = "\((UserDefaults.standard.double(forKey: "interestC") * 100 ))"
            textfields[2].text = "\(UserDefaults.standard.double(forKey: "monthlyPaymentC"))"
            textfields[3].text = "\(UserDefaults.standard.double(forKey: "futureValueC"))"
            textfields[4].text = "\(UserDefaults.standard.double(forKey: "noPaymentsC"))"
            yearSwitch.setOn(UserDefaults.standard.bool(forKey: "switchOnC"), animated: false)
            if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 1 {
                principalAmountBtn.isSelected = true
            }else if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 2 {
                monthlyPaymentBtn.isSelected = true
                principalAmountBtn.isSelected = false
            }else if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 3{
                futureValueBtn.isSelected = true
                principalAmountBtn.isSelected = false
            }else if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 4{
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
            PressedHide()
            print(textfield.text as Any)
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
        getTextFieldByTag(tag: 4)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            monthlyPaymentBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            monthlyPaymentBtn.isSelected = false
            futureValueBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func monthlyPaymentBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.text = ""
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 4)?.isUserInteractionEnabled = true
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
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.text = ""
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 4)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            principalAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            principalAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func noOfPaymentsBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 4)?.text = ""
        getTextFieldByTag(tag: 4)?.isUserInteractionEnabled = false
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            principalAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
            futureValueBtn.isSelected = false
        }else{
            sender.isSelected = true
            principalAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
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
            self.textfields[4].text = ""
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
    
    func setUserDefaults(principalAmount:Double, interest:Double, monthlyPayment:Double, futureValue:Double, noPayments:Double, switchOn:Bool, buttonSelected: Int){
        
        UserDefaults.standard.set(principalAmount, forKey: "principalAmountC")
        UserDefaults.standard.set(interest, forKey: "interestC")
        UserDefaults.standard.set(monthlyPayment, forKey: "monthlyPaymentC")
        UserDefaults.standard.set(futureValue, forKey: "futureValueC")
        UserDefaults.standard.set(noPayments, forKey: "noPaymentsC")
        UserDefaults.standard.set(switchOn, forKey: "switchOnC")
        UserDefaults.standard.set(buttonSelected, forKey: "buttonSelectedC")
    }
    
    func calculate(textfield: UITextField) {
        //getting values from textfields
        let principalAmount = Double((getTextFieldByTag(tag: 0)?.text!)! ) ?? 0
        var interest = Double((getTextFieldByTag(tag: 1)?.text!)! ) ?? 0
        let monthlyPayment = Double((getTextFieldByTag(tag: 2)?.text!)! ) ?? 0
        let futureValue = Double((getTextFieldByTag(tag: 3)?.text!)! ) ?? 0
        var noPayments = Double((getTextFieldByTag(tag: 4)?.text!)! ) ?? 0
        
        //interest is displayed as a precentage
        interest = interest / 100
        let n = 12 //constant
        
        var switchOn = false
        if(!yearSwitch.isOn){
            //monthly
            print("The Switch is off")
            switchOn = false
            noPayments = (Double((getTextFieldByTag(tag: 4)?.text!)! ) ?? 0) * 0.0833334
        }else{
            //yearly
            print("The Switch is on")
            switchOn = true
            noPayments = Double((getTextFieldByTag(tag: 4)?.text!)! ) ?? 0
        }
        
        if principalAmountBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 0)?.text = ""
            getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = false
           
            //checks if other fields are not empty
            if (interest != 0) && (noPayments != 0) && (futureValue != 0){
                var calc = (futureValue - (monthlyPayment * (pow((1 + interest / Double(n)), Double(n) * noPayments) - 1) / (interest / Double(n)))) / pow((1 + interest / Double(n)), Double(n) * noPayments)
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
                setUserDefaults(principalAmount: Double(calc), interest: interest, monthlyPayment: monthlyPayment, futureValue: futureValue, noPayments: noPayments, switchOn:switchOn, buttonSelected:1)
            }
        }else if monthlyPaymentBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 2)?.text = ""
            getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = false
            
            // Monthly Payment Value Calcutaion
            var calc = ((futureValue - (principalAmount * pow((1 + interest / Double(n)), Double(n) * noPayments))) / ((pow((1 + interest / Double(n)), Double(n) * noPayments) - 1) / (interest / Double(n))) / (1 + interest / Double(n)))
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
            setUserDefaults(principalAmount: principalAmount, interest: interest, monthlyPayment: Double(calc), futureValue: futureValue, noPayments: noPayments, switchOn:switchOn, buttonSelected:2)
        }
        else if futureValueBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 3)?.text = ""
            getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
            
            // FutureValue Calcutaion
            var calc = principalAmount * pow((1 + interest / Double(n)), Double(n) * noPayments) + (monthlyPayment * (pow((1 + interest / Double(n)), Double(n) * noPayments) - 1) / (interest / Double(n)))
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
            setUserDefaults(principalAmount: principalAmount, interest: interest,monthlyPayment: monthlyPayment, futureValue: Double(calc), noPayments: noPayments, switchOn:switchOn, buttonSelected:3)
        }else if noOfPaymentsBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 4)?.text = ""
            getTextFieldByTag(tag: 4)?.isUserInteractionEnabled = false
            
            //Number of payments
            var calc = Double((log(futureValue + ((monthlyPayment * Double(n)) / interest)) - log(((interest * principalAmount) + (monthlyPayment * Double(n))) / interest)) / (Double(n) * log(1 + (interest / Double(n)))))
            //checks if the value is months or not
            if (switchOn == false) {
                calc = calc * 12
            }
            //rounding to 2 decimal places
            calc = Double(round(100*calc)/100)
            
            let textfield = textfields.filter { tf in
                return tf.tag == 4
            }.first

            if calc.isFinite{
                textfield?.text = "\(calc)"
            }else if calc.isNaN{
                calc = 0
                textfield?.text = "\(calc)"
            }
            //setting userdefaults by calling function
            setUserDefaults(principalAmount: principalAmount, interest: interest,monthlyPayment: monthlyPayment, futureValue: futureValue, noPayments: Double(calc), switchOn:switchOn, buttonSelected:4)
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
    
    func PressedHide(){
        if(didTap)
        {
//            keyboard.isHidden = false
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
    
    @IBAction func didPressHide(_ sender: Any) {
        PressedHide()
    }
    
    // MARK: Implementation of the Reusable protocol methods
//    extension CompoundSavingsController: ReusableProtocol {

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
        
       
//    }


}
