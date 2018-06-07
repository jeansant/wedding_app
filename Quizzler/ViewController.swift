//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    
    //The UI Elements from the storyboard   are already linked up for you.
    @IBOutlet weak var questionLabel: UILabel?
    @IBOutlet weak var scoreLabel: UILabel?
    @IBOutlet var progressBar: UIView?
    @IBOutlet weak var progressLabel: UILabel?
    
    //Place your instance variables here
    
    let allQuestions = QuestionBank()
    var pickedAnswer : Bool = false
    var questionNumber : Int = 0
    var score : Int = 0
    
    var yourScore : Int = 0
    var scoreKey : String = ""

    var ref: DatabaseReference!
    
    
    // This gets called when the UIViewController is loaded into memory when the app starts
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        updateUI()
        
    }

    // Nothing to modify here. This gets called when the system is low on memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This action gets called when either the true or false button is pressed.
    @IBAction func answerPressed(_ sender: AnyObject) {
    
        if sender.tag == 1 {
            pickedAnswer = true
        }
        
        else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer()
        
        questionNumber = questionNumber + 1
        
        updateUI()
        
    }
    
    // This method will update all the views on screen (progress bar, score label, etc)
    func updateUI() {
        
        progressBar?.frame.size.width = (view.frame.size.width / 13) * CGFloat(questionNumber)
        
        progressLabel?.text = String(questionNumber) + "/13"
        
        scoreLabel?.text = "Score: " + String(self.score)
        
        nextQuestion()
    }
    
    

    //This method will update the question text and check if we reached the end.
    func nextQuestion() {
        
        if questionNumber <= 12 {
            
            questionLabel?.text = allQuestions.list[questionNumber].questionText
            
        }
            
        else {
            
            sendScoreToDB()
            
            
            let alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over? ", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { UIAlertAction in
                
                self.startOver()
                
            })
            
            let showScores = UIAlertAction(title: "View Scores", style: .default, handler:
                { UIAlertAction in
            
                self.performSegue(withIdentifier: "goToScores", sender: self)
                    
            })
            
            alert.addAction(showScores)
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //This method will check if the user has got the right answer.
    func checkAnswer() {
        
        let correctAnswer = allQuestions.list[questionNumber].answer
        
        if correctAnswer == pickedAnswer {

            ProgressHUD.showSuccess("Correct!")
            
            self.score = self.score + 1
        }
            
        else {
            
            ProgressHUD.showError("Wrong!")
        }
    }
    
    //This method will wipe the board clean, so that users can retake the quiz.
    func startOver() {
       
        questionNumber = 0
        self.score = 0
        
        updateUI()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToScores") {
            
            let vc = segue.destination as! SecondViewController
            
            vc.score = self.yourScore
            
            vc.scoreKey = self.scoreKey
            
            //print(self.score)
            
        }
        
    }
    
    func sendScoreToDB(){
        
        if(FirebaseApp.app() == nil){
         
         FirebaseApp.configure()
         
         }
        
        let scoreDB = Database.database().reference(fromURL:"https://flash-chat-2bbf2.firebaseio.com/")
        
        scoreDB.childByAutoId().setValue(score)
        
        scoreDB.observeSingleEvent(of: .value, with: { snapshot in
            
            if !snapshot.exists() { return }
            
            let highScore = snapshot.value! as? Dictionary <String,Int>
            
            let valuesArray = Array(highScore!.values)
            
            let keysArray = Array(highScore!.keys)
            
            self.yourScore = valuesArray.sorted().last!
            
            self.scoreKey = keysArray.sorted().last!
            
            
        })
        
        
    }
    
    
    
    
}   // End of the class

