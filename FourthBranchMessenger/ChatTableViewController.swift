//
//  ConversationTableViewController.swift
//  FourthBranchMessenger
//
//  Created by Matthew Tso on 5/3/16.
//  Copyright © 2016 Studio Tso. All rights reserved.
//

import UIKit
import CoreData

class ChatTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let cellIdentifier = "MessageCell"
    //private var messages = [Message]()
    private var sections = [NSDate:[MessageMO]]()
    private var dates = [NSDate]()
    var fetchedMessages = [MessageMO]()

    var fetchResultController: NSFetchedResultsController!
//    var context:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
//        var date = NSDate(timeIntervalSince1970: 1100000000)
        
        tableView.frame = CGRectZero

        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        tableView.scrollToBottom()
        
//        let addButton = UIBarButtonItem(title: "Add", style: .Plain, target: self, action: Selector("addMessage"))
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newMessage"))
        self.navigationItem.rightBarButtonItem = addButton
        
//        tableView.transform = CGAffineTransformMakeScale(1, -1);
        
        tableView.estimatedRowHeight = 44
        
        
        
        
        
        
        
        let fetchRequest = NSFetchRequest(entityName: "Message")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                fetchedMessages = fetchResultController.fetchedObjects as! [MessageMO]
            } catch {
                print(error)
            }
        }
        
        for message in fetchedMessages {
            addMessage(message)
        }
        
        
        
        
        
        
        
//        var localIncoming = true
//        for index in 0..<5{
//            let newMessage = Message()
//            newMessage.text = String(index)
//            
//            newMessage.incoming = localIncoming
//            localIncoming = !localIncoming
//            
//            newMessage.timestamp = date
//            
//            if index % 2 == 0{
//                //every other message will be a day later
//                date = NSDate(timeInterval: 60 * 60 * 24, sinceDate: date)
//            }
//            
////            messages.append(newMessage)
//            addMessage(newMessage)
//        }
        
//        let longIncomingMsg = Message()
//        longIncomingMsg.text = "This is a long message that should go over multiple lines to create a multi line label."
//        longIncomingMsg.incoming = true
//        longIncomingMsg.timestamp = NSDate(timeInterval: 70 * 60 * 24, sinceDate: date)
//        
//        let longOutgoingMsg = Message()
//        longOutgoingMsg.text = "This is a long message that should go over multiple lines to create a multi line label."
//        longOutgoingMsg.incoming = false
//        longOutgoingMsg.timestamp = NSDate(timeInterval: 70 * 60 * 24, sinceDate: date)
        
//        messages.append(longIncomingMsg)
//        messages.append(longOutgoingMsg)
//        addMessage(longIncomingMsg)
//        addMessage(longOutgoingMsg)
        
        
//        for eachMessage in messages {
//            print("\(eachMessage): Index is \(eachMessage.text!)")
//        }
//        tableView.scrollToBottom()
    }

//    override func viewWillAppear(animated: Bool) {
//        tableView.reloadData()
//        tableView.scrollToBottom()
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Message manipulation
    
    func addMessage(message:MessageMO){
//        guard let date = message.timestamp else {return}
        let date = message.timestamp
        
        let calendar = NSCalendar.currentCalendar()
        let startDay = calendar.startOfDayForDate(date)
        //we group messages by the day so we'll use the start of the day
        
        var messages = sections[startDay]
        if  messages == nil{
            dates.append(startDay)
            messages = [MessageMO]()
        }
        messages!.append(message)
        sections[startDay] = messages
    }
    
    func getMessages(section: Int)->[MessageMO]{
        let date = dates[section]
        return sections[date]!
    }
    
    func newMessage() {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = Int(arc4random() % 80 + 1)
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
   
        let text = randomString as String
        let incoming = Int(arc4random_uniform(2)) == 0 ? true : false
        let timestamp = NSDate()
        
//        let newMessage = MessageMO()
//        newMessage.text = text
//        newMessage.incoming = incoming
//        newMessage.timestamp = timestamp
//        addMessage(newMessage)
        
//        let newMessage = Message()
//        newMessage.text = randomString as String
//        newMessage.incoming = Int(arc4random_uniform(2)) == 0 ? true : false
//        newMessage.timestamp = NSDate()
//        addMessage(newMessage)
//        tableView.reloadData()

        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! MessageMO
            message.text = text
            message.timestamp = timestamp
            message.incoming = incoming
            
            do { try managedObjectContext.save()
            } catch {
                print(error)
                return
            }
        }
        tableView.reloadData()

        
        //        messages.append(newMessage)
        
        
        //        let indexPath = NSIndexPath(forRow: messages.count - 1, inSection: 0)
        //        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: false)
        
