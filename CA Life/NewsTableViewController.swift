//
//  NewsTableViewController.swift
//  CA Life
//
//  Created by Raymond Cao on 5/18/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController, XMLParserDelegate {

    //MARK: Properties
    var articles = [Article]()
    
    //Parallel arrays to stored parsed XML data before making Article abojects
    var titles = [String]()
    var contents = [String]()
    var urls = [String]()
    
    //Variables for XML parser
    var currentElement:String = ""
    var passTitle:Bool = false
    var passURL:Bool = false
    var parser = XMLParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        parser = XMLParser(contentsOf: URL(string: "http://ca-life.org/category/news/feed/")!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        
        if success {
            print("parse succeeded")
            titles.remove(at: 0)
            print(titles)
            urls.remove(at: 0)
            print(urls)
        } else {
            print("parse failed")
        }
        
        //loadSampleArticles()
        loadArticles()
        
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElement=elementName;
        if(elementName=="title" || elementName=="link" || elementName=="content:encoded") {
            if (elementName == "title") {
                passTitle = true;
            }
            else if (elementName == "link") {
                passURL = true;
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElement="";
        if (elementName=="title" || elementName=="link" || elementName=="content:encoded") {
            if (elementName == "title") {
                passTitle = false;
            }
            else if (elementName == "link") {
                passURL = false
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if (passTitle) {
            if (string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "’" || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == " " || string.substring(to: string.index(string.startIndex, offsetBy: 1)) == "–") {
                titles[titles.count-1] = titles[titles.count-1]+string
            }
            else {
                titles.append(string)
            }
        }
        else if (passURL) {
            urls.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell number: \(indexPath.row)")
        performSegue(withIdentifier: "viewArticle", sender: articles[indexPath.row].url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewArticle" {
            print("preparing for segue viewArticle")
            let articleViewVC = segue.destination as! ArticleViewController
            //let i = self.indexPathForCell(cell)!.row
            articleViewVC.articleUrl = sender as! URL
        }
    }
    
    private func loadArticles(){
        let defaultImage = UIImage(named: "DefaultImage")
        for index in 0...(titles.count-1) {
            //articles.append(Article(title: titles[index], photo: defaultImage!, content: "meow", url: URL(string:urls[index])!))
            guard let newArticle = Article(title: titles[index], photo: defaultImage!, content: "meow", url: URL(string:urls[index])!) else { fatalError("Unable to instatiate article at index \(index)")}
            articles.append(newArticle)
        }
    }
    
    //Function below used only for testing and prototyping purposes
    private func loadSampleArticles() {
        let defaultImage = UIImage(named: "DefaultImage")
        
        guard let article1 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://ca-life.org/")!) else { fatalError("Unable to instatiate article1") }
        guard let article2 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://columbusacademy.org/")!) else { fatalError("Unable to instatiate article2") }
        guard let article3 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://python.org/")!) else { fatalError("Unable to instatiate article3") }
        articles += [article1, article2, article3]
    }

}
