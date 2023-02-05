//
//  MainViewController.swift
//  Chow Time
//
//  Created by Rituraj Sharma on 2/4/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class MainViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var topSubView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var IntroductionLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var db: Firestore!
    
    
    var centerDatas : [centerData] = [centerData(name: "DiningCenter"),centerData(name: "diningCentre"), centerData(name: "Turner Place"), centerData(name: "Ovens"), centerData(name: "Squires")]

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        DispatchQueue.main.async {
            if !self.centerDatas.isEmpty {
                self.tableView.reloadData()
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = 90
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        readData()
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
        
        
        IntroductionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        IntroductionLabel.textColor = .black
        IntroductionLabel.textAlignment = .center
        IntroductionLabel.numberOfLines = 0
        
        balanceLabel.font = UIFont.boldSystemFont(ofSize: 18)
        balanceLabel.textColor = .black
        balanceLabel.textAlignment = .center
        balanceLabel.numberOfLines = 0
        tableView.backgroundColor = UIColor.clear

    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MainTableViewCell",
                                  bundle: nil)
        tableView.register(textFieldCell,
                                forCellReuseIdentifier: Constants.MainCellIdentifier)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return centerDatas.count
      }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.MainCellIdentifier, for: indexPath) as! MainTableViewCell
        cell.CenterName?.text = centerDatas[indexPath.row].name
        cell.availableCount?.text! = "available halls: "  +  String(centerDatas[indexPath.row].availableHalls)
        
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
    
    private func readData(){
        for i in 0...1 {
            print(centerDatas[i])
            let collectionRef = db.collection(centerDatas[i].name)
            
            collectionRef.getDocuments { QuerySnapshot, error in
                if let error = error {
                    print("Eror getting documents: \(error)")
                } else {
                    print(QuerySnapshot?.count)
                    self.centerDatas[i].availableHalls  = QuerySnapshot?.count ?? 1
                    self.tableView.reloadData()
                }
            }
        }
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
