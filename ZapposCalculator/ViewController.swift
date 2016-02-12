//
//  ViewController.swift
//  ZapposCalculator
//
//  Created by Gaurav Nijhara on 2/6/16.
//  Copyright © 2016 Gaurav Nijhara. All rights reserved.
//

import UIKit

enum OpType
{
    case ADD ,
    SUBSTRACT,
    MULTIPLY,
    DIVIDE,
    PERCENTAGE,
    CREATING_FLOAT,
    NATURAL_LOG,
    LOG_BASE10,
    SIN,
    SINH,
    COS,
    COSH,
    TAN,
    TANH,
    POW_UNARY,
    POW_BINARY,
    POW_10,
    POW_E,
    FACTORIAL,
    E,
    PI,
    NONE
}

enum Exceptions:ErrorType
{
    case DivideByZero,
    InfiniteValue,
    IllegalOperation
}

class ViewController: UIViewController {

    var result:NSMutableString = ""
        {
        didSet
        {
            let decimal:Double = result.doubleValue/Double(result.intValue);
            if(decimal == 1 || decimal.isNaN)
            {
                self.mainScreenLabel.text = "\(result.intValue)";
            }
            else
            {
                self.mainScreenLabel.text = "\(result.doubleValue)";
            }
        }
    }
    
    var currentNum:NSMutableString = ""
    {
        didSet
        {
            self.mainScreenLabel.text = currentNum as String;
        }
    }
    
    var power:Double?;
    var operationStack:[OpType] = [OpType]()
    var shouldUpdateResult:Bool = true;
    var shouldResetNumber = false;
    var shouldEmptyStack:Bool = false;
    var prevResult:[NSMutableString] = [NSMutableString]();
    
    @IBOutlet weak var landscapeLabel: UILabel!
    //@IBOutlet weak var calculationsLabel: CBAutoScrollLabel!
    @IBOutlet weak var mainScreenLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        currentNum = NSMutableString(string: "0");
        operationStack.append(.NONE)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    // MARK: Number Creation
    @IBAction func numberPressed(sender: AnyObject) {
        
        if (currentNum.length > 0 && currentNum.substringToIndex(1).compare("0") == .OrderedSame)
        {
            currentNum.deleteCharactersInRange(NSMakeRange(0,1));
        }

        currentNum = currentNum.stringByAppendingFormat("%d",sender.tag).mutableCopy() as! NSMutableString;
        
    }
    
    @IBAction func decimalPressed(sender: AnyObject) {
        
        let str:NSString? = currentNum.componentsSeparatedByString(".")[0];
        if ((str?.compare((currentNum as String)) == .OrderedSame))
        {
            currentNum = currentNum.stringByAppendingFormat("%@",".").mutableCopy() as! NSMutableString;
        }
        
        operationStack.append(.CREATING_FLOAT)
    }
    
    @IBAction func signChangePressed(sender: AnyObject) {
        
        if (currentNum.length > 0 && currentNum.substringToIndex(1).compare("-") == .OrderedSame)
        {
            currentNum = NSString(string: currentNum.substringFromIndex(1)).mutableCopy() as! NSMutableString
        }
        else
        {
            currentNum = NSMutableString(format:"-%@", currentNum);
        }

    }

    // MARK: Math Operations
    @IBAction func addPressed(sender: AnyObject) {
        
        if (currentNum.length > 0)
        {
            self.calculateResult(self)
        }
        
        
        if (operationStack.isEmpty || !isBinaryOperator(operationStack[operationStack.count-1]) )
        {
            operationStack.append(.ADD)
        }
        else
        {
            operationStack[operationStack.count-1] = .ADD
        }
        //self.updateResultOnLabel()
      
        
    }
    
    @IBAction func substractPressed(sender: AnyObject) {
       
        if (currentNum.length > 0)
        {
            self.calculateResult(self)
        }
        
        if (operationStack.isEmpty || !isBinaryOperator(operationStack[operationStack.count-1]) )
        {
            operationStack.append(.SUBSTRACT)
        }
        else
        {
            operationStack[operationStack.count-1] = .SUBSTRACT
        }


    }
    
    @IBAction func multiplyPressed(sender: AnyObject) {
        
        if (currentNum.length > 0)
        {
            self.calculateResult(self)
        }
        
        if (operationStack.isEmpty || !isBinaryOperator(operationStack[operationStack.count-1]) )
        {
            operationStack.append(.MULTIPLY)
        }
        else
        {
            operationStack[operationStack.count-1] = .MULTIPLY
        }

        //self.updateResultOnLabel()

       

    }
    
