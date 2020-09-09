//
//  TextFormData.swift
//  TextForm
//
//  Created by Simon Kim on 2020/09/10.
//  Copyright © 2020 DZPub.com. All rights reserved.
//

import Combine

final class TextFormData: ObservableObject  {
    @Published var title: String
    @Published var descriptionText: String
    @Published var tags: String
    
    init(title: String = "", descriptionText: String = "", tags: String = "") {
        self.title = title
        self.descriptionText = descriptionText
        self.tags = tags
    }
}
