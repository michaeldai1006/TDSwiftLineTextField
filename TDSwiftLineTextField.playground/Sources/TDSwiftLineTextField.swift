import Foundation
import UIKit

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
