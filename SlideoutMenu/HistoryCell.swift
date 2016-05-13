//
//  HistoryCell.swift
//  Eigen
//
//  Created by Connor Holowachuk on 2016-05-06.
//  Copyright © 2016 Connor Holowachuk. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class HistoryCell: UITableViewCell, MKMapViewDelegate {
    
    @IBOutlet weak var HeadingLabel: UILabel!
    @IBOutlet weak var SubheadingLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor(hex: 0x4AD5C6).colorWithAlphaComponent(0.1)
            circleRenderer.strokeColor = UIColor.clearColor()
            circleRenderer.lineWidth = 1
            return circleRenderer
        } else {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor(hex: 0x8392D4)
            polyLineRenderer.lineWidth = 5
            polyLineRenderer.lineCap = CGLineCap.Round
            return polyLineRenderer
        }
        
    }
}
