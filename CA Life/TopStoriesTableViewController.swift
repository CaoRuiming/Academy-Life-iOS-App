//
//  TopStoriesTableViewController.swift
//  CA Life
//
//  Created by Raymond Cao on 5/18/17.
//  Copyright © 2017 The Academy Life. All rights reserved.
//

import UIKit

class TopStoriesTableViewController: UITableViewController {

    //MARK: Properties
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSampleArticles()
        
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
        let cellIdentifier = "TopStoriesTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TopStoriesTableViewCell else { fatalError("The dequeued cell is not an instance of TopStoriesTableViewCell")}
        
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
    
    private func loadSampleArticles() {
        let defaultImage = UIImage(named: "DefaultImage")
        
        guard let article1 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://ca-life.org/")!) else { fatalError("Unable to instatiate article1") }
        guard let article2 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://ca-life.org/")!) else { fatalError("Unable to instatiate article2") }
        guard let article3 = Article(title: "Meow", photo: defaultImage!, content: "meowmeowmeowmeowmeowmeow", url: URL(string: "http://ca-life.org/")!) else { fatalError("Unable to instatiate article3") }
        articles += [article1, article2, article3]
    }

}
