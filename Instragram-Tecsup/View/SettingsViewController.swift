
import UIKit

class SettingsViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    let options: [SettingOption] = [
        SettingOption(name: "Archive", image: "archivebox"),
        SettingOption(name: "Your Active", image: "clock"),
        SettingOption(name: "Nametag", image: "tag"),
        SettingOption(name: "Saved", image: "square.and.arrow.down"),
        SettingOption(name: "Close Friends", image: "person"),
        SettingOption(name: "Discover People", image: "person.3"),
        SettingOption(name: "Open Facebook", image: "shippingbox")
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()

        // Do any additional setup after loading the view.
    }
    
    func setUpTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var contentListConfig = UIListContentConfiguration.cell()
        contentListConfig.text = options[indexPath.row].name
        contentListConfig.image = UIImage(systemName: options[indexPath.row].image)?.withTintColor(.black, renderingMode:  .alwaysOriginal)
        cell.contentConfiguration = contentListConfig
        return cell
    }
    
}
