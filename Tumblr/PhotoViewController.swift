//
//  PhotoViewController.swift
//  Tumblr
//
//  Created by Jianyi Gao 高健一 on 1/7/17.
//  Copyright © 2017 Jianyi Gao 高健一. All rights reserved.
//

import UIKit
import AFNetworking


class PhotoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var posts: [NSDictionary] = []
    var url: NSURL?
    var isMoreDataLoading = false

    @IBOutlet weak var photoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        photoTableView.insertSubview(refreshControl, atIndex: 0)
        
        url = NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(
            request as NSURLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.photoTableView.reloadData()
                    }
                }
        });
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        let myRequest = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
            
            self.photoTableView.reloadData()
            refreshControl.endRefreshing()
        });
        
        task.resume()
    }
    
    func loadMoreData(){
        let myRequest = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(myRequest, completionHandler: { (data, response, error) in
            
            // Update flag
            self.isMoreDataLoading = false
            
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.photoTableView.reloadData()
            
            
        });
        task.resume()
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = photoTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - photoTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && photoTableView.dragging) {
                isMoreDataLoading = true
                
                loadMoreData()
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 240
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let post = posts[indexPath.row]
        if let photos = post.valueForKey("photos") as? [NSDictionary]{
             let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            let imageUrl = NSURL(string: imageUrlString!)!
            cell.photoImageView.setImageWithURL(imageUrl)
        } else {
            cell.photoImageView.image = nil
            
        }
        // Configure YourCustomCell using the outlets that you've defined.
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! PhotoDetailsViewController
        let indexPath = photoTableView.indexPathForCell(sender as! UITableViewCell)
        let post = posts[indexPath!.row] as NSDictionary
        
        destinationViewController.post = post
    
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}




