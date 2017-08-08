//
//  CalcViewController.swift
//  Study Buddy
//
//  Created by Gaby Ecanow on 8/5/17.
//  Copyright © 2017 Gaby Ecanow. All rights reserved.
//

import UIKit
import Foundation

class CalcViewController: UIViewController {
    
    @IBOutlet weak var equationLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    var equation = [String]()
    var lastWasOperator = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedNum(_ sender: UIButton) {
        equationLabel.text = equationLabel.text! + String(sender.tag)
        
        if lastWasOperator {
            equation.append(String(sender.tag))
        } else {
            equation[equation.count-1] = equation[equation.count-1] + String(sender.tag)
        }
        lastWasOperator = false
    }
    
    @IBAction func tappedDot(_ sender: Any) {
        if equation.count > 0 {
            equation[equation.count-1] = equation[equation.count-1] + "."
            lastWasOperator = false
        }
    }
    
    @IBAction func tappedOperator(_ sender: UIButton) {
        equationLabel.text = equationLabel.text! + sender.currentTitle!
        equation.append(sender.currentTitle!)
        lastWasOperator = true
    }
    
    func updateText() {
        equationLabel.text = ""
        for part in equation { equationLabel.text = equationLabel.text! + part }
    }
    
    @IBAction func tappedEquals(_ sender: Any) {
        if !hasAnError() {
            while equation.count > 1 {
                equation = breakDownEquation(from: equation)
            }
        }
        updateText()
    }
    
    @IBAction func breakDown(_ sender: Any) {
        if !hasAnError() {
            equation = breakDownEquation(from: equation)
        }
        updateText()
    }
    
    func hasAnError() -> Bool {
        var numOpen = 0, numClosed = 0
        for i in equation {
            if i == "(" { numOpen+=1 }
            if i == ")" { numClosed+=1 }
        }
        
        let diff = abs(numOpen-numClosed)
        if diff == 0 {
            return false
        } else {
            for _ in 0..<diff {
                if numOpen < numClosed { equation.insert("(", at: 0) }
                else { equation.append(")") }
            }
            return true
        }
    }
    
    func breakDownEquation(from: [String]) -> [String] {
        if from.contains("(") {
            var iEnd = Int(from.index(of: ")")!)
            
            var iStart = 1
            for i in 0..<iEnd {
                if from[i] == "(" { iStart = i+1 }
            }
            
            var tempArr = [String]()
            for part in iStart..<iEnd {
                tempArr.append(from[part])
            }
            
            let solved = solveSimple(equations: tempArr)
            if solved.count == 1 {
                iStart -= 1
                iEnd += 1
            }
            
            var returnArr = [String]()
            for part in 0..<iStart {
                returnArr.append(from[part])
            }
            returnArr.append(contentsOf: solved)
            for part in iEnd..<from.count {
                returnArr.append(from[part])
            }
            
            return returnArr
        } else {
            return solveSimple(equations: from)
        }
    }
    
    func solveSimple(equations: [String]) -> [String] {
        var outputArr = equations
        
        if outputArr.contains("^") {
            outputArr = findAndSolve(type: "^", fromArr: outputArr)
        } else if outputArr.contains("x") || outputArr.contains("/") {
            if indexOf(type: "x", inArr: outputArr) < indexOf(type: "/", inArr: outputArr) {
                outputArr = findAndSolve(type: "x", fromArr: outputArr)
            } else {
                outputArr = findAndSolve(type: "/", fromArr: outputArr)
            }
        } else if outputArr.contains("+")  || outputArr.contains("–") {
            if indexOf(type: "+", inArr: outputArr) < indexOf(type: "–", inArr: outputArr) {
                outputArr = findAndSolve(type: "+", fromArr: outputArr)
            } else {
                outputArr = findAndSolve(type: "–", fromArr: outputArr)
            }
        } else {}
        
        return outputArr
    }
    
    func indexOf(type: String, inArr: [String]) -> Int {
        if inArr.contains(type) {
            return inArr.index(of: type)!
        } else {
            return inArr.count + 100
        }
    }
    
    func findAndSolve(type: String, fromArr: [String]) -> [String] {
        let index = fromArr.index(of: type)!
        let numBefore = Double(fromArr[Int(index)-1])
        let numAfter = Double(fromArr[Int(index)+1])
        
        var newNum = 0.0
        if type == "^" {
            newNum = pow(numBefore!, numAfter!)
        } else if type == "x" {
            newNum = numBefore! * numAfter!
        } else if type == "/" {
            newNum = numBefore! / numAfter!
        } else if type == "+" {
            newNum = numBefore! + numAfter!
        } else if type == "–" {
            newNum = numBefore! - numAfter!
        } else {}
        
        return replaceRange(with: String(newNum), from: Int(index)-1, to: Int(index)+1, inside: fromArr)
    }
    
    func replaceRange(with: String, from: Int, to: Int, inside: [String]) -> [String] {
        var tempArr = [String]()
        for index in 0..<from {
            tempArr.append(inside[index])
        }
        tempArr.append(with)
        for index in (to+1)..<inside.count {
            tempArr.append(inside[index])
        }
        return tempArr
    }
    
    @IBAction func onTappedBack(_ sender: Any) {
        self.performSegue(withIdentifier: "UnwindToStudyRoom", sender: self)
    }
    
    @IBAction func onTappedClear(_ sender: Any) {
        equationLabel.text = ""
        equation = [String]()
        lastWasOperator = true
    }
    
    @IBAction func unwindToFndBuddies(segue: UIStoryboardSegue) {
        //unwind
    }
    
}
