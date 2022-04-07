//
//  TableViewController.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Мои места"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Snell Roundhand", size: 24) ?? 0]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showAddPlaceVC))
        
    }
    
    @objc private func showAddPlaceVC() {
        navigationController?.pushViewController(NewPlacesViewController(), animated: true)
    }
                                                                        

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MyPlaces.array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let place = MyPlaces.array[indexPath.row]
        
        cell.namePlace.text = place.namePlace
        cell.locationPlace.text = place.locationPlace
        cell.typePlace.text = place.typePlace
        
        if place.image == nil {
            cell.imagePlace.image = UIImage(named: place.restaurantImage ?? "Error")
        } else {
            cell.imagePlace.image = place.image
        }
            
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
