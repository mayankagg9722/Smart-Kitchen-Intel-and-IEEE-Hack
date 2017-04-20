//
//  ShowIngredientsViewController.swift
//  Smart Kitchen
//
//  Created by Navdeesh Ahuja on 03/02/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//

import UIKit

class ShowIngredientsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var recipeMainName: UILabel!

    @IBOutlet var ingredientsTableView: UITableView!
    @IBOutlet var ingredientsStaticLabel: UILabel!
    var ingredients = [String]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        ingredientsStaticLabel.backgroundColor = UIColor.groupTableViewBackground
        self.view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredients = Globals.recipes[Globals.keys[Globals.selectedRecipe]]!
        recipeMainName.text = Globals.keys[Globals.selectedRecipe]
        setStatus()
    }
    
    func setStatus()
    {
        let postDict = ["status":"true"]
        Request.post(link: "/status", postData: postDict, callback: {
            err, response in
            
            print(response)
            
        })
        
        let postIngredientsArray = Globals.recipes[Globals.keys[Globals.selectedRecipe]]
        var str = Globals.keys[Globals.selectedRecipe] + ","
        for i in postIngredientsArray!
        {
            str += i
            str += ","
        }
        
        let postIngredients = ["indegredient" : str]
        
        Request.post(link: "/indegredient", postData: postIngredients, callback: {
            err, response in
            
            print(response)
            
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowIngredientsTableViewCell") as! ShowIngredientsTableViewCell
        
        cell.ingrdient.text = ingredients[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    
    
    

}
