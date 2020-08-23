//
//  AppStateMainViewController.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/22.
//

import UIKit
import SwiftUI

class AppStateMainViewController: UIViewController {

    var updater = AppState.updater()
    var reader = AppState.reader()
    
    var disposeBag: [Subscription] = []
    var count = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let sub1 = reader.onChangeCount { [weak self]  in
            self?.didUpdateCount($0)
        }
        let sub2 = reader.onChangeSecond { [weak self] in
            self?.didUpdateSecond($0)
        }
        
        disposeBag = [sub1, sub2]
    }
    
    func didUpdateCount(_ count: Int) {
        print("count: \(count)")

        self.count = count
        labelCount.text = "\(count)"
        slider.value = Float(count)
        stepper.value = Double(count)
    }
    
    func didUpdateSecond(_ second: Int) {
        labelSeconds.text = "\(second)"
        if (second % 10 ) == 0 { removeChildView() }
        if (second % 10 ) == 5 { addChildView() }
    }
    
    private var childViewController: UIViewController?
    
    private func addChildView() {
        
        guard childViewController == nil else { return  }
        
        let childViewController = UIHostingController(
            rootView: AppStateChildView()
                .environmentObject(ChildViewState(reader))
        )
        
        childView.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        
        childView.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childViewController.view.widthAnchor.constraint(equalTo: childView.widthAnchor, multiplier: 0.5),
            childViewController.view.heightAnchor.constraint(equalTo: childView.heightAnchor, multiplier: 0.5),
            childViewController.view.centerXAnchor.constraint(equalTo: childView.centerXAnchor),
            childViewController.view.centerYAnchor.constraint(equalTo: childView.centerYAnchor)
        ])
        self.childViewController = childViewController
    }
    
    private func removeChildView() {
        guard let childViewController = childViewController else { return }
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.view.removeFromSuperview()
        self.childViewController = nil
    }
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelSeconds: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var childView: UIView!
    
    @IBAction func didChangeValue(_ sender: UIControl) {
        
        var changeCount = 0
        var changeAction: UpdateAction? = nil
        
        switch sender {
        case slider:
            let change = Int(slider.value) - self.count
            guard change != 0 else { return }

            changeCount = abs(change)
            changeAction = (change > 0) ? .countUp : .countDown

        case stepper:
            let change = Int(stepper.value) - self.count
            guard change != 0 else { return }
            changeCount = 1
            changeAction = (change > 0) ? .countUp : .countDown
            
        default: break
        }
        
        guard let action = changeAction else { return }
        for _ in 0..<changeCount {
            updater.send(action)
        }

    }
}

