//
//  TwitterSignInViewController.swift
//  Scrambled Messenger
//
//  Created by Aleksander Makedonski on 12/5/17.
//  Copyright © 2017 Aleksander Makedonski. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class TwitterSignInViewController: UIViewController{
    
    var twitterLoginButton: TWTRLogInButton!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       
        print("Adding the Twitter login button to the view hierarchy....")
        
        self.twitterLoginButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        
        
        // Swift
        /**
        let store = Twitter.sharedInstance().sessionStore
        
        let lastSession = store.session()
        let sessions = store.existingUserSessions()
        let specificSession = store.session(forUserID: "123")
        

        store.saveSession(withAuthToken: "", authTokenSecret: "", completion: {
            
            (authSession: TWTRAuthSession?, error: Error?) in
            
        
        })
        **/
        
        print("Twitter button added to the view hierarchy \(twitterLoginButton.debugDescription)....")
        twitterLoginButton.translatesAutoresizingMaskIntoConstraints = false
       twitterLoginButton.center = self.view.center
        
       
        self.view.addSubview(twitterLoginButton)
        
     
        
        /**
        let client = TWTRAPIClient()
        
        // make requests with client
        
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            // make requests with client
            
            client.loadTweet(withID: "20") { (tweet, error) -> Void in
                // handle the response or error
            }
            
            let tweetIDs = ["20", "510908133917487104"]
            client.loadTweets(withIDs: tweetIDs) { (tweets, error) -> Void in
                // handle the response or error
            }
            
            let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
            let params = ["id": "20"]
            var clientError : NSError?
            
            let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
            
            client.loadUser(withID: "12") { (user, error) -> Void in
                // handle the response or error
            }
            
            client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                if connectionError != nil {
                    print("Error: \(connectionError)")
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print("json: \(json)")
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            }
        }
        
       **/
        

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        self.didMove(toParentViewController: parent)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
