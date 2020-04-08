//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Config background view
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.30, alpha:1.0)
        
        // TextField location
        let viewWidth: CGFloat = 200
        let viewHeight: CGFloat = 20.0
        var viewX: CGFloat { get { return self.view.frame.width / 2 - viewWidth / 2 } }
        var viewY: CGFloat { get { return self.view.frame.height / 2 - viewHeight / 2 } }
        
        // Config sample view
        let lineTextField = TDSwiftLineTextField(frame: CGRect(x: viewX, y: viewY - 2 * viewHeight, width: viewWidth, height: viewHeight))
        let lineTextField2 = TDSwiftLineTextField(frame: CGRect(x: viewX, y: viewY + 2 * viewHeight, width: viewWidth, height: viewHeight))
        backgroundView.addSubview(lineTextField)
        backgroundView.addSubview(lineTextField2)
                
        // Present background view
        self.view = backgroundView
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

@objc protocol TDSwiftLineTextFieldDelegate: class {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textFieldDidBeginEditing(_ textField: UITextField)
    func textFieldDidChangeSelection(_ textField: UITextField)
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

enum TDSwiftLineTextFieldStatus {
    case standBy
    case highLighted
    case alerted
}

class TDSwiftLineTextField: UITextField {
    
    var standByColor: UIColor!
    var alertedColor: UIColor!
    var bottomLine: CALayer!
    
    // TDSwiftLineTextFieldDelegate
    weak var lineTextFieldDelegate: TDSwiftLineTextFieldDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
        setupDelegate()
    }
    
    private func setupUI() {
        // TextField tint
        self.tintColor = TDSwiftLineTextFieldSyleSheet.color.tintColor
        self.textColor = TDSwiftLineTextFieldSyleSheet.color.textColor
        self.standByColor = TDSwiftLineTextFieldSyleSheet.color.standByColor
        self.alertedColor = TDSwiftLineTextFieldSyleSheet.color.alertedColor
        
        // Hide textField details
        self.borderStyle = .none
        
        // Add under line
        addBottomLine()
    }
    
    private func setupDelegate() {
        // Implement UITextFieldDelegate
        self.delegate = self
    }
    
    private func addBottomLine() {
        // Line instance
        bottomLine = CALayer()
        
        // Line position
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - TDSwiftLineTextFieldSyleSheet.size.lineThickness, width: self.frame.width, height: TDSwiftLineTextFieldSyleSheet.size.lineThickness)
        
        // Line color
        bottomLine.backgroundColor = self.standByColor.cgColor
        
        // Add line
        self.layer.addSublayer(bottomLine)
    }
    
    func updateTextFieldStatus(_ status: TDSwiftLineTextFieldStatus) {
        switch status {
        case .standBy:
            bottomLine.backgroundColor = standByColor.cgColor
        case .highLighted:
            bottomLine.backgroundColor = tintColor.cgColor
        case .alerted:
            bottomLine.backgroundColor = alertedColor.cgColor
        }
    }
}

extension TDSwiftLineTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidEndEditing(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidChangeSelection(textField)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return lineTextFieldDelegate?.textFieldShouldClear(textField) ?? true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return lineTextFieldDelegate?.textFieldShouldReturn(textField) ?? true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Should end editing
        let shouldEndEditing = lineTextFieldDelegate?.textFieldShouldEndEditing(textField) ?? true
        
        // Highlight textField if will end editing
        if (shouldEndEditing) { updateTextFieldStatus(.standBy) }
        
        // Should end edting result
        return shouldEndEditing
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Should begin editing
        let shoudBeginEditing = lineTextFieldDelegate?.textFieldShouldBeginEditing(textField) ?? true
        
        // Highlight textField if will begin editing
        if (shoudBeginEditing) { updateTextFieldStatus(.highLighted) }
        
        // Should begin edting result
        return shoudBeginEditing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        lineTextFieldDelegate?.textFieldDidEndEditing(textField, reason: reason)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return lineTextFieldDelegate?.textField(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}


struct TDSwiftLineTextFieldSyleSheet {
    struct color {
        static let tintColor = UIColor(red:0.15, green:0.75, blue:0.85, alpha:1.0)
        static let standByColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        static let alertedColor = UIColor.red
        static let textColor = UIColor.darkText
    }
    
    struct size {
        static let lineThickness: CGFloat = 2.0
    }
}
