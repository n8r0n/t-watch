//
//  MonitorController.h
//  TeeWatch WatchKit Extension
//


#import <WatchKit/WatchKit.h>
#import "TeeBaseController.h"
@import AVFoundation;

@interface MonitorController : TeeBaseController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *button;

- (IBAction)onButtonTapped;

@end
