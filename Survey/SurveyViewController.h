//
//  SecondViewController.h
//  TwoSurveys
//
//  Created by Meghan Kane on 5/4/11.
//  Copyright 2011 Massachusetts Institute of Technology. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SurveyViewController : UITableViewController {
    
  //IBOutlet UIView *headerView;
	NSMutableArray *listOfItems;
  NSMutableArray *checked;
  NSInteger *currentCategory;
    
  //@property (nonatomic, retain) UIView *headerView;
    
}

@end
