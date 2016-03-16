//
//  ZGCValuationResultViewController.swift
//  Carcheck
//
//  Created by GaoCheng.Zou on 16/3/15.
//  Copyright © 2016年 GaoCheng.Zou. All rights reserved.
//

import UIKit

class ZGCValuationResultViewController: ZGCBaseViewController {

    @IBOutlet weak var valueLabel1: UILabel!
    @IBOutlet weak var valueLabel2: UILabel!
    @IBOutlet weak var valueLabel3: UILabel!
    @IBOutlet weak var valueLabel4: UILabel!
    
    var valueArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "车辆估值结果"
        self.initBackButton()
        // Do any additional setup after loading the view.
        valueLabel1.text = "\(valueArr[2])\("万")"
        valueLabel2.text = "\(valueArr[1])\("万")"
        valueLabel3.text = "\(valueArr[0])\("万")"
        valueLabel4.text = "\(valueArr[3])\("万")"

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
