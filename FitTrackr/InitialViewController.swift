//
//  ViewController.swift
//  FitTrackr
//
//  Created by Alex Persson on 1/18/17.
//  Copyright © 2017 Alex Persson. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import MapKit
import ChameleonFramework


class InitialViewController: ASViewController<ASDisplayNode>, CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate {
  
  
  func showPopUp() {
    let vc =  PopUpViewController()
    vc.modalPresentationStyle = .custom
    vc.preferredContentSize = CGSize(width: 300, height: 300)
    
    
    let popover = vc.popoverPresentationController!
    popover.delegate = self
    popover.permittedArrowDirections = .any
    popover.sourceView = self.view
    popover.sourceRect = self.view.bounds
    popover.popoverLayoutMargins = UIEdgeInsets(top: 50, left: 50, bottom: 150, right: 150)

    present(vc, animated: true, completion: nil)
  }

  
  
  // Constant Sizes
  var tabBarHeight: CGFloat?
  var navBarHeight: CGFloat?
  var frame: CGRect?
  
  // Map Items
  var mapView: MKMapView!
  var polyline: MKPolyline?
  
  var mapNode: MapNode!
  
  
  
  var locationManager: CLLocationManager?
  
  var myLocations: [CLLocation] = []
  var distance: [CLLocationDistance] = []
  var pausedDistance: [CLLocationDistance] = []
  var pausedCounter: Int = 0
  var speed: CLLocationSpeed?
  var pace: Double?
  
  // end map items
  
  let initialDisplayNode: ASDisplayNode!
  var topRectangle: ASDisplayNode
  var bottomRectangle: ASDisplayNode
  
  
  let speedLabelTopDescriptorNode: ASTextNode
  let speedLabelBottomDataNode: ASTextNode
  
  let timeLabelTopDescriptorNode: ASTextNode
  let timeLabelBottomDataNode: ASTextNode
  
  let paceLabelTopDescriptorNode: ASTextNode
  let paceLabelBottomDataNode: ASTextNode
  
  let distanceLabelDataNode: ASTextNode
  
