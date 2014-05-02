//
//  SearchViewController.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/5/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField *urlTextField;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@property (nonatomic, weak) IBOutlet UILabel *instructionLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

- (IBAction)segmentedClicked:(UISegmentedControl *)sender;
- (IBAction)stepperClicked:(UIStepper *)sender;

@end
