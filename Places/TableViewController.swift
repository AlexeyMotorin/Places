//
//  TableViewController.swift
//  Places
//
//  Created by Алексей Моторин on 04.04.2022.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var places: Results<Places>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Places.self)
        
        setupNavigationBar()
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Мои места"
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.title = ""
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Мои места"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Snell Roundhand", size: 24) ?? 0]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showAddPlaceVC))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.up.arrow.down"), style: .plain, target: self, action: #selector(sorted))
    }
    
    @objc private func showAddPlaceVC() {
        navigationController?.pushViewController(NewPlacesViewController(), animated: true)
    }
    
    @objc private func sorted() {
        
    }

                                                                        

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.isEmpty ? 0 : places.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        let place = places[indexPath.row]
        
        cell.namePlace.text = place.namePlace
        cell.locationPlace.text = place.locationPlace
        cell.typePlace.text = place.typePlace
        cell.imagePlace.image = UIImage(data: place.imageData!)
        
        return cell
    }
    
    // MARK: Table view delegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let place = places[indexPath.row]
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .fade )
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placesVC = NewPlacesViewController()
        placesVC.currentPlace = places[indexPath.row]        
        navigationController?.pushViewController(placesVC, animated: true)
    }
}
