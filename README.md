# AppStateSubscription
Experimental sketch of iOS/Swift App State Definition and Subscription

# Define Custom App State
```swift
struct AppState {
    var count: Int = 0
    var second: Int = 0
    var isNetworkReachable: Bool = false
}

protocol AppStateReadable {
    func onChangeCount(block: @escaping (_ value: Int) -> Void) -> Subscription
    func onChangeSecond(block: @escaping (_ value: Int) -> Void) -> Subscription
}

enum UpdateAction {
    case countUp
    case countDown
    case second(Int)
}

protocol AppStateUpdatable {
    mutating func send(_ change: UpdateAction)
}

extension AppState {
    private static var store = StateStore(AppState())

    static func reader() -> AppStateReadable {
        return store
    }
    
    static func updater() -> AppStateUpdatable {
        return store
    }
}
```

# Subscribe to update view state

```swift
class AppStateMainViewController: UIViewController {

    var reader = AppState.reader()
    
    var disposeBag: [Subscription] = []
    var count = 0
    var second = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let sub1 = reader.onChangeCount { [weak self]  in
            count = $0
            self?.countLabel.text = "\($0)"
        }
        let sub2 = reader.onChangeSecond { [weak self] in
            second = $0
            self?.secondLabel.text = "\($0)s"
        }
        
        disposeBag = [sub1, sub2]
    }
    ...
}
```

# Update state through a separate interface
```swift
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let second = Calendar.current.dateComponents(in: .current, from: Date()).second else { return }
            self?.updater.send(.second(second))
        })
```
