//
//  AppStateChildViewController.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import UIKit
import SwiftUI

class State: ObservableObject {
    @Published var seconds: Int = 0
    
    private var subscription: StateStore<AppState>.Subscription?
    
    var stateReader: AppStateReadable! {
        didSet(old) {
            didChangeStateReader(from: old)
        }
    }
    
    func didChangeStateReader(from old: AppStateReadable?) {
        
        guard let reader = stateReader else { return }
        
        self.subscription = reader.onChange(\AppState.second) { [weak self] (state, keyPath) in
            guard let seconds = state[keyPath: keyPath] as? Int else { return }
            self?.seconds = seconds
        }
    }

}

struct AppStateChildView: View {
    @EnvironmentObject var state: State
    var body: some View {
        VStack {
            Text("Second View: \(state.seconds)").font(.system(size: 36))
            Text("Loaded by SecondView").font(.system(size: 14))
        }.background(Color.green)
    }
}


struct AppStateChildViewController_Previews: PreviewProvider {
    static var previews: some View {
        AppStateChildView()
            .environmentObject(State()) as! AppStateChildView

    }
}
