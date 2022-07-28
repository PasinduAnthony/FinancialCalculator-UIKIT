//
//  Loan MortgageViewController.swift
//  UtilityConverterDemo
//
//  Created by Pasindu on 2022-04-12.
//

import UIKit

class Loan_MortgageViewController: UIViewController, ReusableProtocol {
    //radio buttons
    @IBOutlet weak var loanAmountBtn: UIButton!
    @IBOutlet weak var monthlyPaymentBtn: UIButton!
    @IBOutlet weak var noOfPaymentsBtn: UIButton!
    @IBOutlet weak var yearSwitch: UISwitch!
    
    @IBOutlet weak var testTextField: UITextField!
    
    @IBOutlet var keyboard: ReusableView!
    @IBOutlet var textfields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning userdefault values to textfields, radio buttons, and switch
        if(UserDefaults.standard.double(forKey: "loanAmountL") != 0.0){
            textfields[0].text = "\(UserDefaults.standard.double(forKey: "loanAmountL"))"
            textfields[1].text = "\((UserDefaults.standard.double(forKey: "interestL") * 100 ))"
            textfields[2].text = "\(UserDefaults.standard.double(forKey: "monthlyPaymentL"))"
            textfields[3].text = "\(UserDefaults.standard.double(forKey: "noPaymentsL"))"
            yearSwitch.setOn(UserDefaults.standard.bool(forKey: "switchOnL"), animated: false)
            if UserDefaults.standard.integer(forKey: "buttonSelectedL") == 1 {
                loanAmountBtn.isSelected = true
            }else if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 2 {
                monthlyPaymentBtn.isSelected = true
                loanAmountBtn.isSelected = false
            }else if UserDefaults.standard.integer(forKey: "buttonSelectedC") == 3{
                noOfPaymentsBtn.isSelected = true
                loanAmountBtn.isSelected = false
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
    
    //------------- Calculate Radio Button Action -------------------
    
    @IBAction func loanAmountBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.text = ""
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = false
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = true
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            monthlyPaymentBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            monthlyPaymentBtn.isSelected = false
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
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            loanAmountBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }else{
            sender.isSelected = true
            loanAmountBtn.isSelected = false
            noOfPaymentsBtn.isSelected = false
        }
    }
    
    @IBAction func noOfPaymentsBtnAction(_ sender: UIButton) {
        //to disable the corresponding texfield to the selected radio button
        getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 1)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = true
        getTextFieldByTag(tag: 3)?.text = ""
        getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
        //allow user to select only one radio button
        if sender.isSelected{
            sender.isSelected = false
            loanAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
        }else{
            sender.isSelected = true
            loanAmountBtn.isSelected = false
            monthlyPaymentBtn.isSelected = false
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
    
    func setUserDefaults(loanAmount:Double, interest:Double, monthlyPayment:Double, noPayments:Double, switchOn:Bool, buttonSelected: Int){
        
        UserDefaults.standard.set(loanAmount, forKey: "loanAmountL")
        UserDefaults.standard.set(interest, forKey: "interestL")
        UserDefaults.standard.set(monthlyPayment, forKey: "monthlyPaymentL")
        UserDefaults.standard.set(noPayments, forKey: "noPaymentsL")
        UserDefaults.standard.set(switchOn, forKey: "switchOnL")
        UserDefaults.standard.set(buttonSelected, forKey: "buttonSelectedL")
    }
    
    func calculate(textfield: UITextField) {
        //getting values from textfields
        let loanAmount = Double((getTextFieldByTag(tag: 0)?.text!)! ) ?? 0
        var interest = Double((getTextFieldByTag(tag: 1)?.text!)! ) ?? 0
        let monthlyPayment = Double((getTextFieldByTag(tag: 2)?.text!)! ) ?? 0
        var noPayments = Double((getTextFieldByTag(tag: 3)?.text!)! ) ?? 0
        
        //interest is displayed as a precentage
        interest = interest / 100

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
        
        if loanAmountBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 0)?.text = ""
            getTextFieldByTag(tag: 0)?.isUserInteractionEnabled = false
           
            //checks if other fields are not empty
            if (interest != 0) && (noPayments != 0){
                let Loanfirst: Double = monthlyPayment * (((pow((interest/12 + 1),noPayments*12)) - 1) * pow((interest/12 + 1), -noPayments*12))
                let Loansecond: Double = interest/12
                var calc: Double = Loanfirst/Loansecond
                //rounding to 2 decimal places
                calc = Double(round(100*calc)/100)
                
                let textfield = textfields.filter { tf in
                    return tf.tag == 0
                }.first

                if (calc.isFinite){
                    textfield?.text = "\(calc)"
                }else if calc.isNaN{
                    calc = 0
                    textfield?.text = "\(calc)"
                }
                //setting userdefaults by calling function
                setUserDefaults(loanAmount: Double(calc), interest: interest, monthlyPayment: monthlyPayment, noPayments: noPayments, switchOn:switchOn, buttonSelected:1)
            }
        }else if monthlyPaymentBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 2)?.text = ""
            getTextFieldByTag(tag: 2)?.isUserInteractionEnabled = false
            
            // Monthly Payment Value Calcutaion
            let monthlyfirst: Double = (loanAmount * (interest / 12)) * (pow((1 + (interest / 12)), (12 * noPayments)))
            let monthlysecond: Double = (pow((1 + (interest / 12)), (12 * noPayments))) - 1
            var calc : Double = monthlyfirst/monthlysecond
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
            setUserDefaults(loanAmount: loanAmount, interest: interest, monthlyPayment: Double(calc), noPayments: noPayments, switchOn:switchOn, buttonSelected:2)
        }else if noOfPaymentsBtn.isSelected == true {
            //disable the selected textfield
            getTextFieldByTag(tag: 3)?.text = ""
            getTextFieldByTag(tag: 3)?.isUserInteractionEnabled = false
            
            //Number of payments
            let paymentsfirst: Double = log(1-((loanAmount/monthlyPayment)*(interest/12)))
            let paymentssecond: Double = -log((interest/12)+1)
            let time: Double = paymentsfirst/paymentssecond
            var calc = time
            //checks if the value is months or not
            if (switchOn == true) {
                calc = time / 12
            }
            //rounding to 2 decimal places
            calc = Double(round(100*calc)/100)

            let textfield = textfields.filter { tf in
                return tf.tag == 3
            }.first

            if calc.isFinite{
                textfield?.text = "\(calc)"
            }else if calc.isNaN{
                calc = 0
                textfield?.text = "\(calc)"
            }
            //setting userdefaults by calling function
            setUserDefaults(loanAmount: loanAmount, interest: interest,monthlyPayment: monthlyPayment, noPayments: Double(calc), switchOn:switchOn, buttonSelected:3)
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

}
