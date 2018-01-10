//
//  WPFSearchResultViewController.h
//  HighlightedSearch
//
//  Created by Leon on 2017/11/22.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ReturnValueBlock)(NSString *name);
@interface WPFSearchResultViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *resultDataSource;
@property (nonatomic, copy) ReturnValueBlock returnValueBlock;
@end
