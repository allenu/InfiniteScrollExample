//
//  ViewController.swift
//  InfiniteScroll
//
//  Created by Allen Ussher on 5/23/18.
//  Copyright © 2018 Ussher Press. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let testColors: [UIColor] = [
        UIColor.blue,
        UIColor.red,
        UIColor.magenta,
        UIColor.green,
        UIColor.cyan,
        UIColor.yellow,
        UIColor.white,
        UIColor.black,
        UIColor.brown,
        UIColor.orange,
        UIColor.black,
    ]
    var numColors = 5
    var cellWidth: CGFloat = 40.0
    
    @IBOutlet weak var numColorsSlider: UISlider!
    @IBOutlet weak var numColorsLabel: UILabel!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthLabel: UILabel!
    var colorBrowser: ColorBrowser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numColorsSlider.value = Float(numColors)
        numColorsSlider.minimumValue = 1.0
        numColorsSlider.maximumValue = Float(testColors.count)

        widthSlider.value = Float(cellWidth)
        widthSlider.minimumValue = 10.0
        widthSlider.maximumValue = 400.0

        let frame = CGRect(x: 0, y: 120, width: 400.0, height: 400.0)
        colorBrowser = ColorBrowser(frame: frame)
        colorBrowser.cellWidth = cellWidth
        colorBrowser.translatesAutoresizingMaskIntoConstraints = false
        
        colorBrowser.colors = Array(testColors.prefix(numColors))
        view.addSubview(colorBrowser)
        
        updateNumColorsLabel()
        updateCellWidthLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNumColorsLabel() {
        numColorsLabel.text = "Num colors: \(numColors)"
    }
    
    func updateCellWidthLabel() {
        widthLabel.text = "Cell width: \(cellWidth)"
    }

    @IBAction func sliderDidChange(sender: UISlider) {
        if sender == numColorsSlider {
            numColors = Int(sender.value)
            colorBrowser.colors = Array(testColors.prefix(numColors))
            updateNumColorsLabel()
        } else if sender == widthSlider {
            cellWidth = CGFloat(floor(sender.value))
            colorBrowser.cellWidth = cellWidth
            updateCellWidthLabel()
        }
    }
}
