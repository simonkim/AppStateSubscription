//
//  AppStateMainViewController.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/22.
//

import UIKit

class AppStateMainViewController: UIViewController {

    var stateUpdater: AppStateUpdatable!
    var stateReader: AppStateReadable!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        stateReader.onChange(\AppState.count) { [weak self] state, keyPath in
            guard let count = state[keyPath: keyPath] as? Int else { return }
            self?.didUpdateCount(count)
        }
        stateReader.onChange(\AppState.second) { [weak self] (state, keyPath) in
            guard let second = state[keyPath: keyPath] as? Int else { return }
            self?.labelSeconds.text = "\(second)"
        }
    }
    
    func didUpdateCount(_ count: Int) {
        print("count: \(count)")

        self.count = count
        labelCount.text = "\(count)"
        slider.value = Float(count)
        stepper.value = Double(count)
    }
    
    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelSeconds: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var childView: UIView!
    
    @IBAction func didChangeValue(_ sender: UIControl) {
        
        var changeCount = 0
        var changeAction: StateChange? = nil
        
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
            stateUpdater?.send(action)
        }

    }
}

