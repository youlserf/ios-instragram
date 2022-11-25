import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.isSecureTextEntry = true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkSession()
    }
    
    func checkSession(){
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "segueLogin", sender: nil)
        }
    }

    @IBAction func onTapLogin(_ sender: UIButton) {
        if txtEmail.text == "" || txtPassword.text == "" {
            let alert = UIAlertController(
                title: "Error", message: "Completa los campos",
                preferredStyle: .alert)
            let alertButton = UIAlertAction(
                title: "ok",
                style: .default
            )
            
            alert.addAction(alertButton)
            present(alert, animated: true)
        }
        singIn(email: txtEmail.text!, password: txtPassword.text!)
    }
    
//    singin
//    si el usuario no existe llamo a registro
    func singIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password ){
            authResult, error in
            if error == nil{
                
                self.performSegue(withIdentifier: "segueLogin", sender: nil)
            }else{
                self.singUp(email: email, password: password)
            }
        }
    }
    func singUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password){
            authResult, error in
            if error != nil {
                let alert = UIAlertController(
                    title: "Error", message: error?.localizedDescription,
                    preferredStyle: .alert)
                let alertButton = UIAlertAction(
                    title: "ok",
                    style: .default
                )
                alert.addAction(alertButton)
                self.present(alert, animated: true)
            }else{
                self.performSegue(withIdentifier: "segueLogin", sender: nil)
            }
        }
    }
}
