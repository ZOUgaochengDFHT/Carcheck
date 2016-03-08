//
//  ZGCVehicleTypeViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/24.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCVehicleTypeViewController: ZGCBaseViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var vehicleTypeTableView: UITableView!
    let identifier = "ZGCVehicleTypeTableViewCell"
    
    var carBrandModel: ZGCCarBrandModel!
    var carBrandTypeModelArr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "基本信息-车辆型号"

        
        vehicleTypeTableView.dataSource = self
        vehicleTypeTableView.delegate = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        vehicleTypeTableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        vehicleTypeTableView.tableFooterView = UIView()

        
        Alamofire.request(.GET, BaseURLString.stringByAppendingString("brand/models?makeId=").stringByAppendingString(carBrandModel.Value), parameters: nil, encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            
            if let json = response.result.value {
                let dataArr = (json as! NSMutableDictionary).objectForKey("data") as! NSArray

                dataArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let carBrandModel = ZGCCarBrandModel.init(contentWithDic: object as! [NSObject : AnyObject])
                    self.carBrandTypeModelArr.addObject(carBrandModel)
                })
                self.vehicleTypeTableView.reloadData()
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func initHomeButton() {
        self.initBackButton()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carBrandTypeModelArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ZGCVehicleTypeTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCVehicleTypeTableViewCell
        let carBrandListModel = carBrandTypeModelArr[indexPath.row] as! ZGCCarBrandModel
        cell.textLabel?.text = carBrandListModel.Text
        cell.carBrandListModel = carBrandListModel
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.tapToVehicleTypeVCHandler = {
            (carBrandListModel:ZGCCarBrandModel) -> Void in
            UserDefault.setObject(carBrandListModel.Text, forKey: "model")
            UserDefault.synchronize()
            let vehicleTypeVC = ZGCVehicleStyleViewController()
            vehicleTypeVC.carBrandModel = carBrandListModel
            self.navigationController?.pushViewController(vehicleTypeVC, animated: true)
        }
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
