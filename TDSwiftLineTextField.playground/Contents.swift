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