    @IBAction func dividePressed(sender: AnyObject) {
        
        if (currentNum.length > 0)
        {
            self.calculateResult(self)
        }
        
        if (operationStack.isEmpty || !isBinaryOperator(operationStack[operationStack.count-1]) )
        {
            operationStack.append(.DIVIDE)
        }
        else
        {
            operationStack[operationStack.count-1] = .DIVIDE
        }

        //self.updateResultOnLabel()
       

    }
    
    @IBAction func modulusPressed(sender: AnyObject) {

        operationStack.append(.PERCENTAGE)
        self.calculateResult(self)

    }
    
    @IBAction func calculateResult(sender: AnyObject) {
        
        do
        {
            if(sender as! NSObject == self)
            {
                try self.updateResultOnLabel()
            }
            else
            {
                while(!operationStack.isEmpty)
                {
                    try self.updateResultOnLabel();
                }
            }
        }
        catch
        {
            self.clearPressed(self);
            self.mainScreenLabel.text = "Error";
        }
    }

    @IBAction func factorialPressed(sender: AnyObject) {
        
        operationStack.append(.FACTORIAL)
        self.calculateResult(self)
    }
    
    @IBAction func logPressed(sender: AnyObject) {
        
        if(sender.tag == 0)
        {
            operationStack.append(.NATURAL_LOG)
        }
        else
        {
            operationStack.append(.LOG_BASE10)
        }
        self.calculateResult(sender)
    }
    
    @IBAction func tanhPressed(sender: AnyObject) {
        
        operationStack.append(.TANH)
        self.calculateResult(self)

    }
    
    @IBAction func tanPressed(sender: AnyObject) {
        
        operationStack.append(.TAN)
        self.calculateResult(self)

    }
    
    @IBAction func coshPressed(sender: AnyObject) {
        
        operationStack.append(.COSH)
        self.calculateResult(self)

    }
    
    @IBAction func cosPressed(sender: AnyObject) {
        
        operationStack.append(.COS)
        self.calculateResult(self)

    }
    
    @IBAction func sinPressed(sender: AnyObject) {
        
        operationStack.append(.SIN)
        self.calculateResult(self)

    }
    
    @IBAction func sinhPressed(sender: AnyObject) {
        
        operationStack.append(.SINH)
        self.calculateResult(self)

    }
    
    @IBAction func ePressed(sender: AnyObject) {
        
        operationStack.append(.E)
        self.calculateResult(self)

    }
    
    @IBAction func piPressed(sender: AnyObject) {
        
        operationStack.append(.PI)
        self.calculateResult(self)

    }
    
    @IBAction func evaluatePower(sender: AnyObject) {
        
        // many cases
        power = 0;
        switch(sender.tag)
        {
            case 0:
                power = 2;
                operationStack.append(.POW_UNARY)
                break;
            case 1:
                power = 3;
                operationStack.append(.POW_UNARY)
                break;
            case 2:
                power = -1;
                operationStack.append(.POW_UNARY)
                break;
            case 3:
                power = 1/2;
                operationStack.append(.POW_UNARY)
                break;
            case 5:
                power = 1/3;
                operationStack.append(.POW_UNARY)
                break;
            case 6:
                operationStack.append(.POW_E)
                break;
            case 8:
                operationStack.append(.POW_10)
                break;
            default:
                power = 1;
                break;
        }
        self.calculateResult(sender)

    }

    @IBAction func evaluatePowerBinary(sender: AnyObject) {
        
        self.calculateResult(sender);
        if(sender.tag == 0)
        {
            power = 1
        }
        else
        {
            power = -1
        }
        operationStack.append(.POW_BINARY)
    }
    // MARK: Utility
    
    @IBAction func undoPressed(sender: AnyObject) {
        
        
        if (currentNum.length > 0)
        {
            currentNum = NSString(string: currentNum.substringToIndex(currentNum.length-1)).mutableCopy() as! NSMutableString
        }


    }

    @IBAction func clearPressed(sender: AnyObject) {
        
        currentNum = NSMutableString(string: "0");
        result = NSMutableString(string: "");
        operationStack.removeAll();
        operationStack.append(.NONE)

    }
    
