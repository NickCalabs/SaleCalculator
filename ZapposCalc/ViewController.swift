//
//  ViewController.swift
//  ZapposCalc
//
//  Created by Nick on 2/12/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    //connected to all numbers and the decimal point
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber && digit != "." || (digit == "." && display.text!.rangeOfString(".") == nil) {
            display.text = display.text! + digit
        } else {
            if digit == "." {
                display.text = "0" + digit
            }
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        appendToHistory(digit)
    }
    
    //connected to Pi and if there were other constants like e
    @IBAction func contantPressed(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        display.text = "\(brain.constants[constant]!)"
        enter()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    //all operations including the 75% -25% off and ± operations
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle{
            if userIsInTheMiddleOfTypingANumber{
                if operation == "±" {
                    let displayText = display.text!
                    if (displayText.rangeOfString("-") != nil) {
                        display.text = String(displayText.characters.dropFirst())
                    } else {
                        display.text = "-" + displayText
                    }
                    return
                }
                enter()
            }
            if let result = brain.performOperation(operation){
                displayValue = result
                appendToHistory(operation)
            } else {
                displayValue = 0 //TODO
            }
        }
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        brain.clearAll()
        display.text = "0"
        historyLabel.text = ""
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        } else {
            displayValue = 0 //TODO
        }
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    func appendToHistory(op: String){
        //adds everything to the histroy in a somewhat readable format
        //can be improved
        if historyLabel.text != nil{
            historyLabel.text = historyLabel.text! + op
        } else {
            historyLabel.text = op
        }
    }
    
}

