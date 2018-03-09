//
//  HomeController.h
//  TeeWatch WatchKit Extension
//


#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "TeeBaseController.h"
@import AVFoundation;

@interface HomeController : TeeBaseController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceInlineMovie *moviePlayer;

@end
