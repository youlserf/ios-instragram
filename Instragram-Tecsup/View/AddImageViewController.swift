//
//  AddImageViewController.swift
//  Instragram-Tecsup
//
//  Created by MAC37 on 11/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AddImageViewController: UIViewController {

    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var addNewImage: UIImageView!
    
    
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    var hasImage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImagePicker()

        // Do any additional setup after loading the view.
    }
    
    func setUpImagePicker(){
        imagePicker.delegate = self
    }
    
    func saveImageData(url: String){
        db.collection("posts").addDocument(data: [
            "userId": Auth.auth().currentUser?.uid ?? "no-id",
            "title": txtTitle.text!,
            "description": txtDescription.text!,
            "image": url
        ])
    }
    
    
    @IBAction func OnTapAbrirGaleria(_ sender: UIButton) {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func OnTapGuardarData(_ sender: UIButton) {
        
        if !hasImage || txtTitle.text == "" || txtDescription.text == "" {
            let alert = UIAlertController(
                title: "Error", message: "Completa los campos",
                preferredStyle: .alert)
            let alertButton = UIAlertAction(
                title: "ok",
                style: .default
            )
            
            alert.addAction(alertButton)
            present(alert, animated: true)
            return
        }else{
            uploadImage()
            hasImage = false
            let alert = UIAlertController(
                title: "Succes", message: "Imagen subida",
                preferredStyle: .alert)
            let alertButton = UIAlertAction(
                title: "ok",
                style: .default
            )
            
            alert.addAction(alertButton)
            present(alert, animated: true)
            
        }
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func uploadImage(){
        
        let numberN = Int.random(in: 1...1000)
        
        let storageRef = Storage.storage().reference().child("\(numberN)-\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadDataImage = self.addNewImage.image?.jpegData(compressionQuality: 0.5){
            storageRef.putData(uploadDataImage){
                metadata, error in
                if error == nil {
                    storageRef.downloadURL{url, error in
                        print(url?.absoluteString)
                        self.saveImageData(url: url?.absoluteString ?? "")
                        self.txtTitle.text = ""
                        self.txtDescription.text = ""
                        self.addNewImage.image = UIImage(systemName:"plus")
                        }
                }else{
                    print("\(error)")
                    self.txtTitle.text = ""
                    self.txtDescription.text = ""
                    self.addNewImage.image = UIImage(systemName:"plus")
                }
            }
        }
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickerImage = info[.originalImage] as? UIImage{
            self.hasImage = true
            addNewImage.image = pickerImage
            addNewImage.contentMode = .scaleToFill
        }
        imagePicker.dismiss(animated: true)
    }
}