//        if tableView.numberOfRowsInSection(0) > 0{
//            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: tableView.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
//        }
//        
        tableView.scrollToBottom()
        
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dates.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getMessages(section).count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChatTableViewCell
        
        // Configure the cell...
//        cell.textLabel!.text = messages[indexPath.row].text
//        let message = messages[indexPath.row]
        let messages = getMessages(indexPath.section)
        
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message.text
        cell.incoming(message.incoming.boolValue)
//        cell.backgroundColor = UIColor.redColor()
        
//        cell.transform = CGAffineTransformMakeScale(1, -1);
        
        return cell
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        let paddingView = UIView()
        view.addSubview(paddingView)
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        paddingView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraints:[NSLayoutConstraint] = [
            paddingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
            paddingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor),
            dateLabel.centerXAnchor.constraintEqualToAnchor(paddingView.centerXAnchor),
            dateLabel.centerYAnchor.constraintEqualToAnchor(paddingView.centerYAnchor),
            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5),
            paddingView.widthAnchor.constraintEqualToAnchor(dateLabel.widthAnchor, constant: 10),
            view.heightAnchor.constraintEqualToAnchor(paddingView.heightAnchor)
        ]
        
        
        NSLayoutConstraint.activateConstraints(constraints)
        
//        if section == 0 {
//            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 25).active = true
//
//        } else {
//            paddingView.heightAnchor.constraintEqualToAnchor(dateLabel.heightAnchor, constant: 5).active = true
//
//        }
        
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        dateLabel.text = formatter.stringFromDate(dates[section])
        
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont.systemFontOfSize(13)
        
//        paddingView.layer.cornerRadius = 10
        paddingView.layer.masksToBounds = false
//        paddingView.backgroundColor = UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1.0)
        
//        if section == 0 {
//            view.backgroundColor = UIColor.grayColor()
//        }
        
        return view
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        return 0
    }
    
    
//    override func setEditing(editing: Bool, animated: Bool) {
//        if editing {
//            
//        }
    
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Fetched Results Controller Delegate Methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
//        switch type {
//        case .Insert:
//            if let _newIndexPath = newIndexPath {
//                print(newIndexPath)
//                print(_newIndexPath)
//                tableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
//            }
//        case .Delete:
//            if let _indexPath = indexPath {
//                tableView.deleteRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
//            }
//        case .Update:
//            if let _indexPath = indexPath {
//                tableView.reloadRowsAtIndexPaths([_indexPath], withRowAnimation: .Fade)
//            }
//            
//        default:
//            tableView.reloadData()
//        }
        
        
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
        let fetchRequest = NSFetchRequest(entityName: "Message")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                fetchedMessages = fetchResultController.fetchedObjects as! [MessageMO]
            } catch {
                print(error)
            }
        }
        
//        for message in fetchedMessages {
//            addMessage(message)
//        }
        addMessage(fetchedMessages.last!)
        tableView.reloadData()
        
    }
    
}


// MARK: - Scroll extension

extension UITableView {
    func scrollToBottom() {
        if self.numberOfSections > 1{
            let lastSection = self.numberOfSections - 1
            self.scrollToRowAtIndexPath(NSIndexPath(forRow:self.numberOfRowsInSection(lastSection) - 1, inSection: lastSection), atScrollPosition: .Bottom, animated: true)
        } else if self.numberOfSections == 1 && self.numberOfRowsInSection(0) > 0 {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0)-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
        }
    }
}


