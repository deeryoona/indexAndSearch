//
//  ViewController.m
//  iOSBlog
//
//  Created by luo.h on 15/8/24.
//  Copyright (c) 2015年 sibu.cn. All rights reserved.
//

#import "ViewController.h"
#import "contactModel.h"
#import "NSArray+ContactArray.h"
#import "MJNIndexView.h"
#import "WPFPerson.h"
#import "WPFPinYinDataManager.h"
#import "WPFSearchResultViewController.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate,MJNIndexViewDataSource>{
    NSArray *defineDataArray;
}
@property (nonatomic, strong) UIFont *font;
@property(nonatomic,strong)  UITableView *tableView;
@property(nonatomic,strong)  NSMutableArray     *dataArray;
@property(nonatomic,strong)  NSArray     *indexArray;
@property (nonatomic, strong) UISearchController *searchVC;
@property(nonatomic,strong) NSMutableArray    *filteredPersons;         //搜索过滤后  搜索结果
@property (nonatomic, strong) WPFSearchResultViewController *searchResultVC;
@property(nonatomic, strong) MJNIndexView *indexView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
}
#pragma mark--- UITableViewDataSource and UITableViewDelegate Methods---
//在tableview中有多少个分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.tableView) {
        return self.indexArray.count;
    }
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dict = self.indexArray[section];
    return [dict[@"content"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
    }
    contactModel *model;
    NSDictionary *dict = self.indexArray[indexPath.section];
    model=dict[@"content"][indexPath.row];
    cell.textLabel.text=model.contactName;
    cell.detailTextLabel.text=model.contactUrl;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 33;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    headerView.textLabel.font = [UIFont fontWithName:self.indexView.selectedItemFont.fontName size:headerView.textLabel.font.pointSize];
    [[headerView textLabel] setText:[NSString stringWithFormat:@"%@",self.indexArray[section][@"firstLetter"]]];
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchVC.searchBar resignFirstResponder];
    [self.searchVC.searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - MJNIndexViewDataSource
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
        NSMutableArray *resultArray =[NSMutableArray new];
        for (NSDictionary *dict in self.indexArray) {
            NSString *title = dict[@"firstLetter"];
            [resultArray addObject:title];
        }
        return resultArray;
}


- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
}

