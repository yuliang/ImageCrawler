//
//  PhotoGridViewController.h
//  ImageSearching
//
//  Created by Yuliang Ma on 4/5/14.
//  Copyright (c) 2014 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoGridViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *urlArray;
@end
