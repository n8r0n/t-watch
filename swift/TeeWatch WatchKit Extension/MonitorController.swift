//
//  MonitorController.swift
//  TeeWatch WatchKit Extension
//


import WatchKit

class MonitorController: TeeBaseController {
   
   @IBOutlet var imageView: WKInterfaceImage!
   @IBOutlet var button: WKInterfaceButton!
   private var waitingToMeasure : Bool = true
   private var showingMetricUnits : Bool = false
   
   override func awake(withContext context: Any?) {
      super.awake(withContext: context)
      
      // Configure interface objects here.
      self.preloadAudioFile("trombone.caf")
   }
   
   override func willActivate() {
      // This method is called when watch view controller is about to be visible to user
      
      super.willActivate()
      self.imageView.setAlpha(0.0)
   }
   
   override func didAppear() {
      super.didAppear()
   }
   
   override func didDeactivate() {
      // This method is called when watch view controller is no longer visible
      super.didDeactivate()
      self.waitingToMeasure = true
      self.imageView.setImageNamed("frame_")
   }
   
   @IBAction func onButtonTapped() {
      if (waitingToMeasure) {
         waitingToMeasure = false
         imageView.setAlpha(1.0)
         imageView.setImageNamed("frame_")
         let animationDuration : TimeInterval = 6.0
         imageView.startAnimatingWithImages(in: NSMakeRange(0, 24), duration: animationDuration, repeatCount: 2)
         DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: {
            self.imageView.stopAnimating()
            self.showResults(withClown: true)
         })
      } else {
         // results are being displayed
         let title = showingMetricUnits ? "English" : "Metric"
         let imgName = showingMetricUnits ? "NaN" : "NaNunits"
         self.button.setTitle(title)
         self.imageView.setImageNamed(imgName)
         showingMetricUnits = !showingMetricUnits
      }
   }
   
   private func showResults(withClown: Bool) {
      self.imageView.setImageNamed("NaN")
      self.button.setTitle("English")
      if (withClown) {
         self.say("Your T is not measurable. Please seek medical attention.")
         DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            self.imageView.setImageNamed("clown")
            self.playAudioFile(completionHandler: {
               self.showResults(withClown: false)
            })
         })
      }
   }
}
