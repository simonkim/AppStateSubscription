//
//  TextInputFormDemo2.swift
//  TextForm
//
//  Created by Simon Kim on 2020/09/10.
//  Copyright © 2020 DZPub.com. All rights reserved.
//

import SwiftUI

extension Color {
    struct bg {
        static let l0 = Color(.darkGray)
        static let l1 = Color(.gray)
        static let l2 = Color(.systemGray)
        static let l3 = Color(.systemGray2)
    }

}

struct TextInputFormDemo2: View {
    static var test:String = ""
    static var testBinding = Binding<String>(get: { test }, set: { test = $0 } )
    
    @ObservedObject var data: TextFormData
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("SwiftUI")
                    .font(.title)
                
                TextField("", text: $data.title)
                    .frame(height: 32)
                    .placeHolder(Text("Title"), show: data.title.isEmpty)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .background(Color.bg.l1)

                MultilineTextField("Description", text: $data.descriptionText)
                    .frame(height: 120)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .background(Color.bg.l1)

                Text("Privacy")
                HStack(spacing:5) {
                    Text("Private")
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "chevron.down")
                    }
                    .contextMenu {
                        Button(action: { }) {
                            Text("Public")
                            Image(systemName: "globe")
                        }

                        Button(action: { }) {
                            Text("Private")
                            Image(systemName: "location.circle")
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                TextField("", text: $data.tags)
                    .frame(height: 32)
                    .placeHolder(Text("Tags"), show: data.tags.isEmpty)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .background(Color.bg.l1)

            }
            .padding(.horizontal, 16)
        }
        .foregroundColor(Color(.white))
        .background(Color.bg.l0)
        .modifier(AdaptsToKeyboard())
        .onTapGesture {
            UIApplication.shared.dismissKeyboard()
        }
        
    }
}

#if DEBUG
struct TextInputFormDemo2_Previews: PreviewProvider {
    static var previews: some View {
        TextInputFormDemo2(data: TextFormData())
    }
}
#endif
