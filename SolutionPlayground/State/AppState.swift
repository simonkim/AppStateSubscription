//
//  AppState.swift
//  SolutionPlayground
//
//  Created by Simon Kim on 2020/08/23.
//

import Foundation


struct AppState {
    var count: Int = 0
    var second: Int = 0
    var isNetworkReachable: Bool = false
}

extension AppState: DiffableState {
    func changedKeyPaths(from old: Self) -> [PartialKeyPath<Self>] {
        guard self != old else { return [] }

        var result: [PartialKeyPath<Self>] = []
        result += intKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        result += boolKeyPaths.filter { self[keyPath: $0] != old[keyPath: $0] }
        return result
    }

    var intKeyPaths: [KeyPath<Self, Int>] { [\.count, \.second] }
    var boolKeyPaths: [KeyPath<Self, Bool>] { [\.isNetworkReachable] }

}

protocol AppStateReadable {
    func onChange(_ keyPath: PartialKeyPath<AppState>,
                  block: @escaping (_ state: AppState, _ keyPath: PartialKeyPath<AppState>) -> Void)
}

extension StateStore: AppStateReadable where State == AppState {}

enum StateChange {
    case countUp
    case countDown
    case second(Int)
}

protocol AppStateUpdatable {
    mutating func send(_ change: StateChange)
}

extension StateStore: AppStateUpdatable where State == AppState {
    func send(_ change: StateChange) {
        var state = self.state
        switch change {
        case .countUp:
            state.count += 1
        case .countDown:
            state.count -= 1
            
        case .second(let value):
            state.second = value
        }
        self.state = state
    }
    
}
