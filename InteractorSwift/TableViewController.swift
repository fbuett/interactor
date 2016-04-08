//
//  TableViewController.swift
//  InteractorSwift

import UIKit

class TableViewController: UITableViewController, EventListener {
    
    var events : NSMutableArray = []
    var interactor : Interactor = Interactor.sharedInteractor()
    /**
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
*/
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    @IBAction func startInteractor(sender: AnyObject) {
        if !interactor.isRunning() {
            Interactor.sharedInteractor().startInteractor()
            statusLabel.text = "Running"
        }
    }
    
    @IBAction func stopInteractor(sender: AnyObject) {
        if interactor.isRunning() {
            Interactor.sharedInteractor().stopInteractor()
            statusLabel.text = "Stopped"
            self.events.removeAllObjects()
            self.tableView.reloadData()
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    
    // MARK: - Table view data source
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.events = NSMutableArray()
        tableView.tableHeaderView = headerView
        statusLabel.text = ""
        
        interactor = Interactor.sharedInteractor()
        interactor.registerEventListener(self)
        if interactor.isRunning() {
            statusLabel.text = "Running"
        }

    }
    
    func eventTriggered(data: LBSEvent!) {
        self.events.insertObject(data, atIndex: 0);
        tableView.reloadData();
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let event: LBSEvent = self.events[indexPath.row] as! LBSEvent;
        cell.textLabel?.text = String(format: "%ld %@", (self.events.count - indexPath.row), event.name);
        let content : LBSEventContent = event.content.allObjects[0] as! LBSEventContent;
        cell.detailTextLabel?.text = content.value;
        
        if event.type == ZONE_ENTRY {
            cell.textLabel?.textColor = UIColor(colorLiteralRed:6.0/255.0, green:143.0/255.0, blue:26.0/255.0, alpha:1);
        }
        else if event.type == ZONE_EXIT {
            cell.textLabel?.textColor = UIColor.redColor();
        }
        
        return cell
    }

}
