//
//  UpdateProfileViewController.swift
//  Instragram-Tecsup
//
//  Created by MAC37 on 4/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UpdateProfileViewController: UIViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtBio: UITextField!
    
    
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = 30
        getCurrentUser()
        getUserDocument()
        setUpImagePicker()
        // Do any additional setup after loading the view.
    }
    
    func getCurrentUser(){
        let user = Auth.auth().currentUser
        
        txtEmail.text = user?.email
    }
    
    func getUserDocument(){
        let user = db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id")
        user.getDocument{document, error in
            if error == nil {
                let data = document?.data()
                self.txtBio.text = data!["bio"] as? String
                self.txtName.text = data!["name"] as? String
                self.txtEmail.text = data!["email"] as? String
                self.txtUsername.text = data!["username"] as? String
                self.imageFromUrl(url: data!["image"] as? String ?? "")
            }
        }
    }
    
    func imageFromUrl(url: String){
        let imageURL = URL(string: url)
        let data = try? Data(contentsOf: imageURL!)
        
        if let imageData = data {
            imgProfile.image = UIImage(data: imageData)
            imgProfile.contentMode = .scaleAspectFill
        }
    }
    
    func setUpImagePicker(){
        imagePicker.delegate = self
    }
    
    @IBAction func OnTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func saveUserData(url: String){
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "no-id").setData([
            "name": txtName.text!,
            "email": txtEmail.text!,
            "username": txtUsername.text!,
            "bio": txtBio.text!,
            "image": url]
        )
    }
    
    @IBAction func OnTapSaveData(_ sender: UIButton) {
        uploadImage()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OnTapOpenGallery(_ sender: UIButton) {
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func uploadImage(){
        let storageRef = Storage.storage().reference().child("\(Auth.auth().currentUser?.uid ?? "").png")
        if let uploadDataImage = self.imgProfile.image?.jpegData(compressionQuality: 0.5){
            storageRef.putData(uploadDataImage){
                metadata, error in
                if error == nil {
                    storageRef.downloadURL{url, error in
                        print(url?.absoluteString)
                        self.saveUserData(url: url?.absoluteString ?? "")
                    }
                }else{
                    print("\(error)")
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickerImage = info[.originalImage] as? UIImage{
            imgProfile.image = pickerImage
            imgProfile.contentMode = .scaleToFill
        }
        imagePicker.dismiss(animated: true)
    }
}