#pragma mark - UISearchBarDelegate & UISearchResultsUpdating & UISearchControllerDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchVC.searchBar setShowsCancelButton:YES animated:NO];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [self.searchVC.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
}
// 更新搜索结果
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *keyWord = searchController.searchBar.text.lowercaseString;
    NSLog(@"%@", keyWord);
    NSDate *beginTime = [NSDate date];
    NSLog(@"开始匹配，开始时间：%@", beginTime);
    NSMutableArray *resultDataSource = [NSMutableArray array];
    for (WPFPerson *person in [WPFPinYinDataManager getInitializedDataSource]) {
        WPFSearchResultModel *resultModel = [WPFPinYinTools searchEffectiveResultWithSearchString:keyWord Person:person];

        if (resultModel.highlightedRange.length) {
            person.highlightLoaction = resultModel.highlightedRange.location;
            person.textRange = resultModel.highlightedRange;
            person.matchType = resultModel.matchType;
            [resultDataSource addObject:person];
        }
    }
    self.searchResultVC.resultDataSource = resultDataSource;
    [self.searchResultVC.resultDataSource sortUsingDescriptors:[WPFPinYinTools sortingRules]];
    
    NSDate *endTime = [NSDate date];
    NSTimeInterval costTime = [endTime timeIntervalSinceDate:beginTime];
    NSLog(@"匹配结束，结束时间：%@，耗时：%.4f", endTime, costTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.searchResultVC.tableView reloadData];
    });
}
- (void)willPresentSearchController:(UISearchController *)searchController {
    UITableView *resultTableView = self.searchResultVC.tableView;

    CGRect rect = resultTableView.frame;
    rect.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height +self.navigationController.navigationBar.frame.size.height;
    rect.size.height = [UIScreen mainScreen].bounds.size.height - rect.origin.y;
    resultTableView.frame = rect;
}
#pragma mark - 懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0,64,kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"REUSE_CELLID"];
        [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
        _tableView.contentSize=CGSizeMake(kScreen_Width,kScreen_Height*2);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        _tableView.sectionIndexBackgroundColor=[UIColor clearColor];//索引背景色
        _tableView.sectionIndexColor=[UIColor redColor];//索引背景色
    }
    return _tableView;
}
- (WPFSearchResultViewController *)searchResultVC {
    if (!_searchResultVC) {
        _searchResultVC = [[WPFSearchResultViewController alloc] init];
        __weak typeof(self)wSelf = self;
        _searchResultVC.returnValueBlock = ^(NSString *name) {
            [wSelf scrollToIndexCellWithName:name];
    
        };
    }
    return _searchResultVC;
}
- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        // 是否添加半透明遮罩；默认为YES
        _searchVC.dimsBackgroundDuringPresentation = NO;
        // NO表示UISearchController在present时，可以覆盖当前controller，默认为NO
        _searchVC.definesPresentationContext = NO;
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.delegate = self;
    }
    return _searchVC;
}
#pragma mark - 索引样式
- (void)firstAttributesForMJNIndexView
{
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = NO;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 30.0;
    self.indexView.lowerMargin = 124.0;
    self.indexView.rightMargin = 10.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 80.0;
    self.indexView.rangeOfDeflection = 3;
    self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
    
}
- (void)readAttributes
{
    self.getSelectedItemsAfterPanGestureIsFinished = self.indexView.getSelectedItemsAfterPanGestureIsFinished;
    self.font = self.indexView.font;
    self.selectedItemFont = self.indexView.selectedItemFont;
    self.fontColor = self.indexView.fontColor;
    self.selectedItemFontColor = self.indexView.selectedItemFontColor;
    self.darkening = self.indexView.darkening;
    self.fading = self.indexView.fading;
    self.itemsAligment = self.indexView.itemsAligment;
    self.rightMargin = self.indexView.rightMargin;
    self.upperMargin = self.indexView.upperMargin;
    self.lowerMargin = self.indexView.lowerMargin;
    self.maxItemDeflection = self.indexView.maxItemDeflection;
    self.rangeOfDeflection = self.indexView.rangeOfDeflection;
    self.curtainColor = self.indexView.curtainColor;
    self.curtainFade = self.indexView.curtainFade;
    self.curtainMargins = self.indexView.curtainMargins;
    self.curtainStays = self.indexView.curtainStays;
    self.curtainMoves = self.indexView.curtainMoves;
    self.ergonomicHeight = self.indexView.ergonomicHeight;
}
#pragma mark - Actions
- (void)scrollToIndexCellWithName:(NSString *)name{
    for (int i = 0; i < self.indexArray.count; i++) {
        NSDictionary *dict = self.indexArray[i];
        NSArray *array = dict[@"content"];
        for (int j = 0; j <array.count ; j++) {
            contactModel *model = array[j];
            if ([name isEqualToString:model.contactName]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] atScrollPosition: UITableViewScrollPositionTop animated:self.getSelectedItemsAfterPanGestureIsFinished];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
        }
    }
}
- (void)setData{
    defineDataArray=@[
                      @{ @"contact":@"张三",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"王二",
                         @"conatctUrl":@"1536065332"},
                      @{ @"contact":@"jake",
                         @"conatctUrl":@"1736235332"},
                      @{ @"contact":@"preyy2",
                         @"conatctUrl":@"183683325332"},
                      @{ @"contact":@"杰西",
                         @"conatctUrl":@"147360992452"},
                      @{ @"contact":@"lulu",
                         @"conatctUrl":@"147456140992"},
                      @{ @"contact":@"哈尼",
                         @"conatctUrl":@"189234342"},
                      @{ @"contact":@"陆军",
                         @"conatctUrl":@"15475654785"},
                      @{ @"contact":@"是的",
                         @"conatctUrl":@"1873895343"},
                      @{ @"contact":@"身份",
                         @"conatctUrl":@"15688382345"},
                      @{ @"contact":@"爱德华",
                         @"conatctUrl":@"14754565443"},
                      @{ @"contact":@"梅长苏",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"杨戬",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"大B哥",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"C罗",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"Edison 陈冠希",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"方杰",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"GAI",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"Nike",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"Mery",
                         @"conatctUrl":@"1836065332"},
                      @{ @"contact":@"西西",
                         @"conatctUrl":@"1836065332"},
                      ];
    [self.view addSubview:[UIView new]];
    _filteredPersons = [NSMutableArray array];
    _dataArray=[NSMutableArray array];
    for (NSDictionary *dict in defineDataArray) {
        contactModel  *model = [[contactModel alloc] init];
        model.contactName=dict[@"contact"];
        model.contactUrl=dict[@"conatctUrl"];
        [_dataArray addObject:model];
    }
    //索引
    self.indexArray=[self.dataArray arrayWithPinYinFirstLetter];
    for (NSInteger i = 0; i < self.dataArray.count; ++i) {
        @autoreleasepool {
            contactModel *model = self.dataArray[i];
            NSString *name = model.contactName;
            [WPFPinYinDataManager addInitializeString:name identifer:[@(i) stringValue]];
        }
    }
    self.tableView.keyboardDismissMode=UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableView];
    
    self.indexView = [[MJNIndexView alloc]initWithFrame:self.tableView.frame];
    self.indexView.dataSource = self;
    [self firstAttributesForMJNIndexView];
    [self readAttributes];
    [self.view addSubview:self.indexView];
    self.navigationItem.titleView = self.searchVC.searchBar;
}
@end
