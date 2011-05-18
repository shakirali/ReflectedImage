//
//  ReflectedImageViewController.m
//  ReflectedImage
//

#import "ReflectedImageViewController.h"

@interface ReflectedImageViewController ()
-(void)initImageView;
-(void)initReflectedImageView;
- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;
@end

@implementation ReflectedImageViewController

@synthesize imageView;
@synthesize reflectedImageView;

#define reflectionFraction 0.5
//#define reflectionFraction 1.0

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//initialize main image view
	[self initImageView];
	//initialize reflected image view.
	[self initReflectedImageView];
}

//initialize main image view.
-(void)initImageView{
	//load image
	UIImage* image = [UIImage imageNamed:@"bus"];
	CGRect imageViewFrame;
	imageViewFrame.size = image.size;
	imageViewFrame.origin = CGPointMake((self.view.frame.size.width - image.size.width) / 2 , (self.view.frame.size.height - image.size.height) / 2);
	imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
	imageView.image = image;
	[self.view addSubview:imageView];
}

//initialize reflected image view.
-(void)initReflectedImageView{
	// create the reflection view
	CGRect reflectionRect=self.imageView.frame;
	
	// determine the size of the reflection to create. The reflection is a fraction of the size of the view being reflected
	NSUInteger reflectionHeight=self.imageView.bounds.size.height*reflectionFraction;
	
	// the reflection is a fraction of the size of the view being reflected
	reflectionRect.size.height=reflectionHeight;
	
	// and is offset to be at the bottom of the view being reflected
	reflectionRect=CGRectOffset(reflectionRect,0,self.imageView.frame.size.height);
	
	reflectedImageView = [[UIImageView alloc] initWithFrame:reflectionRect];
	
	// create the reflection image, assign it to the UIImageView and add the image view to the containerView
	reflectedImageView.image=[self reflectedImage:imageView withHeight:reflectionHeight];
		
	[self.view addSubview:reflectedImageView];
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	//create RGB color space.
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	// create a bitmap graphics context the size of the image with height given in the function parameter.
	CGContextRef bitmapContext = CGBitmapContextCreate(NULL, fromImage.bounds.size.width, height, 8, 0, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	
	//Bitmap context coordinate start from bottom left. Set the coordinate to top left just like UIView and CALayer.
	CGContextTranslateCTM(bitmapContext, 0.0, height);
	//flip the coordinate space so that when is image is drawn it is drawn upside down.
	CGContextScaleCTM(bitmapContext, 1.0, -1.0);
	
	//draw image in the context.
	CGContextDrawImage(bitmapContext,fromImage.bounds, fromImage.image.CGImage);
	
	//Get the image from the context.
	CGImageRef reflectionImage = CGBitmapContextCreateImage(bitmapContext);
	CGContextRelease(bitmapContext);
	CGColorSpaceRelease(colorSpace);
	
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	CGImageRelease(reflectionImage);
	
	return theImage;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.imageView = nil;
	self.reflectedImageView = nil;
}


- (void)dealloc {
	[imageView release];
	[reflectedImageView release];
    [super dealloc];
}

@end
