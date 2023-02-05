//
//  RestaurantViewController.swift
//  Chow Time
//
//  Created by Rituraj Sharma on 2/4/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class RestaurantViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var db: Firestore!

    
    var hallDatas : [hallData] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        readData()
        
    }
    
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
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
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
    
    func readData()
    {
        let docRef = db.collection("diningCentre")
        docRef.addSnapshotListener { document, error in
            print("Snapshot listener called")
            self.hallDatas = []
            if let document = document?.documents, !document.isEmpty {
                for i in 0..<document.count {
                    let data = document[i].data()
                    let name = data["hallName"]!
                    let tempHallData = hallData(name: name as! String)
                    self.hallDatas.append(tempHallData)
                    let peopleCountData = docRef.document(document[i].documentID).collection("peopleCount").order(by: "timestamp", descending: true)
                    peopleCountData.addSnapshotListener { countDoc, error in
                        if let countData = countDoc?.documents, !countData.isEmpty {
                            print(countData.count)
                            print(type(of: countData))
                            print(countData[0].data(), countData[0],name)
                            if (countData.count > 0)
                            {
                                self.hallDatas[i].peopleCounts = countData[0].data()["noOfpeople"] as! Int
                                self.hallDatas[i].Timestamp = countData[0].data()["timestamp"] as! Int
                                self.hallDatas[i].waitTime = countData[0].data()["waitTime"] as! Int
                            }
                            //let mostRecentDataIndex = self.sortByTimestamp(arr: countData)
                            
                            print(1)
                            DispatchQueue.main.async {
                                if !self.hallDatas.isEmpty {
                                    self.tableView.reloadData()
                                }
                            }
                            print(2)
                        }
                        print(3)
                    }
                    print(4)
                }
                print(5)
            }
        }
        print(self.hallDatas)
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
