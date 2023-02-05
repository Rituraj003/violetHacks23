//
//  RestaurantViewController.swift
//  Chow Time
//
//  Created by Rituraj Sharma on 2/4/23.
//

import UIKit


class RestaurantViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var hallDatas : [hallData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backgroundImage = UIImage(named: "wallpaper")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.bounds
        backgroundImageView.alpha = 0.4
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = 280.0
        
        //Rotate the view
//        CGAffineTransform transform  =
//        self.tableView.frame = CGRect(x: 10, y: 180 + 60, width: 380, height: 260);
        self.registerTableViewCells()
        // Do any additional setup after loading the view.
        tableView.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "backSegue", sender: self)
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "DiningHallViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                                forCellReuseIdentifier: Constants.CellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hallDatas.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath) as! DiningHallViewCell

        cell.hallName?.text = self.hallDatas[indexPath.row].name
        cell.peopleCount?.text = "No. of people: " + String(self.hallDatas[indexPath.row].peopleCounts)
        cell.waitTime?.text = "Estimate wait time : "  + String(self.hallDatas[indexPath.row].waitTime) + " min"
        cell.hallLogo?.image = UIImage(named: self.hallDatas[indexPath.row].name)
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.viewBox.layer.cornerRadius = 20
        cell.viewBox.clipsToBounds = true
        cell.viewBox.alpha = 1
        return cell
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