    func updateResultOnLabel() throws
    {
        let operation:OpType = operationStack.popLast()!
        
        switch (operation)
        {
            case .ADD:
                let res = result.doubleValue + currentNum.doubleValue;
                result = NSMutableString(format: "%lf", res)
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
            break
            case .SUBSTRACT:
                let res = result.doubleValue - currentNum.doubleValue;
                result = NSMutableString(format: "%lf", res)
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
            break
            case .MULTIPLY:
                let res = result.doubleValue * currentNum.doubleValue;
                result = NSMutableString(format: "%lf", res)
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
            break
            case .DIVIDE:
                if currentNum.integerValue == 0
                {
                    throw Exceptions.DivideByZero
                }
                
                let res = result.doubleValue / currentNum.doubleValue;
                result = NSMutableString(format: "%lf", res)
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
            break
            case .PERCENTAGE:
                var res:Double?
                if(currentNum.length > 0)
                {
                    if (result.doubleValue != 0.0)
                    {
                        res = (currentNum.doubleValue/100)*result.doubleValue;
                    }
                    else
                    {
                        res = (currentNum.doubleValue/100);
                    }
                }
                else
                {
                    res = result.doubleValue/100;
                }
                let formatter:NSNumberFormatter = NSNumberFormatter();
                formatter.numberStyle = .DecimalStyle;
                currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)
                break;
            case .NONE:
                result = NSMutableString(string: currentNum);
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
                break
            case .CREATING_FLOAT:
                let str:NSString? = currentNum.componentsSeparatedByString(".")[1];
                if(str?.length > 0)
                {
                    if(operationStack.isEmpty)
                    {
                        result = NSMutableString(string: currentNum);
                        currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
                    }
                }
                else
                {
                    result = NSMutableString(string: "\(currentNum.intValue)")
                }
                break;
            case .SIN:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = sinh(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)
                }
                break;
            case .SINH:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = cos(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                break;
            case .COS:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = cosh(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                break;
            case .COSH:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = sin(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                break;
            case .TAN:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = tan(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                break;
            case .TANH:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = tanh(currentNum.doubleValue*M_PI/180);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)
                }
                break;
            case .NATURAL_LOG:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = log(currentNum.doubleValue);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                break;
            case .LOG_BASE10:
                var res:Double?
                if(currentNum.integerValue != 0)
                {
                    res = log(currentNum.doubleValue)/log(10);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)

                }
                else
                {
                    throw Exceptions.InfiniteValue;
                }
                break;
            case .FACTORIAL:
                var res:Double?
                if(currentNum.integerValue > 0)
                {
                    res = getFactorial(currentNum.doubleValue);
                    let formatter:NSNumberFormatter = NSNumberFormatter();
                    formatter.numberStyle = .DecimalStyle;
                    currentNum  = NSMutableString(string: (formatter.stringFromNumber(NSNumber(double: res!)))!)
                }
                else
                {
                    throw Exceptions.IllegalOperation;
                }
                break;
            case .POW_UNARY:
                var res:Double?
                if(currentNum.integerValue >= 0)
                {
                    if (power < 0 && currentNum.integerValue == 0)
                    {
                        throw Exceptions.DivideByZero;
                    }
                    
                    if(power != 0)
                    {
                        res = pow(currentNum.doubleValue,power!);
                    }
                    else
                    {
                        
                    }
                    currentNum = NSMutableString(format: "%lf", res!)
                }
                else
                {
                    throw Exceptions.IllegalOperation
                }

                break;
            case .POW_BINARY:
                var res:Double?
                if(currentNum.integerValue >= 0)
                {
                    if(power == -1 && currentNum.integerValue == 0)
                    {
                        throw Exceptions.DivideByZero;
                    }

                    res = pow(result.doubleValue,pow(currentNum.doubleValue,power!));
                    result = NSMutableString(format: "%lf", res!)
                }
                else
                {
                     if (currentNum.integerValue < 0)
                    {
                        throw Exceptions.IllegalOperation;
                    }
                }
                currentNum.deleteCharactersInRange(NSMakeRange(0, currentNum.length));
                break;
            case .POW_10:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = pow(10,currentNum.doubleValue);
                }
                currentNum  = NSMutableString(format: "%lf", res!)
                break;
            case .POW_E:
                var res:Double?
                if(currentNum.length > 0)
                {
                    res = pow(M_E,currentNum.doubleValue)
                }
                currentNum  = NSMutableString(format: "%lf", res!)
                break;
            case .E:
                if(currentNum.length > 0)
                {
                    currentNum  = NSMutableString(format: "%lf", M_E)
                }
                break;
            case .PI:
                if(currentNum.length > 0)
                {
                    currentNum  = NSMutableString(format: "%lf", M_PI)
                }
                break;
            default:
                break
        }
    }
    
    func isBinaryOperator( op:OpType) -> Bool
    {
        return op == .ADD || op == .SUBSTRACT || op == .MULTIPLY || op == .DIVIDE || op == .POW_BINARY
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }


    func getFactorial(num:Double) -> Double
    {
        if(num == 0)
        {
            return 0.0;
        }
        else if (num == 1)
        {
            return 1.0;
        }
        else
        {
            return num*getFactorial(num-1);
        }
    }
}

