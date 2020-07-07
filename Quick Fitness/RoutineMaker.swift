//
// RoutineMaker.swift: HillAndrew-Project
// EID: awh772
// Course: CS371L
//
// Created by andrewhill on 6/18/20
// Copyright 2020 Andrew Hill. All rights reserved.
//

import UIKit
let exerciseCellID: String = "ExerciseCell"
let addExerciseCellID: String = "AddExerciseCell"

class RoutineMaker: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var routineNameField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
	// TODO: Fetch only exercises related to this routine
	var exercises: [Exercise] = CoreDataManager.fetchAllExercises()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.delegate = self
        tableView.dataSource = self
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return exercises.count + 1
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
		let row = indexPath.row
		
		if row == exercises.count {
			return loadAddExerciseCell(tableView, cellForRowAt: indexPath)
		} else {
			return loadExerciseCell(tableView, cellForRowAt: indexPath)
		}
    }
    
	func loadAddExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: addExerciseCellID, for: indexPath)
		cell.textLabel?.text = "Add Exercise"
		return cell
	}
	
	func loadExerciseCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: exerciseCellID, for: indexPath)
		let exercise = exercises[indexPath.row]
		cell.textLabel?.text = exercise.name
		return cell
	}
	
	// TODO: Add option to delete cell
	
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
