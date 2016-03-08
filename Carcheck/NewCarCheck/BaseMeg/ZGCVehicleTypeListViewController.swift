//
//  ZGCVehicleTypeListViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/24.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire

class ZGCVehicleTypeListViewController: ZGCBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var carBrandListTableView: UITableView!
    var carBrandModelArr = NSMutableArray()
    var letterArr = NSArray()
    var sectionModelArr = NSMutableArray()
    
    let identifier = "ZGCCarBrandListTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        carBrandListTableView.dataSource = self
        carBrandListTableView.delegate = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        carBrandListTableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        carBrandListTableView.tableFooterView = UIView()

        self.navigationItem.title = "基本信息-车辆型号"

        Alamofire.request(.GET, BaseURLString.stringByAppendingString("brand/list"), parameters: nil, encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
            response in

            if let json = response.result.value {
                let dataArr = (json as! NSMutableDictionary).objectForKey("data") as! NSArray
                dataArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let carBrandModel = ZGCCarBrandModel.init(contentWithDic: object as! [NSObject : AnyObject])
                    self.carBrandModelArr.addObject(carBrandModel)
                })
                
                let totalLetterArr = NSMutableArray(capacity: self.carBrandModelArr.count)

                self.carBrandModelArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let carBrandListModel = object as! ZGCCarBrandModel
                    totalLetterArr.addObject(carBrandListModel.GroupName)
                })
                
                let mDic = NSMutableDictionary()
                totalLetterArr.enumerateObjectsUsingBlock({ (object, idnex, stop) -> Void in
                    mDic.setObject(object, forKey: object as! String)
                })
                
                /*
                *按字母顺序排序
                */
                self.letterArr = (mDic.allKeys as NSArray).sortedArrayUsingComparator({ (obj1:AnyObject, obj2:AnyObject) -> NSComparisonResult in
                    return obj1.compare(obj2 as! String, options: NSStringCompareOptions.NumericSearch)
                })
                
                self.carBrandListTableView.reloadData()
            }
        }

    }
    
    override func initHomeButton() {
        self.initBackButton()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.letterArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var arr = NSMutableArray()
        let str = letterArr[section]
        
        self.carBrandModelArr.enumerateObjectsUsingBlock { (object, index, stop) -> Void in
            let carBrandListModel = object as! ZGCCarBrandModel
            if carBrandListModel.GroupName == str as! String {
                arr.addObject(carBrandListModel)
            }
        }
        
        if sectionModelArr.count < letterArr.count {
            sectionModelArr.addObject(arr.mutableCopy())
            if sectionModelArr.count == letterArr.count {
                arr.removeAllObjects()
                arr = sectionModelArr.firstObject as! NSMutableArray
                sectionModelArr.removeObject(arr)
                sectionModelArr.addObject(arr)
            }
        }
        
        return arr.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ZGCCarBrandListTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCCarBrandListTableViewCell
        let arr = sectionModelArr[indexPath.section] as! NSMutableArray
        let carBrandListModel = arr[indexPath.row] as! ZGCCarBrandModel
        cell.carBrandListModel = carBrandListModel
        cell.textLabel?.text = carBrandListModel.Text
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.tapToVehicleTypeVCHandler = {
            (carBrandListModel:ZGCCarBrandModel) -> Void in
            UserDefault.setObject(carBrandListModel.Text, forKey: "brand")
            UserDefault.synchronize()
            let vehicleTypeVC = ZGCVehicleTypeViewController()
            vehicleTypeVC.carBrandModel = carBrandListModel
            self.navigationController?.pushViewController(vehicleTypeVC, animated: true)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.text = "  ".stringByAppendingString((self.letterArr[section] as? String)!)
        return titleLabel
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return letterArr as? [String]
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        return index
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}


