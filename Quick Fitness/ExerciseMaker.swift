//
// ExerciseMaker.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/18/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit

class ExerciseMaker: UIViewController {

	@IBOutlet weak var exerciseNameField: UITextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	func exerciseCreationFailed(message: String) {
		let controller = UIAlertController(
			title: "Failed to create exercise",
			message: message,
			preferredStyle: .alert)
		controller.addAction(UIAlertAction(
		title: "OK",
		style: .default,
		handler: nil))
		present(controller, animated: true, completion: nil)
	}
	
	@IBAction func saveExercisePressed(_ sender: Any) {
		guard let exerciseName: String = exerciseNameField.text, !exerciseName.isEmpty else {
			self.exerciseCreationFailed(message: "Please enter an exercise name")
			return
		}
		
		// Check if exercise name is duplicate
		do {
			try _ = CoreDataManager.fetchExercise(name: exerciseName)
		} catch FetchError.itemNotFound {
			// Save exercise in core data
			CoreDataManager.storeExercise(name: exerciseName)
			return
		} catch FetchError.duplicateItemsFound {
			self.exerciseCreationFailed(message: "Multiple exercises of the same name already exist!")
			return
		} catch {
			CoreDataManager.logErrorAndAbort(error: error)
		}
		
		self.exerciseCreationFailed(message: "Exercise already exists!")
	}
	
	// code to enable tapping on the background to remove software keyboard
	
	func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
