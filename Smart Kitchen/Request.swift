//
//  Request.swift
//  Vitop
//
//  Created by Navdeesh Ahuja on 27/01/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//

import UIKit

class Request
{
    static var domainName = "http://vitmantra.feedveed.com:8080"
    static func post(link: String, postData:Dictionary<String, String>, callback: @escaping (String, Dictionary<String, Any>) -> Void) {
        
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        //print(NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue) ?? "mmmm")
        if(jsonData == nil)
        {
            callback("errorInParsingJson", [:])
            return
        }
        
        let url = URL(string: domainName+link)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = jsonData
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "nnn")
            
            if(error != nil || data == nil || response == nil)
            {
                DispatchQueue.main.async {
                    callback("errorInInternet", [:])
                }
                return
            }
            DispatchQueue.main.async {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: [])
                if(jsonObject == nil)
                {
                    callback("errorInParsingResponseJson", [:])
                    return
                }
                
                callback("OK", jsonObject as! [String:Any])
            }
            
        }
        
        task.resume()
        
    }
    
    
    static func getRecipes(link: String, callback: @escaping (String, Dictionary<String, Any>) -> Void) {
        
        let url = URL(string: ("https://edamam-recipe-search-and-diet-v1.p.mashape.com/search?_app_id=test&_app_key=test&q="+Globals.query))
        //print(url)
        
        var request = URLRequest(url: url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Q3ZyBjNHHzmsho6bNaFyT7VZwHoBp1O1xWsjsn24Y6D1okGCr2", forHTTPHeaderField: "X-Mashape-Key")
        
        request.timeoutInterval = 30
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if(error != nil || data == nil || response == nil)
            {
                DispatchQueue.main.async {
                    callback("errorInInternet", [:])
                }
                return
            }
            DispatchQueue.main.async {
                let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: [])
                if(jsonObject == nil)
                {
                    callback("errorInParsingResponseJson", [:])
                    return
                }
                
                callback("OK", jsonObject as! [String:Any])
            }
            
        }
        
        task.resume()
        
    }
}
