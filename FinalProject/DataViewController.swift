//
//  DataViewController.swift
//  FinalProject
//
//  Created by William Nesham on 7/18/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit

protocol DataViewDelegate: class {
    //TODO, add these.
    func createNewCostume()
    //    func removeCostume(costume: CostumeMeasurements)
    func removeCostume()
    func editCostume(selectedRow: Int)
}

class DataViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: DataViewDelegate?
    
    var model = CostumeModel()
    
    
    @IBOutlet weak var nameFieldOutlet: UITextField!
    @IBOutlet weak var descriptionFieldOutlet: UITextField!
    
    @IBOutlet weak var headOutlet: UITextField!
    @IBOutlet weak var wristOutlet: UITextField!
    @IBOutlet weak var tricepOutlet: UITextField!
    @IBOutlet weak var shoeOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UILabel!
    
    @IBOutlet weak var otherNotesOutlet: UITextView!
    
    
    //Back button won't save changes
    var costume = CostumeMeasurements(title: "Costume Name", subtitle: "Short Description", head: 0.0, wrist: 0.0, tricep: 0.0, shoe: 0.0, userNotes: "Additional Measurements or Notes:")
    
    @IBAction func saveMeasurementsOutlet(_ sender: UIButton) {
        //performSegue(withIdentifier: "saveButton", sender: self)
        removeCostume() //Makes sure there is only one costume with the given title at a time.
        createNewCostume()
    }
    
    @IBAction func removeMeasurementsAction(_ sender: Any) {
        removeCostume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        nameFieldOutlet.text = costume.title
        descriptionFieldOutlet.text = costume.subTitle
        headOutlet.text = String(costume.headCircumference )
        wristOutlet.text = String(costume.wristCircumference)
        tricepOutlet.text = String(costume.tricepCircumference)
        shoeOutlet.text = String(costume.shoeSize )
        otherNotesOutlet.text = costume.userNotes
        
        dateOutlet.text = formatter.string(from: costume.dateCreated)
        
        //Tap outside textFiled to dismis keyboard gesture
        self.view.addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:))))
        
        //Selectors to make the return button go to the next field.
        nameFieldOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        descriptionFieldOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        headOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        wristOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        tricepOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        shoeOutlet.addTarget(self, action: #selector(self.textFieldShouldReturn(_:)), for: UIControlEvents.editingDidEndOnExit)
        
        otherNotesOutlet.delegate = self as? UITextViewDelegate
        
        //Add buttons to the decimal pads
        headOutlet.addDoneCancelToolbar()
        wristOutlet.addDoneCancelToolbar()
        tricepOutlet.addDoneCancelToolbar()
        shoeOutlet.addDoneCancelToolbar()
        //And to dismiss keyboard for the notes field.
        otherNotesOutlet.addDoneMoveToolbar()
        
        //Keyboard listener
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        ////////////end didLoad
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    //Tried to get text view to add functionality to return button...
//    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text as NSString).rangeOfCharacter(from: CharacterSet.newlines).location == NSNotFound {
//            return true
//        }
//        textView.frame.origin.y -= 15
//        textView.resignFirstResponder()
//        textView.frame.origin.y -= 15
//        return false
//    }
    ////////

    @objc func keyboardWillChange(notification: Notification) {
        //reset view positions
        otherNotesOutlet.frame.origin.y = 16
        view.frame.origin.y = 0
    }
    //End
}


extension DataViewController: DataViewDelegate {
    func createNewCostume() {
        var nameTitle = nameFieldOutlet.text ?? "New Costume"
        if nameTitle.isEmpty {
            nameTitle = "New Costume"
        }
        let subtitle = descriptionFieldOutlet.text ?? "?"
        //I want them to stay optional fields.
        
        let head = Double(headOutlet.text!) ?? 0.0
        let wrist = Double(wristOutlet.text!) ?? 0.0
        let tricep = Double(tricepOutlet.text!) ?? 0.0
        let shoe = Double(shoeOutlet.text!) ?? 0.0
        
        let userNotes = otherNotesOutlet.text ?? "Additional Measurements or Notes:"
        
        var costumesArray: [CostumeMeasurements] = []
        //set model first
        if let decoded = UserDefaults.standard.object(forKey: "Costumes") as? Data {
            let decodedCostumes = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [CostumeMeasurements]
            costumesArray = decodedCostumes
        } else { //If data is empty
            UserDefaults.standard.set([], forKey: "Costumes")
            UserDefaults.standard.synchronize()
        }
        
        //Add new costume here
        costumesArray.append(CostumeMeasurements(title: nameTitle, subtitle: subtitle, head: head, wrist: wrist, tricep: tricep, shoe: shoe, userNotes: userNotes))
        
        //Persist Data
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: costumesArray)
        UserDefaults.standard.set(encodedData, forKey: "Costumes")
        UserDefaults.standard.synchronize()
    }
    func removeCostume() {
        var costumes: [CostumeMeasurements] = []
        //Make all costumes persisted.
        let decodedCostumes = model.getDecodedCostumes()
        
        //Add all but the costumes with the matching title
        for costume in decodedCostumes where costume.title != nameFieldOutlet.text {
            costumes.append(costume)
        }
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: costumes)
        UserDefaults.standard.set(encodedData, forKey: "Costumes")
        UserDefaults.standard.synchronize()
    }
    
    func editCostume(selectedRow: Int) {}
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        //resignFirstResponder
        view.endEditing(true)
        otherNotesOutlet.frame.origin.y = 16
        view.frame.origin.y = 0
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //resignFirstResponder
        view.endEditing(true)
        return true
    }
    
//Close extension
}

extension UITextField: DataViewDelegate {
    func createNewCostume() {}
    func removeCostume() {}
    func editCostume(selectedRow: Int) {}
    
    //Because the number pad doesn't have a return button.
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    
    @objc func cancelButtonTapped() {
        self.undoManager?.undo()
        self.resignFirstResponder()
    }
    
}

extension UITextView: UITextViewDelegate {
    
    //Because the text view's return key adds a new line, I figured I'd give the user another wat to resign the keyboard.
    func addDoneMoveToolbar(onDone: (target: Any, action: Selector)? = nil, onMove: (target: Any, action: Selector)? = nil) {
        
        let onMove = onMove ?? (target: self, action: #selector(moveButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Move", style: .plain, target: onMove.target, action: onMove.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
        self.frame.origin.y = 16
    }
    
    @objc func moveButtonTapped() {
        let displacement = self.font?.pointSize ?? 15
        
        self.frame.origin.y -= displacement
    }

}



