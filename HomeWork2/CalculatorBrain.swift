//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jiali Chen on 12/9/15.
//  Copyright (c) 2015 Self. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    
    private var opStack = [Op]()
    
    var description: String {
        get {
            var ori = opStack
            var des = ""
            while (!ori.isEmpty) {
            let (result, remainder) = describe(ori)
            if des != "" {
                des = result + "," + des
                }
            else {
                des = result
                }
            ori = remainder
            
        }
            return des
        }
    }
    
    private func describe(ops: [Op]) -> (result: String, remainingOps:[Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .BinaryOperation(let symbol, _):
                let first  = describe(remainingOps)
                let firstOperand = first.result
                let second = describe(first.remainingOps)
                var secondOperand = second.result
                if (secondOperand==" "){
                  secondOperand = "?"
                }
                let st = "\(secondOperand) \(symbol) \(firstOperand)"
                return (st, second.remainingOps)
                
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = describe(remainingOps)
                let operand = operandEvaluation.result
                let st = "\(symbol)(\(operand))"
                return (st, operandEvaluation.remainingOps)
                
            case .Constant(let symbol, _) :
                return (symbol, remainingOps)
                
            case .Variable(let symbol):
                return (symbol, remainingOps)
            }
        }
        return (" ",  ops)

    }
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double ->Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, Double)
        case Variable(String)

        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let symbol):
                    return symbol
                  }
            }
        }
    }
    private var knownOps = [String: Op]()
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("-"){ $1 - $0 })
        learnOp(Op.BinaryOperation("÷"){ $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.Constant("π", M_PI))
    }
    
    private func evaluate(ops: [Op]) -> (result : Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .BinaryOperation(_, let operation):
                 let first  = evaluate(remainingOps)
                 if let firstOperand = first.result {
                  let second = evaluate(first.remainingOps)
                    if let secondOperand = second.result {
                        return (operation(firstOperand, secondOperand), second.remainingOps)
                    }
                
                }

                
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .Constant(_, let value) :
                return (value, remainingOps)
                
            case .Variable(let symbol):
                let value = variableValues[symbol]
                // If no this symbol in the dict, value would be nil
                return (value, remainingOps)
            }
                    }
        return (nil,  ops)
    }
    
     func evaluate() -> Double?  {
        let (result, remainder) = evaluate(opStack)
        print ("\(opStack) = \(result) with \(remainder) left over ")
        return result
    }

    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    var variableValues = [String:Double]()
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
      
        if let value = variableValues[symbol] {
            opStack.append(Op.Operand(value))
            return evaluate()
        }
        else {
            return nil
        }
        
    }
    
    
    func performOperation(symbol : String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
       opStack = [Op]()
        variableValues = [String:Double]()
    }
    
}
