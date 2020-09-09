//
//  ContentView.swift
//  TextForm
//
//  Created by Simon Kim on 2020/09/08.
//  Copyright © 2020 DZPub.com. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {
    @State private var selection = 0
    @EnvironmentObject var userData: TextFormData

    var body: some View {
        TextInputFormDemo2(data: userData)
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TextFormData())
    }
}
#endif
