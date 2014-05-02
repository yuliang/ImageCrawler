//
//  SearchViewController.m
//  ImageSearching
//
//  Created by Yuliang Ma on 4/5/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import "SearchViewController.h"
#import "ImageSearcher.h"
#import "MBProgressHUD.h"
#import "PhotoGridViewController.h"
#define DEFAULT_DEPTH_LIMIT 50
#define DEFAULT_BREATH_LIMIT 5
#define DEPTH_TEXT @"Limit on # of sites"
#define BREATH_TEXT @"Limit on # of levels"

@interface SearchViewController ()<MBProgressHUDDelegate, UITextFieldDelegate> {
    MBProgressHUD *HUD;
}
@property (nonatomic, assign) BOOL depthFirst;
@end

@implementation SearchViewController

- (void)addInset:(CGFloat)inset toField:(UITextField *)field {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, inset, field.bounds.size.height)];
    field.leftView = leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search";
    self.depthFirst = YES;
    self.stepper.value = DEFAULT_DEPTH_LIMIT;
    self.stepper.minimumValue = 1.0;
    self.urlTextField.layer.borderColor = [[UIColor colorWithRed:0/255.0f
                                                                green:0/255.0f
                                                                 blue:0/255.0f
                                                                alpha:0.21f]CGColor];
    self.urlTextField.layer.borderWidth=1.0;
    
    [self addInset:10.0 toField:self.urlTextField];
    
    //[self.urlTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    if (textField.text.length > 1) {
        [[ImageSearcher sharedSingleton] clearCache];
        __block PhotoGridViewController *photoVC = [[PhotoGridViewController alloc] init];
        photoVC.title = textField.text;
        [self.navigationController pushViewController:photoVC animated:YES];
        /*
         http://boingboing.net
         http://www.bbc.co.uk/news
         http://www.cnn.com
         http://www.marketwatch.com
         */
        NSString *url = textField.text;
        HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:HUD];
        HUD.labelText = @"Searching images...";
        [HUD show:YES];
        
        [[ImageSearcher sharedSingleton] recursivelyFindImagesFromURL:url depthFirst:self.depthFirst limit:(int)self.stepper.value completionHandler:^(NSSet *set, NSError *error) {
            [HUD hide:YES];
            if (error && (!set || set.count == 0)) {
                NSLog(@"Printing out error: %@", [error localizedDescription]);
            } else {
                //for (NSString *imageURL in set) NSLog(@"imageURL: %@", imageURL);
                
                NSLog(@"%lu images found", (unsigned long)set.count);
                photoVC.title = [NSString stringWithFormat:@"%lu found", (unsigned long)set.count];
                photoVC.urlArray = [set allObjects];
                [photoVC.collectionView reloadData];
                [photoVC.collectionView flashScrollIndicators];
            }
        }];
    }
    return YES;
}

- (IBAction)segmentedClicked:(UISegmentedControl *)sender {
    self.stepper.maximumValue = (self.depthFirst) ? 200.0 : 15.0;
    if (sender.selectedSegmentIndex == 0) {
        self.depthFirst = YES;
        self.instructionLabel.text = DEPTH_TEXT;
        self.numberLabel.text = [NSString stringWithFormat:@"%d", DEFAULT_DEPTH_LIMIT];
        self.stepper.value = DEFAULT_DEPTH_LIMIT;
    } else {
        self.depthFirst = NO;
        self.instructionLabel.text = BREATH_TEXT;
        self.numberLabel.text = [NSString stringWithFormat:@"%d", DEFAULT_BREATH_LIMIT];
        self.stepper.value = DEFAULT_BREATH_LIMIT;
    }
}

- (IBAction)stepperClicked:(UIStepper *)sender {
    sender.maximumValue = (self.depthFirst) ? 200.0 : 15.0;
    self.numberLabel.text = [NSString stringWithFormat:@"%d", (int)[sender value]];
}
@end
