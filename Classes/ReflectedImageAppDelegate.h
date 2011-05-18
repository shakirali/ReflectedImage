//
//  ReflectedImageAppDelegate.h
//  ReflectedImage
//

#import <UIKit/UIKit.h>

@class ReflectedImageViewController;

@interface ReflectedImageAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ReflectedImageViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ReflectedImageViewController *viewController;

@end

