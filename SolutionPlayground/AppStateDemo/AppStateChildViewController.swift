//
//  AppStateChildViewController.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import UIKit
import SwiftUI

class ChildViewState: ObservableObject {
    @Published var seconds: Int = 0
    
    let stateReader: AppStateReadable
    private var subscription: Subscription!
    
    init(_ stateReader: AppStateReadable) {
        self.stateReader = stateReader
        self.subscription = stateReader.onChangeSecond { [weak self] in
            self?.seconds = $0
        }
    }
}

struct AppStateChildView: View {
    @EnvironmentObject var state: ChildViewState
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
            .environmentObject(ChildViewState(AppState.reader())) as! AppStateChildView

    }
}