  let timerLabelNode: ASTextNode
  
  
  let startTimerButton: ASButtonNode
  let resetTimerButton: ASButtonNode
  
  
  @objc private func startButtonTapped(_: Any) {
    createDisplayLinkIfNeeded()
    
    
    switch state {
    case .Stopped:
      if startTime == 0 {
        startTime = CFAbsoluteTimeGetCurrent() }
      else {
        startTime += CFAbsoluteTimeGetCurrent() - pauseTime
        
        let currentLocation = locationManager?.location
        let lastLocationIndex = myLocations.count - 1
        let lastLocation = myLocations[lastLocationIndex]
        let pausedDist = currentLocation!.distance(from: lastLocation) / 1609
        pausedDistance.append(pausedDist)
        
        
      }
      displayLink?.isPaused = false
      state = .Running
      startTimerButton.setTitle("Pause", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
      locationManager!.startUpdatingLocation()

      
    case .Pending:
        startTime = CFAbsoluteTimeGetCurrent()
        displayLink?.isPaused = false
        state = .Running
        startTimerButton.setTitle("Pause", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
        locationManager!.startUpdatingLocation()


    case .Running:
      state = .Stopped
      pauseTime = CFAbsoluteTimeGetCurrent()

      endTime = CFAbsoluteTimeGetCurrent()
      locationManager!.stopUpdatingLocation()

      displayLink?.isPaused = true
      startTimerButton.setTitle("Start", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])

    }
    
  }
  
  
  @objc private func resetButtonTapped(_: Any) {
    state = .Pending
    startTimerButton.setTitle("Start", with: UIFont.systemFont(ofSize:18), with: UIColor.black, for: [ ])
    startTime = 0
    pauseTime = 0
    endTime = 0
    resetMapView()
    showPopUp()
    

  }
  
   let attrs = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
  
   let distanceAttrs = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22)]
  
  private var startTime: CFAbsoluteTime = 0
  private var pauseTime: CFAbsoluteTime = 0

  private var endTime: CFAbsoluteTime = 0 {
    didSet {
      updateLabel()
    }
  }
  
  private var displayLink: CADisplayLink?
  
  private enum State {
    case Stopped
    case Pending
    case Running
  }
  
  private var elapsedTime: TimeInterval {
    switch state {
    case .Stopped: return endTime - startTime
    case .Running: return CFAbsoluteTimeGetCurrent() - startTime
    case .Pending: return 0
   
    }
  }
  
  private func updateLabel() {
    let hours = Int(elapsedTime) / 3600
    let minutes = Int(elapsedTime) / 60 % 60
    let seconds = Int(elapsedTime) % 60
    let timeString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)

    
    
    timeLabelBottomDataNode.attributedText = NSAttributedString(string: timeString, attributes: attrs)
  }
  
  private var state = State.Stopped {
    didSet {
      
      updateLabel()
    }
  }
  
  
  
  init() {
    initialDisplayNode = ASDisplayNode()
    topRectangle = ASDisplayNode()
    bottomRectangle = ASDisplayNode()
    
    speedLabelTopDescriptorNode = ASTextNode()
    speedLabelBottomDataNode = ASTextNode()
    
    timeLabelTopDescriptorNode = ASTextNode()
    timeLabelBottomDataNode = ASTextNode()
    
    paceLabelTopDescriptorNode = ASTextNode()
    paceLabelBottomDataNode = ASTextNode()
    
    distanceLabelDataNode = ASTextNode()
    
    timerLabelNode = ASTextNode()
    
    startTimerButton = ASButtonNode()
    resetTimerButton = ASButtonNode()
    
    mapNode = MapNode()

    
    
    super.init(node: initialDisplayNode)
    
    
    // Configure Top Rectangle
    
    
    // Configure Bottom Rectangle
    bottomRectangle.backgroundColor = UIColor.flatSkyBlue
    
    // Configure Speed Stack
    
   
    
    speedLabelTopDescriptorNode.attributedText = NSAttributedString(string: "Speed (MPH)", attributes: attrs)
    
    
    speedLabelBottomDataNode.attributedText = NSAttributedString(string: "0.00", attributes: attrs)
    let speedStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .center, alignItems: .center, children: [speedLabelTopDescriptorNode,speedLabelBottomDataNode])
    
    // Configure Time Stack
    
    timeLabelTopDescriptorNode.attributedText = NSAttributedString(string: "Time", attributes: attrs)
    timeLabelBottomDataNode.attributedText = NSAttributedString(string: "00:00:00", attributes: attrs)
    let timeStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .center, alignItems: .center, children: [timeLabelTopDescriptorNode,timeLabelBottomDataNode])
    
    // Configure Pace Stack
    
    paceLabelTopDescriptorNode.attributedText = NSAttributedString(string: "Pace (MIN/MI)", attributes: attrs)
    paceLabelBottomDataNode.attributedText = NSAttributedString(string: "00:00", attributes: attrs)
    let paceStack = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .center, alignItems: .center, children: [paceLabelTopDescriptorNode,paceLabelBottomDataNode])

    
    // Configure Distance Stack
    
      distanceLabelDataNode.attributedText = NSAttributedString(string: "0.00", attributes: distanceAttrs)
    let distanceStack = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumX, child: distanceLabelDataNode)
    
    // Configure TimeSpeed Stack
    
    let timeSpeedStack = ASStackLayoutSpec(direction: .horizontal, spacing: 30, justifyContent: .start, alignItems: .center, children: [speedStack, timeStack, paceStack])
    timeSpeedStack.verticalAlignment = .verticalAlignmentTop
    
    
    
    
    // Configure Timer Label & Stack
    let timerAttrs = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 32)]
    timerLabelNode.attributedText = NSAttributedString(string: "0:00.00", attributes: timerAttrs)
    
    let timerInsets = UIEdgeInsets(top: CGFloat.infinity, left: CGFloat.infinity, bottom: 75, right: CGFloat.infinity)
    let timerInsetStack = ASInsetLayoutSpec(insets: timerInsets, child: timerLabelNode)
    
    // Configure Timer Buttons
    
    let borderWidth = CGFloat(2)
    let borderColor = UIColor.black.cgColor
    let prefSize = CGSize(width: 60, height: 60)
    
    startTimerButton.borderWidth = borderWidth
    startTimerButton.borderColor = borderColor
    startTimerButton.setTitle("Start", with: UIFont.systemFont(ofSize: 18), with: ContrastColorOf(UIColor.flatSkyBlue, returnFlat: true), for: [])
    startTimerButton.style.preferredSize = prefSize
    startTimerButton.cornerRadius = 30
    startTimerButton.backgroundColor = ComplementaryFlatColorOf(UIColor.flatSkyBlue)
    startTimerButton.addTarget(self, action: #selector(startButtonTapped(_:)), forControlEvents: .touchUpInside)
    
   
    resetTimerButton.borderWidth = borderWidth
    resetTimerButton.borderColor = borderColor
    resetTimerButton.setTitle("Reset", with: UIFont.systemFont(ofSize: 18), with: UIColor.white, for: [])
    resetTimerButton.style.preferredSize = prefSize
    resetTimerButton.cornerRadius = 30
    resetTimerButton.backgroundColor = UIColor.blue

    resetTimerButton.addTarget(self, action: #selector(resetButtonTapped(_:)), forControlEvents: .touchUpInside)
    
    let timerButtonStack = ASStackLayoutSpec(direction: .horizontal, spacing: 100, justifyContent: .center, alignItems: .center, children: [startTimerButton, resetTimerButton])
    
    // Configure Map
    mapView = mapNode.mapView
    
    // Top Rectangle Overlay Stack
    
    
    let topRectangleCenterStack = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: mapNode)
    let topRectangleOverlayStack = ASOverlayLayoutSpec(child: topRectangle, overlay: topRectangleCenterStack)
    
    // Configure Bottom Rectangle Stack
    
    
    let bottomStack = ASStackLayoutSpec(direction: .vertical, spacing: 40, justifyContent: .start, alignItems: .center, children: [timeSpeedStack, distanceStack, timerButtonStack])
    let bottomStackCenter = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: bottomStack)
    
    
    
    // Other Inits
    
    
    initialDisplayNode.automaticallyManagesSubnodes = true
    
    self.node.layoutSpecBlock = { node in
      self.topRectangle.style.flexGrow = 1.0
      self.bottomRectangle.style.flexGrow = 1.0
      self.initialDisplayNode.frame = self.view.frame
      self.topRectangle.style.preferredSize = CGSize(width: self.view.frame.width, height: self.view.frame.height / 2 )
      self.bottomRectangle.style.preferredSize = CGSize(width: self.view.bounds.width, height: self.view.frame.height / 2)
      self.bottomRectangle.style.minHeight = ASDimension(unit: .auto, value: self.view.frame.height / 2)
      
      
      let headerSubStack = ASStackLayoutSpec.vertical()
      
      
      let bottomOverlayStack = ASOverlayLayoutSpec(child: self.bottomRectangle, overlay: bottomStackCenter)
      
      
      headerSubStack.children = [topRectangleOverlayStack, bottomOverlayStack]
      headerSubStack.alignItems = ASStackLayoutAlignItems.stretch
      return headerSubStack
      
    }
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func createDisplayLinkIfNeeded() {
    guard self.displayLink == nil else { return }
    let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidFire(_:)))
    displayLink.isPaused = true
    displayLink.add(to: RunLoop.main, forMode: .commonModes)
    self.displayLink = displayLink
    
    
  }
  
  func displayLinkDidFire(_: CADisplayLink) {
    updateLabel()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initialDisplayNode.backgroundColor = UIColor.blue
    if let tabBarHeight = self.tabBarController?.tabBar.bounds.size.height, let navBarHeight = self.navigationController?.navigationBar.bounds.size.height {
      frame = self.view.frame
      frame!.size.height = frame!.size.height - navBarHeight - tabBarHeight
      self.view.frame = frame!

    }
    
    
    
    

    
    
    // mapView = MKMapView()
    // let mapFrame = CGRect(x: 0, y: 50, width: self.view.bounds.width, height: self.view.bounds.height / 2)
    // mapView.frame = mapFrame
    mapView.delegate = self
    mapView.showsUserLocation = true

    //topRectangle.view.addSubview(mapView)
    //topRectangle.view.bringSubview(toFront: mapView)
    // topRectangle.addSubnode(mapNode)
    
    locationManager = CLLocationManager()
    self.locationManager?.requestAlwaysAuthorization()
    self.locationManager?.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager!.delegate = self
      locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      print("location enabled")
    } else {
      print("location not enabled")
    }

    
    
  }

  
  
  override func viewDidAppear(_ animated: Bool) {
    
    
    
 }
  
  override func viewDidDisappear(_ animated: Bool) {
    /*
    super.viewDidDisappear(animated)
    mapView.delegate = nil
    mapView.removeFromSuperview()
    mapView = nil
 */
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    myLocations.append(locations[0] as CLLocation)
    
    
    let spanX = 0.007
    let spanY = 0.007
    var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
    mapView.setRegion(newRegion, animated: true)
    
    
    
    
    
    
    if (myLocations.count > 1){
      let sourceIndex = myLocations.count - 1
      let destinationIndex = myLocations.count - 2
      
      let c1 = myLocations[sourceIndex].coordinate
      let c2 = myLocations[destinationIndex].coordinate
      
      var a:[CLLocationCoordinate2D] = []
      
      a = [c1, c2]
      
      var aPaused = [locationManager!.location!.coordinate, c1]
      let dist = (myLocations[destinationIndex].distance(from: myLocations[sourceIndex])) / 1609
      distance.append(dist)
      let miles = distance.reduce(0, +) - pausedDistance.reduce(0,+)
      let milesString = String(format: "%.02f", miles)
      distanceLabelDataNode.attributedText = NSAttributedString(string: milesString, attributes: distanceAttrs)
      
      
      speed = locationManager?.location?.speed
      if let speedInMetersPerSecond = speed {
        let speedInMilesPerHour = max(2.23694 * speedInMetersPerSecond, 0)
        let speedString = String(format: "%.02f", speedInMilesPerHour)
        speedLabelBottomDataNode.attributedText = NSAttributedString(string: speedString, attributes: attrs)
        
        pace =  1 / (miles / (Double(elapsedTime)))
        
        
        let minutes = (Double(pace!) / 60).truncatingRemainder(dividingBy: 60)
        let seconds = Double(pace!).truncatingRemainder(dividingBy: 60)
        let paceStr = String(format:"%.0f:%.0f", minutes, seconds)
        
        paceLabelBottomDataNode.attributedText = NSAttributedString(string: paceStr, attributes: attrs)

      }
      
      polyline = MKPolyline(coordinates: &a, count: a.count)
      
      mapView.add(polyline!)
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
    
    if overlay is MKPolyline {
      var polylineRenderer = MKPolylineRenderer(overlay: overlay)
      polylineRenderer.strokeColor = UIColor.blue
      polylineRenderer.lineWidth = 4
      return polylineRenderer
    }
    return nil
  }
  
  func resetMapView() {
    locationManager!.stopUpdatingLocation()
    mapView.removeOverlays(mapView.overlays)
    myLocations = []
    distance = []
    pausedDistance = []

  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Failed to initialize GPS: ", error.localizedDescription)
  }

  
}


