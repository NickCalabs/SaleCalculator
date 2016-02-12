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
    
    @IBAction func contantPressed(sender: UIButton) {
        let constant = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        display.text = "\(brain.constants[constant]!)"
        enter()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        
        if let operation = sender.currentTitle{
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
        if historyLabel.text != nil{
            historyLabel.text = historyLabel.text! + op
        } else {
            historyLabel.text = op
        }
    }
    
}

