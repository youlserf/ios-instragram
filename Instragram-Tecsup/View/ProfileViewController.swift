

import UIKit

class ProfileViewController: UIViewController {

    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnEstatics: UIButton!
    
    
    @IBOutlet weak var btnContact: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageProfile.layer.cornerRadius = 30
        btnEdit.layer.cornerRadius = 13
        btnContact.layer.cornerRadius = 13
        btnEstatics.layer.cornerRadius = 13
        // Do any additional setup after loading the view.
    }
    
}
