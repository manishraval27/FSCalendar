//
//  FSCalendarWeekdayView.m
//  FSCalendar
//
//  Created by dingwenchao on 03/11/2016.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "FSCalendar.h"
#import "NSLocale+Category.h"
#import "NSString+Category.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarWeekdayView.h"
#import "FSCalendarDynamicHeader.h"

@interface FSCalendarWeekdayView()

@property (strong, nonatomic) NSPointerArray *weekdayPointers;
@property (weak  , nonatomic) UIView *contentView;
@property (weak  , nonatomic) FSCalendar *calendar;

- (void)commonInit;

@end

@implementation FSCalendarWeekdayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:contentView];
    _contentView = contentView;
    
    _weekdayPointers = [NSPointerArray weakObjectsPointerArray];
    for (int i = 0; i < 7; i++) {
        UILabel *weekdayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:weekdayLabel];
        [_weekdayPointers addPointer:(__bridge void * _Nullable)(weekdayLabel)];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    // Position Calculation
    NSInteger count = self.weekdayPointers.count;
    size_t size = sizeof(CGFloat)*count;
    CGFloat *widths = malloc(size);
    CGFloat contentWidth = self.contentView.fs_width;
    FSCalendarSliceCake(contentWidth, count, widths);
    
    CGFloat x = 0;
    for (NSInteger i = 0; i < count; i++) {
        CGFloat width = widths[i];
        UILabel *label = [self.weekdayPointers pointerAtIndex:i];
        label.frame = CGRectMake(x, 0, width, self.contentView.fs_height);
        x += width;
    }
    free(widths);
}

- (void)setCalendar:(FSCalendar *)calendar
{
    _calendar = calendar;
    [self configureAppearance];
}

- (NSArray<UILabel *> *)weekdayLabels
{
    return self.weekdayPointers.allObjects;
}

- (void)configureAppearance
{
    BOOL useVeryShortWeekdaySymbols = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    NSArray *weekdaySyms = useVeryShortWeekdaySymbols ? self.calendar.gregorian.veryShortStandaloneWeekdaySymbols : self.calendar.gregorian.shortStandaloneWeekdaySymbols;
    NSMutableArray *weekdaySymbols = [NSMutableArray.alloc initWithArray:weekdaySyms];
    BOOL useDefaultWeekdayCase = (self.calendar.appearance.caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesDefaultCase;
    
//    NSInteger firstWeek = self.calendar.firstWeekday;
    BOOL isRtl = [_calendar.calendarIdentifier isRTLCalendar] && [_calendar.locale isRtlLocale];
    if (isRtl && [_calendar.locale.localeIdentifier isEqualToString:@"fa-IR"]) {
        NSString *last = weekdaySymbols.lastObject;
        [weekdaySymbols removeObject:last];
        [weekdaySymbols insertObject:last atIndex:0];
        
//        weekdaySymbols = [[[weekdaySymbols reverseObjectEnumerator] allObjects] mutableCopy];
    }
    for (NSInteger i = 0; i < self.weekdayPointers.count; i++) {
        NSInteger index = i;//(i + firstWeek-1) % 7;
        UILabel *label = [self.weekdayPointers pointerAtIndex:i];
        label.font = self.calendar.appearance.weekdayFont;
        label.textColor = self.calendar.appearance.weekdayTextColor;
        label.text = useDefaultWeekdayCase ? weekdaySymbols[index] : [weekdaySymbols[index] uppercaseString];
        
        if (isRtl) {
            if (self.calendar.pagingEnabled) {
                label.accessibilityLanguage = @"Persian";
                [label setTransform:CGAffineTransformMakeScale(-1,1)];
            }
        } else if ([label.accessibilityLanguage isEqualToString:@"Persian"]) {
            label.accessibilityLanguage = @"English";
            [label setTransform:CGAffineTransformMakeScale(-1,1)];
        }
    }
}

@end
