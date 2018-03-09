//
//  TeeBaseController.h
//  TeeWatch WatchKit Extension
//

#import <WatchKit/WatchKit.h>
@import AVFoundation;


@interface TeeBaseController : WKInterfaceController<AVSpeechSynthesizerDelegate>

- (void) preloadAudioFile: (NSString*) filename;
- (void) say: (NSString*) what;
- (void) playAudioFileWithCompletionHandler: (AVAudioNodeCompletionHandler)completionHandler;

@end
