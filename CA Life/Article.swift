//
//  Article.swift
//  CA Life
//
//  Created by Raymond Cao on 5/18/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit

class Article {
    //MARK: Properties
    var title: String
    var photo: UIImage?
    var content: String
    var url: URL
    
    //MARK: Initialization
    init?(title: String, photo: UIImage, content: String, url: URL) {
        //Initialization will fail if there is no title or content
        if title.isEmpty || content.isEmpty {
            return nil
        }
        self.title = title
        self.photo = photo
        self.content = content
        self.url = url
    }
}
