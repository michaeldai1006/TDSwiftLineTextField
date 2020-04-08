import Foundation
import UIKit

@objc public protocol TDSwiftLineTextFieldDelegate: class {
    @objc optional func textFieldDidEndEditing(_ textField: UITextField)
    @objc optional func textFieldDidBeginEditing(_ textField: UITextField)
    @objc optional func textFieldDidChangeSelection(_ textField: UITextField)
    @objc optional func textFieldShouldClear(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldReturn(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    @objc optional func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    @objc optional func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

public enum TDSwiftLineTextFieldStatus {
    case standBy
    case highLighted
    case alerted
}

public class TDSwiftLineTextField: UITextField {
    
    var standByColor: UIColor!
    var alertedColor: UIColor!
    var bottomLine: CALayer!
    
    // TDSwiftLineTextFieldDelegate
    weak var lineTextFieldDelegate: TDSwiftLineTextFieldDelegate?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setupDelegate()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUnderLineFrame()
    }
    
    private func setupUI() {
        // TextField color
        self.tintColor = TDSwiftLineTextFieldSyleSheet.color.tintColor
        self.textColor = TDSwiftLineTextFieldSyleSheet.color.textColor
        self.standByColor = TDSwiftLineTextFieldSyleSheet.color.standByColor
        self.alertedColor = TDSwiftLineTextFieldSyleSheet.color.alertedColor
        
        // Hide textField details
        self.borderStyle = .none
        
        // Add under line
        addUnderLine()
    }
    
    private func setupDelegate() {
        // Implement UITextFieldDelegate
        self.delegate = self
    }
    
    private func addUnderLine() {
        // Line instance
        bottomLine = CALayer()
        
        // Line position
        updateUnderLineFrame()
        
        // Line color
        bottomLine.backgroundColor = self.standByColor.cgColor
        
        // Add line
        self.layer.addSublayer(bottomLine)
    }
    
    private func updateUnderLineFrame() {
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - TDSwiftLineTextFieldSyleSheet.size.lineThickness, width: self.frame.width, height: TDSwiftLineTextFieldSyleSheet.size.lineThickness)
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
    public func textFieldDidEndEditing(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        lineTextFieldDelegate?.textFieldDidChangeSelection?(textField)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return lineTextFieldDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return lineTextFieldDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Should end editing
        let shouldEndEditing = lineTextFieldDelegate?.textFieldShouldEndEditing?(textField) ?? true
        
        // Highlight textField if will end editing
        if (shouldEndEditing) { updateTextFieldStatus(.standBy) }
        
        // Should end edting result
        return shouldEndEditing
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // Should begin editing
        let shoudBeginEditing = lineTextFieldDelegate?.textFieldShouldBeginEditing?(textField) ?? true
        
        // Highlight textField if will begin editing
        if (shoudBeginEditing) { updateTextFieldStatus(.highLighted) }
        
        // Should begin edting result
        return shoudBeginEditing
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        lineTextFieldDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return lineTextFieldDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
