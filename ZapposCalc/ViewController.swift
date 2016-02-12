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
        //let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            enter()
        }
        /* irrelevant since now in calc brain
        if let operation = sender.currentTitle{
        switch operation {
        case "×": performOperation(multiply)
        case "÷": performOperation({(op1: Double, op2: Double) -> Double in
        return op2 / op1
        })
        case "+": performOperation({(op1, op2) in op1 + op2 })
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        default: break
        }
        }
        */
        
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
    
    //can be replaced by above
    //obsolete along with calcbrain and since it's condensed above
    /*
    func multiply(op1: Double, op2: Double) -> Double{
    return op1 * op2
    }*/
    
    //perform ops are now in calcbrain
    /*
    func performOperation(operation: (Double, Double) -> Double){
    if operandStack.count >= 2 {
    displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
    enter()
    }
    }
    
    //added private to be sure xcode knows this isn't obj -c
    private func performOperation(operation: Double -> Double) {
    if operandStack.count >= 1 {
    displayValue = operation(operandStack.removeLast())
    enter()
    }
    }*/
    
    
    //operand stack in calcbrain
    //var operandStack = [Double]()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        
        //undeeded with calcbrain
        //operandStack.append(displayValue)
        //print("operandStack = \(operandStack)")
        
        //we do need
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

