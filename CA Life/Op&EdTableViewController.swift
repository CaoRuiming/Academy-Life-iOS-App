//
//  Op&EdTableViewController.swift
//  CA Life
//
//  Created by Raymond Cao on 5/23/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Op_EdTableViewController: UITableViewController, XMLParserDelegate {
    
    //MARK: Properties
    var articles = [Article]()
    
    //Parallel arrays to store parsed XML data before making Article abojects
    var titles = [String]()
    var contents = [String]()
    var urls = [String]()
    
    //Variables for XML parser functions
    var currentElement:String = ""
    var passTitle:Bool = false
    var passURL:Bool = false
    var passContent:Bool = false
    var parser = XMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadArticles()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TableViewCell else { fatalError("The dequeued cell is not an instance of TopStoriesTableViewCell")}
        
        let article = articles[indexPath.row]
        
        // Configuring the cell...
        cell.cellTitle.text = article.title
        cell.cellImage.image = article.photo
        cell.cellContent.text = article.content
        cell.cellUrl = article.url
        
        return cell
    }
    
    
    //MARK: XMLParserDelegate Functions
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="title" || elementName=="link" || elementName=="pubDate") {
            if (elementName == "title") {
                passTitle = true;
            }
            else if (elementName == "link") {
                passURL = true;
            }
            else if (elementName == "pubDate") {
                passContent = true;
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if (elementName=="title" || elementName=="link" || elementName=="pubDate") {
            if (elementName == "title") {
                passTitle = false;
            }
            else if (elementName == "link") {
                passURL = false
            }
            else if (elementName == "pubDate") {
                passContent = false
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (passTitle) {
            if (string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "’" || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == " " || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "–" || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "“" || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "”" || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "s") {
                titles[titles.count-1] = titles[titles.count-1]+string
            }
            else {
                titles.append(string)
            }
        }
        else if (passURL) {
            urls.append(string)
        }
        else if (passContent) {
            contents.append(string.substring(to: string.index(string.startIndex, offsetBy: 16)))
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("You selected cell number: \(indexPath.row)")
        performSegue(withIdentifier: "viewArticle", sender: articles[indexPath.row].url)
    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewArticle" {
            let articleViewVC = segue.destination as! ArticleViewController
            articleViewVC.articleUrl = sender as! URL
        }
    }
    
    
    //MARK: Populating Table Cells
    
    func reloadArticles(){
        if isInternetAvailable() {
            //reset everything to prevent duplicate articles
            articles.removeAll()
            titles.removeAll()
            urls.removeAll()
            contents.removeAll()
            
            parser = XMLParser(contentsOf: URL(string: "http://ca-life.org/category/oped/feed/")!)!
            parser.delegate = self
            
            let success:Bool = parser.parse()
            
            if success {
                print("parse succeeded")
                titles.remove(at: 0)
                titles.remove(at: 0)
                //print(titles)
                urls.remove(at: 0)
                //print(urls)
                //print(contents)
            } else {
                print("parse failed")
            }
            loadArticles()
        }
    }
    
    func loadArticles(){
        let defaultImage = UIImage(named: "DefaultImage")
        for index in 0...(titles.count-1) {
            guard let newArticle = Article(title: titles[index], photo: defaultImage!, content: contents[index], url: URL(string:urls[index])!) else { fatalError("Unable to instatiate article at index \(index)")}
            articles.append(newArticle)
        }
    }
    @IBAction func refresh(_ sender: UIRefreshControl) {
        reloadArticles()
        tableView.reloadData()
        print("refresh succeeded")
        sender.endRefreshing()
    }
    
    //MARK: Check internet availability
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
