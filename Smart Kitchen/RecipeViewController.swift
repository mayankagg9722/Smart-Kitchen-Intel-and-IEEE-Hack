//
//  RecipeViewController.swift
//  Smart Kitchen
//
//  Created by Navdeesh Ahuja on 03/02/17.
//  Copyright © 2017 Navdeesh Ahuja. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var recipeTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if(Globals.requestDone)
        {
            return
        }
        
        ActivityViewIndicator.show(self.view, "Fetching Recipes")
        
        Globals.recipes.removeAll()
        Globals.keys.removeAll()
    
        Request.getRecipes(link: "", callback: {
        
            (err, response) in
            
            if let hits = response["hits"] as? [[String:Any]]
            {
                for hit in hits
                {
                    if let recipe = hit["recipe"] as? [String:Any]
                    {
                        if let recipeName = recipe["label"] as? String
                        {
                            if let recipeIngredientLines = recipe["ingredientLines"] as? [String]
                            {
                                Globals.recipes[recipeName] = recipeIngredientLines
                                Globals.keys.append(recipeName)
                                //Globals.recipes.append(tempDict)
                            }
                        }
                        
                    }
                }
            }
            self.recipeTableView.reloadData()
            ActivityViewIndicator.hide()
            
        })
        
        Globals.requestDone = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Globals.recipes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as! RecipeTableViewCell
        let recipeName = Globals.keys[indexPath.section]
        cell.recipeName.text = recipeName
        cell.recipeIngredientsSize.text = "Total Ingredients: " + String(describing: Globals.recipes[recipeName]!.count)
        cell.backgroundView = UIImageView(image: UIImage(named: "back"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Globals.selectedRecipe = indexPath.section
        self.performSegue(withIdentifier: "showIngredientsSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

}
