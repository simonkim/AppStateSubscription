//
//  TextInputFormDemo1.swift
//  TextForm
//
//  Created by Simon Kim on 2020/09/09.
//  Copyright © 2020 DZPub.com. All rights reserved.
//

import SwiftUI
import Combine

struct TextInputFormDemo1: View {
    @ObservedObject var userData: TextFormData
    @ObservedObject private var keyboard = KeyboardResponder()

    @State var isDragging = false {
        didSet {
            if isDragging {
                UIApplication.shared.dismissKeyboard()
            }
        }
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { _ in self.isDragging = true }
            .onEnded { _ in self.isDragging = false }
    }
    
    var body: some View {
        Form {
            
            Section {
                
                Group {
                    ZStack(alignment: .leading) {
                        if userData.title.isEmpty {
                            Text("Placeholder")
                                .foregroundColor(Color(.green))
                                .frame(alignment: .leading)
                        }
                        TextField("", text: $userData.title)
                            .foregroundColor(Color(.lightText))
                    }
                    .frame(height: 32)
                    
                    TextField("Some", text: .constant("Some"))
                        .frame(height: 32)

                    VStack {
                        MultilineTextView(text: $userData.descriptionText)
                            .frame(height: 120)
                            .background(Color.bg.l2)
                    }
                    
                    TextField("Some", text: .constant("Some"))
                        .frame(height: 32)
                }
                .background(Color.bg.l2)
                .padding(.vertical)
            }
            .listRowInsets(EdgeInsets())
            .padding(.leading, 16)
            .padding(.trailing, 16)
            .background(Color.bg.l1)

        }
        .modifier(AdaptsToKeyboard())
        .foregroundColor(Color(.lightText))
        .background(Color(.darkGray))
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().separatorStyle = .none
        }
        .onTapGesture {
            UIApplication.shared.dismissKeyboard()
        }
    }
}

struct MultilineTextView: UIViewRepresentable {
    @Binding var text: String
    var backgroundColor: UIColor
    var shouldBecomeFirstResponder: Bool
    
    init(text: Binding<String>, backgroundColor: UIColor = .clear, shouldBecomeFirstResponder: Bool = false) {
        self._text = text
        self.backgroundColor = backgroundColor
        self.shouldBecomeFirstResponder = shouldBecomeFirstResponder
        
    }
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.font = UIFont.systemFont(ofSize: 17)
        view.delegate = context.coordinator
        view.backgroundColor = self.backgroundColor
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if shouldBecomeFirstResponder && !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var didBecomeFirstResponder: Bool = false
    }
}



struct TextInputForm_Previews: PreviewProvider {
    static var previews: some View {
        TextInputFormDemo1(userData: TextFormData(
            title: "Title",
            descriptionText: "Hello"
        ))
    }
}
