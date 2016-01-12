//
//  ViewController.swift
//  Calculator
//
//  Created by Jiali Chen on 12/5/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var display: UILabel! // means always unwrap it
    // if this is ?, we need to add ! at every time this variable there
    
    @IBOutlet weak var history: UILabel!
    
    var userIsInTheMiddleOfTypingNumber: Bool = false
    var brain = CalculatorBrain()
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTypingNumber {
              }
        userIsInTheMiddleOfTypingNumber = false
        
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
            
        }
        else {
            displayValue = 0
        }

        history.text = brain.description

//        println("operanStack = \(operandStack)")
    }
    
    

    @IBAction func getVariable(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!) {
            displayValue = result
            
        }
        else {
            displayValue = 0
        }
        
        history.text = brain.description
      
    }
    
    @IBAction func SetVariable() {
       brain.variableValues["M"] = displayValue!
       userIsInTheMiddleOfTypingNumber = false

    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
            else {
                display.text = " "
            
        }

            history.text = brain.description+"="
            
    }
    }
    

    
 // Those are for assignment 1
//    func performOperation(operation: (Double, Double) -> Double) {
//        if operandStack.count >= 2 {
//            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
//            history.text = history.text! + "="
//            enter()
//        }
//        
//    }
//    
//    private func performOperation(operation: Double -> Double) {
//        if operandStack.count >= 1 {
//            displayValue = operation(operandStack.removeLast())
//            enter()
//        }    }
//    
    
    @IBAction func ChangeSign() {
        let str = display.text!
        if userIsInTheMiddleOfTypingNumber {
            if str.hasPrefix("-") {
                display.text = String(str.characters.dropFirst())
            }
            else {
                display.text! = "-" + str
            }
        }
        
        
    }
    
    var displayValue : Double? {

        get {
//            println(display.text)
            if let x = NSNumberFormatter().numberFromString(display.text!) {
            return x.doubleValue
            }
//        displayValue should return nil whenever the contents of the display cannot be interpreted as a Double.
            else {
                return nil
  
            }
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }
    
    
    @IBAction func DeleteDigit() {
        let str = display.text!
        let index1 = str.endIndex.advancedBy(-1)
        if userIsInTheMiddleOfTypingNumber {
            display.text = str.substringToIndex(index1)
        }
        
    }
    
    @IBAction func clear() {
        history.text = " "
        display.text = " "
        brain.clear()
        userIsInTheMiddleOfTypingNumber = false

    }
    
    @IBAction func AppendDigit(sender: UIButton) {
        
        
        //        if currentTitle is not set, and you add ! after it to unwrap the option, it will crash your program
        let digit = sender.currentTitle!

        if userIsInTheMiddleOfTypingNumber {
            if (digit == "." && display.text!.rangeOfString(".") != nil) {
                return
            }
            display.text = display.text! + digit
        }
        else  {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
        //        The way to escape variable in string
        //            println("digit=\(digit)")
        
        

    }
    
    
    
    
}

 