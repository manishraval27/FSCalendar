//
//  RollViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 10/16/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import "DelegateAppearanceViewController.h"

#define kViolet [UIColor colorWithRed:170/255.0 green:114/255.0 blue:219/255.0 alpha:1.0]

NS_ASSUME_NONNULL_BEGIN

@interface DelegateAppearanceViewController()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter1;
@property (strong, nonatomic) NSDateFormatter *dateFormatter2;

@property (strong, nonatomic) NSDictionary *fillSelectionColors;
@property (strong, nonatomic) NSDictionary *fillDefaultColors;
@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) NSArray *datesWithEvent;
@property (strong, nonatomic) NSArray *datesWithMultipleEvents;

@end

NS_ASSUME_NONNULL_END

@implementation DelegateAppearanceViewController

#pragma mark - Life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        
        self.fillDefaultColors = @{@"2018/03/08":[UIColor purpleColor],
                                     @"2018/03/06":[UIColor greenColor],
                                     @"2018/03/18":[UIColor cyanColor],
                                     @"2018/03/22":[UIColor yellowColor],
                                     @"2018/02/08":[UIColor purpleColor],
                                     @"2018/02/06":[UIColor greenColor],
                                     @"2018/02/18":[UIColor cyanColor],
                                     @"2018/02/22":[UIColor yellowColor],
                                     @"2018/04/08":[UIColor purpleColor],
                                     @"2018/04/06":[UIColor greenColor],
                                     @"2018/04/18":[UIColor cyanColor],
                                     @"2018/04/22":[UIColor magentaColor]};
        
        self.fillSelectionColors = @{@"2018/03/08":[UIColor greenColor],
                                 @"2018/03/06":[UIColor purpleColor],
                                 @"2018/03/17":[UIColor grayColor],
                                 @"2018/03/21":[UIColor cyanColor],
                                 @"2018/02/08":[UIColor greenColor],
                                 @"2018/02/06":[UIColor purpleColor],
                                 @"2018/02/17":[UIColor grayColor],
                                 @"2018/02/21":[UIColor cyanColor],
                                 @"2018/04/08":[UIColor greenColor],
                                 @"2018/04/06":[UIColor purpleColor],
                                 @"2018/04/17":[UIColor grayColor],
                                 @"2018/04/21":[UIColor cyanColor]};
        
        self.borderDefaultColors = @{@"2018/03/08":[UIColor brownColor],
                                     @"2018/03/17":[UIColor magentaColor],
                                     @"2018/03/21":FSCalendarStandardSelectionColor,
                                     @"2018/03/25":[UIColor blackColor],
                                     @"2018/02/08":[UIColor brownColor],
                                     @"2018/02/17":[UIColor magentaColor],
                                     @"2018/02/21":FSCalendarStandardSelectionColor,
                                     @"2018/02/25":[UIColor blackColor],
                                     @"2018/04/08":[UIColor brownColor],
                                     @"2018/04/17":[UIColor magentaColor],
                                     @"2018/04/21":FSCalendarStandardSelectionColor,
                                     @"2018/04/25":[UIColor blackColor]};
        
        self.borderSelectionColors = @{@"2018/03/08":[UIColor redColor],
                                       @"2018/03/17":[UIColor purpleColor],
                                       @"2018/03/21":FSCalendarStandardSelectionColor,
                                       @"2018/03/25":FSCalendarStandardTodayColor,
                                       @"2018/02/08":[UIColor redColor],
                                       @"2018/02/17":[UIColor purpleColor],
                                       @"2018/02/21":FSCalendarStandardSelectionColor,
                                       @"2018/02/25":FSCalendarStandardTodayColor,
                                       @"2018/04/08":[UIColor redColor],
                                       @"2018/04/17":[UIColor purpleColor],
                                       @"2018/04/21":FSCalendarStandardSelectionColor,
                                       @"2018/04/25":FSCalendarStandardTodayColor};
        
        
        self.datesWithEvent = @[@"2018-03-03",
                            @"2018-03-06",
                            @"2018-03-12",
                            @"2018-03-25"];
        
        self.datesWithMultipleEvents = @[@"2018-03-08",
                                     @"2018-03-16",
                                     @"2018-03-20",
                                     @"2018-03-28"];
        
        
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierPersian];
        
        self.dateFormatter1 = [[NSDateFormatter alloc] init];
        self.dateFormatter1.dateFormat = @"yyyy/MM/dd";
        
        self.dateFormatter2 = [[NSDateFormatter alloc] init];
        self.dateFormatter2.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    CGFloat height = [[UIDevice currentDevice].model hasPrefix:@"iPad"] ? 450 : 300;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, height)];
    
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"fa-IR"];
    calendar.calendarIdentifier = NSCalendarIdentifierPersian;
    calendar.firstWeekday = 7;
    
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.allowsMultipleSelection = YES;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.backgroundColor = [UIColor whiteColor];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    [self.view addSubview:calendar];
    self.calendar = calendar;
    
    [calendar setCurrentPage:[self.dateFormatter1 dateFromString:@"2018/03/01"] animated:NO];
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc] initWithTitle:@"TODAY" style:UIBarButtonItemStylePlain target:self action:@selector(todayItemClicked:)];
    self.navigationItem.rightBarButtonItem = todayItem;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // For UITest
    self.calendar.accessibilityIdentifier = @"calendar";
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - Target actions

- (void)todayItemClicked:(id)sender
{
    [_calendar setCurrentPage:[NSDate date] animated:NO];
}

#pragma mark - <FSCalendarDataSource>

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return 1;
    }
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        return 3;
    }
    return 0;
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter2 dateFromString:@"2016-07-08"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter2 dateFromString:@"2020-07-08"];
}

#pragma mark - <FSCalendarDelegateAppearance>

- (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter2 stringFromDate:date];
    if ([_datesWithMultipleEvents containsObject:dateString]) {
        return @[[UIColor magentaColor],appearance.eventDefaultColor,[UIColor blackColor]];
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillSelectionColors.allKeys containsObject:key]) {
        return _fillSelectionColors[key];
    }
    return appearance.selectionColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_fillDefaultColors.allKeys containsObject:key]) {
        return _fillDefaultColors[key];
    }
    return nil;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_borderDefaultColors.allKeys containsObject:key]) {
        return _borderDefaultColors[key];
    }
    return appearance.borderDefaultColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter1 stringFromDate:date];
    if ([_borderSelectionColors.allKeys containsObject:key]) {
        return _borderSelectionColors[key];
    }
    return appearance.borderSelectionColor;
}

- (CGFloat)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderRadiusForDate:(nonnull NSDate *)date
{
    if ([@[@8,@17,@21,@25] containsObject:@([self.gregorian component:NSCalendarUnitDay fromDate:date])]) {
        return 0.0;
    }
    return 1.0;
}

@end
