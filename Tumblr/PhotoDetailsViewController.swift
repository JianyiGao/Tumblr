//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Jianyi Gao 高健一 on 1/13/17.
//  Copyright © 2017 Jianyi Gao 高健一. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    var post: NSDictionary!

    
    @IBOutlet weak var postImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let baseUrl = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        
        if let photos = post.valueForKey("photos") as? [NSDictionary]{
            let imageUrlString = photos[0].valueForKeyPath("original_size.url") as? String
            let imageUrl = NSURL(string: imageUrlString!)!
            postImage.setImageWithURL(imageUrl)
            postImage.alpha = 0
            UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
                self.postImage.alpha = 1
                }, completion: nil)
        } else {
            postImage.image = nil
            
        }
        
        }
        
        // Do any additional setup after loading the view.



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
