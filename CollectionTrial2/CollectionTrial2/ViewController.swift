//
//  ViewController.swift
//  CollectionTrial2
//
//  Created by N Mompi Devi on 24/01/18.
//  Copyright © 2018 N Mompi Devi. All rights reserved.
//

import UIKit

struct items:Decodable{
    let title:String
    let media:m
    
}
struct m:Decodable{
    let m:String
}
struct table:Decodable{
    let title:String
    let link:String
    let description:String
    let modified:String
    let generator:String
    let items:[items]
}

class ViewController: UIViewController, UICollectionViewDataSource ,UISearchBarDelegate, UICollectionViewDelegate{
    let queue=OperationQueue()
    var searchterm:String?
    var selectedIndexPath: IndexPath!
    var selectedItem : UIImage!
    let imageToCache = NSCache<AnyObject, AnyObject>()
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var Search: UISearchBar!//searchBarFlicker
    var trialVariable:String!
    
    @IBOutlet weak var Table: UICollectionView!
    var tab:table?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Search.delegate=self
        
        FlickerClient().getData(searchTerm: "iPhone") { (result) in
            self.reloadData(result)
        }
    }
    
    //MARK: CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (tab?.items.count != nil){
            return (tab?.items.count)!
        }
        else{
            return 0
        }
    }
    
    fileprivate func configureCell(_ cell: CustomCollectionViewCell, _ indexPath: IndexPath) {
        cell.ImageV.image=nil
        let imgURl=NSURL(string:(self.tab?.items[indexPath.row].media.m)!)
        if let imageFromCache = imageToCache.object(forKey: imgURl!){
            cell.ImageV.image=imageFromCache as! UIImage
            //return
        }
        if (tab?.items.count != nil){
            //            cell.Label1.text=self.tab?.items[indexPath.row].title
            queue.addOperation {
                //print(self.tab?.items[indexPath.row])
                
                let data=NSData(contentsOf:(imgURl! as URL))
                //print(data)
                OperationQueue.main.addOperation {
                    let imageCache=UIImage(data:data! as Data)
                    self.imageToCache.setObject(imageCache!, forKey: imgURl!)
                    cell.ImageV.image = imageCache
                }
                
            }
        }
        cell.layer.cornerRadius=10
        cell.layer.borderWidth=2.0
        cell.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        configureCell(cell, indexPath)
        return cell
    }
   
    fileprivate func reloadData(_ result: (table)) {
        self.tab = result
        OperationQueue.main.addOperation {
            self.Table.reloadData()
            self.loader.stopAnimating()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchterm=searchBar.text
        imageToCache.removeAllObjects()
        self.loader.startAnimating()
        
        FlickerClient().getData(searchTerm: searchterm!) { (result) in
            self.reloadData(result)
        }
    }

    //for the next view controller
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let imgURl=NSURL(string:(self.tab?.items[indexPath.row].media.m)!)
        let data=NSData(contentsOf:(imgURl! as URL))
        self.selectedIndexPath = indexPath
        selectedItem = UIImage(data:data! as Data)
        performSegue(withIdentifier: "showDetail", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC=segue.destination as! DetailViewController
        detailVC.image = selectedItem
    }
        
}




















