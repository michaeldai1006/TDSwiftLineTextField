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

class TDSwiftLineTextField: UITextField {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    private func setupUI() {
        // TextField tint
        self.tintColor = TDSwiftLineTextFieldSyleSheet.color.tintColor
        self.textColor = TDSwiftLineTextFieldSyleSheet.color.textColor
        
        // Hide textField details
        self.borderStyle = .none
        
        // Add under line
        addBottomLine()
    }
    
    private func addBottomLine() {
        // Line instance
        let bottomLine = CALayer()
        
        // Line position
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - TDSwiftLineTextFieldSyleSheet.size.lineThickness, width: self.frame.width, height: TDSwiftLineTextFieldSyleSheet.size.lineThickness)
        
        // Line color
        bottomLine.backgroundColor = self.tintColor.cgColor
        
        // Add line
        self.layer.addSublayer(bottomLine)
    }
}


struct TDSwiftLineTextFieldSyleSheet {
    struct color {
        static let tintColor = UIColor(red:0.15, green:0.75, blue:0.85, alpha:1.0)
        static let standByColor = UIColor(red:0.92, green:0.92, blue:0.96, alpha:0.6)
        static let textColor = UIColor.darkText
    }
    
    struct size {
        static let lineThickness: CGFloat = 2.0
    }
}
