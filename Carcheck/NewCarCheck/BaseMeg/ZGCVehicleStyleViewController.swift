//
//  ZGCVehicleStyleViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/2/24.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit
import Alamofire
class ZGCVehicleStyleViewController: ZGCBaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var carStyleTableView: UITableView!
    let identifier = "ZGCVehicleStyleTableViewCell"
    
    var carBrandModel: ZGCCarBrandModel!
    var carBrandTypeModelArr = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "基本信息-车辆型号"
        
        
        carStyleTableView.dataSource = self
        carStyleTableView.delegate = self
        let cellNib:UINib = UINib(nibName: identifier, bundle: nil)
        carStyleTableView.registerNib(cellNib, forCellReuseIdentifier: identifier)
        carStyleTableView.tableFooterView = UIView()
        
        
        Alamofire.request(.GET, BaseURLString.stringByAppendingString("brand/styles?modelId=").stringByAppendingString(carBrandModel.Value), parameters: nil, encoding: .JSON, headers: ["token" : UserDefault.objectForKey("token") as! String]).responseJSON {
            response in
            
            if let json = response.result.value {
                let dataArr = (json as! NSMutableDictionary).objectForKey("data") as! NSArray
                
                dataArr.enumerateObjectsUsingBlock({ (object, index, stop) -> Void in
                    let carBrandModel = ZGCCarBrandModel.init(contentWithDic: object as! [NSObject : AnyObject])
                    self.carBrandTypeModelArr.addObject(carBrandModel)
                })
                self.carStyleTableView.reloadData()
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
        let cell:ZGCVehicleStyleTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! ZGCVehicleStyleTableViewCell
        let carBrandListModel = carBrandTypeModelArr[indexPath.row] as! ZGCCarBrandModel
        cell.textLabel?.text = carBrandListModel.Text
        cell.carBrandListModel = carBrandListModel
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.tapToVehicleTypeVCHandler = {
            (carBrandListModel:ZGCCarBrandModel) -> Void in
            UserDefault.setObject(carBrandListModel.Text, forKey: "style")
            UserDefault.setObject(carBrandListModel.Value, forKey: "Value")
            UserDefault.synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(CHANGEVEHICLETYPE, object: nil)
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
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
