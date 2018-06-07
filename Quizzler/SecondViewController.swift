//
//  SecondViewController.swift
//  Quizzler
//
//  Created by Jean Santiuste on 5/28/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let list = [" \(scoreKey) : \(score) "]
        
        return(list.count)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let list = [" \(scoreKey) : \(score) "]
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = list[indexPath.row]
        
        return(cell)
        
    }
    
    
    
    
    // Initialization of variables
    
    var score : Int = 0
    var scoreKey : String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //let list = ["\(scoreKey):\(score)"]
        
        //print("\(scoreKey)'s high score is: \(score)")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "goToHome", sender: self)
        
        }

    

}
