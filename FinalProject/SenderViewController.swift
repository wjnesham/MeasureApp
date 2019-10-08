//
//  SenderViewController.swift
//  FinalProject
//
//  Created by William Nesham on 7/18/18.
//  Copyright © 2018 UMSL. All rights reserved.
//

import UIKit
import MessageUI

class SenderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let model = CostumeModel()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.getDecodedCostumes().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return model.getTitles()?[row] ?? "No Costumes to show."
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedCostume = model.getDecodedCostumes()[row]
        model.selectedRow = row //Only for this view's instance of model.
    }
    
    
    private enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        
        init?(type: String) {
            switch type.lowercased() {
            case "jpg": self = .jpg
            case "png": self = .png
            default:
                return nil
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            alert(title: "Did Not Send", msg: "Message was canceled.")
        case MFMailComposeResult.saved:
            alert(title: "Saved Message", msg: "Message was saved somewhere.")
        case MFMailComposeResult.sent:
            alert(title: "Message Sent!", msg: "Your message was sent successfully!")
        case MFMailComposeResult.failed:
            alert(title: "Message Failed to Send", msg: "Blame Xcode :P")
        
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func showMailComposerWith(userImage: String) {
//        if MFMailComposeViewController.canSendMail() {
            let subject = "Costume Measurements"
            let messageBody =
            """
            Sent from my measurements app on my iPhone.

            Title: \(model.getDecodedCostumes()[model.selectedRow].title)
            Description: \(model.getDecodedCostumes()[model.selectedRow].subTitle ?? "My costume")
            Head Circumference: \(model.getDecodedCostumes()[model.selectedRow].headCircumference )
            Wrist Circumference: \(model.getDecodedCostumes()[model.selectedRow].wristCircumference )
            Tricep Circumference: \(model.getDecodedCostumes()[model.selectedRow].tricepCircumference )
            Shoe Size: \(model.getDecodedCostumes()[model.selectedRow].shoeSize )
            Measured: \(model.getDecodedCostumes()[model.selectedRow].dateCreated)
            
        *\(model.getDecodedCostumes()[model.selectedRow].userNotes ?? "Additional Measurements or Notes:")
                Measurements are in ( inches ).
                Shoe size is in *Country(  ) *Mens/Womens(  ).
            
    """
            let recipients: [String] = []
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(messageBody, isHTML: false)
            mailComposer.setToRecipients(recipients)
            
//            let userAttachment = userImage.components(separatedBy: ".")
//            let fileName = userAttachment[0]
//            let fileExtension = userAttachment[1]
//
//            if let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) {
        
//                if let fileData = NSData(contentsOfFile: userImage), let mimeType = MIMEType(type: fileExtension) {
//                    mailComposer.addAttachmentData(fileData as Data, mimeType: mimeType.rawValue, fileName: fileName)
        
                    if let image = userImageView.image {
                        //Decode
                        //Convert image to data
                        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
                        
                        //Add to email
                        mailComposer.addAttachmentData(imageData as Data, mimeType: "png", fileName: userImageView.image?.accessibilityIdentifier ?? "Doge")
                        
                        //Alerts if can't send
                        if MFMailComposeViewController.canSendMail() {
                            self.navigationController?.present(mailComposer, animated: true, completion: nil)
                        }
//                    present(mailComposer, animated: true, completion: nil)
//                    self.navigationController.presentViewController(mailComposer, animated: true, completion: nil)
                }
//            }
         else {
//            alert(title: "Image Not Recognized", msg: "Tap OK to go back. Then tap 'Add Image' to select an image.")
//            present(mailComposer, animated: true, completion: nil)
            if MFMailComposeViewController.canSendMail() {
                self.navigationController?.present(mailComposer, animated: true, completion: nil)
            } else {
                alert(title: "Device not Registered.", msg: "This device has not been setup to send emails.")
                }
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var costumePicker: UIPickerView!
    
    
    
    @IBAction func addImageButton() {
        let image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
//        userImageView.image? = image
        
        present(image, animated: true) {
            //TODO
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImageView.image = image
            userImageView.image?.accessibilityIdentifier = "userImage.png"
        } else {
            print("Couldn't convert to image.")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        //get image name from added image
        if let image = userImageView.image?.accessibilityIdentifier {
            showMailComposerWith(userImage: image)
        } else {
            alert(title: "No Image Added", msg: userImageView.image?.accessibilityIdentifier ?? "Doge")
            //"Press OK. Then tap add image at the bottom of the screen."
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func alert(title: String, msg: String) {//-> UIAlertController{
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
