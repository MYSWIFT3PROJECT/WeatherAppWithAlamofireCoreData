//
//  LeftSideViewController.swift
//  WeatherAppKosign
//
//  Created by iMac on 12/28/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import UIKit
import CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let appContext = appDelegate.persistentContainer.viewContext

class LeftSideViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,NSFetchedResultsControllerDelegate{
 
    
    
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
    }
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var controllers: NSFetchedResultsController<City>!
    var dataArray = [String]()
    
    var filteredArray = [String]()
    
    @IBOutlet weak var tblSearchResults: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearchResults.isEditing = true
        tblSearchResults.delegate = self
        tblSearchResults.dataSource = self
        //loadListOfCountries()
        
        fectCity()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tblSearchResults.reloadData()
    }
    func fectCity(){

        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        
        let result = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [result]
        
       // fetchRequest.predicate = NSPredicate(format: "name contains[cd] %@", "a")
         //etchRequest.sortDescriptors = [sortedData]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controllers = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("***** ERROR : ****** \(error)")
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblSearchResults.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblSearchResults.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case.insert:
            if let indexPath = newIndexPath {
                tblSearchResults.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let citycell = tblSearchResults.cellForRow(at: indexPath) as! CityViewCell
                configurecell(cell: citycell, indexpath: indexPath as NSIndexPath)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tblSearchResults.deleteRows(at: [indexPath], with: .fade)
            }
            break
       
        case.move:
            if let indexPath = indexPath {
                tblSearchResults.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tblSearchResults.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func AddButton(_ sender: Any) {
       configureSearchController()
        searchController.searchBar.isHidden = false
        
    }
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsBookmarkButton = false
        searchController.searchBar.setValue("Done", forKey:"_cancelButtonText")
        definesPresentationContext = true
        tblSearchResults.tableHeaderView = searchController.searchBar
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblSearchResults.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        if (searchController.searchBar.text == ""){
            searchBar.showsCancelButton = false
        }else{
            let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: appContext)
            if let newCity = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces){
                city.setValue(newCity, forKey: "name")
                
                appDelegate.saveContext()
                searchBar.showsCancelButton = false
                tblSearchResults.reloadData()
            }
            
        }
        searchController.searchBar.isHidden = true
        tblSearchResults.tableHeaderView = nil
        tblSearchResults.reloadData()
    }
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblSearchResults.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    
    //Confirm
    func updateSearchResultsForSearchController(searchController: UISearchController) {
      
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controllers.sections{
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controllers.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell") as! CityViewCell
        let city = controllers.object(at: indexPath)
        cell.configureCell(city: city)
       return cell
    }
    func configurecell(cell:CityViewCell, indexpath: NSIndexPath){
        let cityname = controllers.object(at: indexpath as IndexPath)
        cell.configureCell(city: cityname)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let arrCity = controllers.object(at: indexPath)
//
//        var arr = [arrCity]

     
        if editingStyle == .delete {

            print("---- \(indexPath.row)")
            appContext.delete(controllers.object(at: indexPath))
            do {
                try appContext.save()
            } catch{}
            
            tableView.reloadData()
            
            
        }
        
    }
    

}
