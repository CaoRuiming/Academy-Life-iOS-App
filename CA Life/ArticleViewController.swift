//
//  ArticleViewController.swift
//  CA Life
//
//  Created by Raymond Cao on 5/18/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var articleUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = articleUrl
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
