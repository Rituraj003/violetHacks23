//
//  MainViewController.swift
//  Chow Time
//
//  Created by Rituraj Sharma on 2/4/23.
//

import UIKit

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var topSubView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var IntroductionText: UILabel!
    
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var balanceInfoLabel: UILabel!
    
    let data = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 90
        

        
        topSubView.backgroundColor = UIColor.clear

        let backgroundImage = UIImage(named: "wallpaper")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        backgroundImageView.alpha = 0.4
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        self.registerTableViewCells()
  
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        
        
        IntroductionText.font = UIFont.boldSystemFont(ofSize: 18)
        IntroductionText.textColor = .black
        IntroductionText.textAlignment = .center
        IntroductionText.numberOfLines = 0
        
        balanceInfoLabel.font = UIFont.boldSystemFont(ofSize: 18)
        balanceInfoLabel.textColor = .black
        balanceInfoLabel.textAlignment = .center
        balanceInfoLabel.numberOfLines = 0
        tableView.backgroundColor = UIColor.clear

    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MainTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                                forCellReuseIdentifier: Constants.MainCellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MainCellIdentifier, for: indexPath) as! MainTableViewCell
        cell.CenterName?.text = data[indexPath.row]
        cell.availableCount?.text! += String(indexPath.row)
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.viewBox.backgroundColor = UIColor.clear
        cell.viewBox.layer.cornerRadius = 20
        cell.viewBox.clipsToBounds = true
        cell.viewBox.alpha = 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "CenterRes", sender: self)
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
