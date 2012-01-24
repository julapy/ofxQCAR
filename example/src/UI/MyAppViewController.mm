//
//  MenuViewController.m
//  emptyExample
//
//  Created by lukasz karluk on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MyAppViewController.h"
#import "ofxQCAR_ViewController.h"
#import "testApp.h"

@implementation MyAppViewController

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
}

- (void)loadView  
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor blackColor ];
    
    UIImageView* backgroundView;
    backgroundView = [[[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"Default.png"]] autorelease];
    backgroundView.alpha = 0.1;
    [ self.view addSubview: backgroundView ];
    
    CGRect screenRect = [[ UIScreen mainScreen ] bounds ];
    
    CGRect scrollViewFrame = CGRectMake(0.f,
                                        0.f,
                                        screenRect.size.width,
                                        screenRect.size.height);
    
    UIScrollView* containerView = [[[UIScrollView alloc] initWithFrame:scrollViewFrame] autorelease];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    containerView.showsHorizontalScrollIndicator = NO;
    containerView.showsVerticalScrollIndicator = YES;
    containerView.alwaysBounceVertical = YES;
    [self.view addSubview:containerView];

    int buttonH = screenRect.size.height * 0.4;
    int buttonY = ( screenRect.size.height - 44 - buttonH ) * 0.5 - 10;
    CGRect buttonRect = CGRectMake( 0, buttonY, screenRect.size.width, buttonH );

    UIButton *button;
    button = [ self makeButtonWithFrame : buttonRect
                                andText : @"Launch QCAR" ];
    [ button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [ containerView addSubview : button ];
    
    containerView.contentSize = CGSizeMake( buttonRect.size.width, buttonRect.size.height * 3 );
}

- (UIButton*) makeButtonWithFrame : (CGRect)frame 
                          andText : (NSString*)text
{
    UIFont *font;
    font = [ UIFont fontWithName:@"Georgia" size:40 ];
    
    UILabel *label;
    label = [[[ UILabel alloc ] initWithFrame: CGRectMake( 0, 0, frame.size.width, frame.size.height ) ] autorelease ];
    label.backgroundColor = [ UIColor colorWithWhite: 1 alpha: 0.95 ];
    label.textColor = [ UIColor colorWithWhite: 0 alpha: 1 ];
    label.text = text;
    label.textAlignment = UITextAlignmentCenter;
    label.font = font;
    label.userInteractionEnabled = NO;
    label.exclusiveTouch = NO;
    
    UIButton* button = [[[ UIButton alloc ] initWithFrame: frame ] autorelease ];
    [ button setBackgroundColor: [ UIColor clearColor ] ];
    [ button addSubview: label ];
    
    return button;
    
}

- (void)buttonPressed:(id)sender
{
    [ self creatApp: new testApp() withFrame: [ [ UIScreen mainScreen ] bounds ] ];
    self.navigationController.navigationBar.topItem.title = @"Qualcomm AR";
}

- (void) creatApp : (ofBaseApp*)app withFrame : (CGRect)rect
{
    ofxQCAR_ViewController *glViewController;
    glViewController = [[[ ofxQCAR_ViewController alloc ] initWithFrame : rect
                                                                    app : app ] autorelease ];
    
    [ self.navigationController pushViewController : glViewController
                                          animated : YES ];
}

@end
