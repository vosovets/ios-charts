//
//  GanntBarChartViewController.m
//  ChartsDemo
//
//  Created by Vadim Osovets on 1/6/16.
//  Copyright © 2016 dcg. All rights reserved.
//

#import "GanntBarChartViewController.h"

#import "ChartsDemo-Swift.h"

@interface GanntBarChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet GantChartView *chartView;
@property (nonatomic, strong) IBOutlet UISlider *sliderX;
@property (nonatomic, strong) IBOutlet UISlider *sliderY;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextX;
@property (nonatomic, strong) IBOutlet UITextField *sliderTextY;

@property (nonatomic, strong) NSArray *tasks;

@end

@implementation GanntBarChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Gant Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
                     @{@"key": @"toggleHighlightArrow", @"label": @"Toggle Highlight Arrow"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"toggleStartZero", @"label": @"Toggle StartZero"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
                     ];
    self.tasks = @[@"3 Trinitiy task", @"2 Trinitiy task", @"1 Trinitiy task"];
//      self.tasks = @[@"1 Trinitiy task"];
    
    _chartView.delegate = self;
    
    _chartView.descriptionText = @"";
    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    _chartView.drawBarShadowEnabled = NO;
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleValueCount = 60;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawAxisLineEnabled = YES;
    xAxis.drawGridLinesEnabled = YES;
    xAxis.gridLineWidth = .3;
    
//    [xAxis setFormattedTitle:^NSString * _Nonnull(NSInteger index) {
//        
//        //        NSLog(@"Index: %@", @(index));
//        
//        if (index > [months count] || index <= 0) {
//            return @"";
//        }
//        
//        return months[index];
//    }];

    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.drawAxisLineEnabled = YES;
    leftAxis.drawGridLinesEnabled = YES;
    leftAxis.gridLineWidth = .3;
    
    _chartView.rightAxis.enabled = NO;
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
//    rightAxis.drawAxisLineEnabled = YES;
//    rightAxis.drawGridLinesEnabled = NO;
    
//    [leftAxis setForceLabelsEnabled:YES];
    // !!!
    [leftAxis setLabelCount:[months count] force:YES];
    
    [leftAxis setFormattedTitle:^NSString * _Nonnull(NSInteger index) {
        
//        NSLog(@"Index: %@", @(index));
        
        if (index > [months count] || index <= 0) {
            return @"";
        }
        
        return months[index];
    }];
    
    _chartView.legend.position = ChartLegendPositionRightOfChart;
    _chartView.legend.form = ChartLegendFormSquare;
    _chartView.legend.formSize = 8.0;
    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    _chartView.legend.xEntrySpace = 4.0;
    
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    // by amont of month as minimum
    if ([self.tasks count] < [months count]) {
        NSMutableArray *array = [NSMutableArray array];
        
        NSUInteger emptyNeeded = [months count] - [self.tasks count];
        
        for (int i = 0; i < [months count]; i++) {
            if (i < emptyNeeded) {
                [array addObject:@""];
            } else {
                [array addObject:self.tasks[i - emptyNeeded]];
            }
        }
        
        self.tasks = array;
    }
    
    // add all tasks to values for X axis
    for (int i = 0; i < [self.tasks count]; i++)
    {
        [xVals addObject:self.tasks[i]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.tasks count]; i++)
    {
        
        GanttChartData *data = [GanttChartData new];
        
        data.title = self.tasks[i];
        // TODO: calculate position according to month, from 0-11
        
        data.startPosition = [@(1) floatValue];
        data.endPosition = [@(5) floatValue];
        
        if (data.title.length > 0) {
            NSLog(@"Gannt: %@ up to %@ ", @(data.startPosition), @(data.endPosition));
        }
        
        double mult = (50 + 1);
        double val = (double) (arc4random_uniform(mult));
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i data:data]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.1;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    /*
     1. Allow to init with value/value
     
     x - months
     y - tasks
     
     2. We need to allow BarChartDataSet to be initialized with value/value instead of value/int
     
     3. Allow to show it among axis
     */
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _chartView.data = data;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_chartView.renderer drawValuesWithContext:UIGraphicsGetCurrentContext()];
//    });
    
//    [_chartView animateWithYAxisDuration:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [xVals addObject:months[i % 12]];
    }
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(mult));
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:val xIndex:i data:months[i]]];
    }
    
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"DataSet"];
    set1.barSpace = 0.35;
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    /*
     1. Allow to init with value/value
     
     x - months
     y - tasks
     
     2. We need to allow BarChartDataSet to be initialized with value/value instead of value/int
     
     3. Allow to show it among axis
     */
    
    BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    
    _chartView.data = data;
}

- (void)optionTapped:(NSString *)key
{
    if ([key isEqualToString:@"toggleValues"])
    {
        for (ChartDataSet *set in _chartView.data.dataSets)
        {
            set.drawValuesEnabled = !set.isDrawValuesEnabled;
        }
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlight"])
    {
        _chartView.data.highlightEnabled = !_chartView.data.isHighlightEnabled;
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleHighlightArrow"])
    {
        _chartView.drawHighlightArrowEnabled = !_chartView.isDrawHighlightArrowEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleStartZero"])
    {
        _chartView.leftAxis.startAtZeroEnabled = !_chartView.leftAxis.isStartAtZeroEnabled;
        _chartView.rightAxis.startAtZeroEnabled = !_chartView.rightAxis.isStartAtZeroEnabled;
        
        [_chartView notifyDataSetChanged];
    }
    
    if ([key isEqualToString:@"animateX"])
    {
        [_chartView animateWithXAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateY"])
    {
        [_chartView animateWithYAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"animateXY"])
    {
        [_chartView animateWithXAxisDuration:3.0 yAxisDuration:3.0];
    }
    
    if ([key isEqualToString:@"saveToGallery"])
    {
        [_chartView saveToCameraRoll];
    }
    
    if ([key isEqualToString:@"togglePinchZoom"])
    {
        _chartView.pinchZoomEnabled = !_chartView.isPinchZoomEnabled;
        
        [_chartView setNeedsDisplay];
    }
    
    if ([key isEqualToString:@"toggleAutoScaleMinMax"])
    {
        _chartView.autoScaleMinMaxEnabled = !_chartView.isAutoScaleMinMaxEnabled;
        [_chartView notifyDataSetChanged];
    }
}

#pragma mark - Actions

- (IBAction)slidersValueChanged:(id)sender
{
    _sliderTextX.text = [@((int)_sliderX.value + 1) stringValue];
    _sliderTextY.text = [@((int)_sliderY.value) stringValue];
    
    [self setDataCount:(_sliderX.value + 1) range:_sliderY.value];
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry dataSetIndex:(NSInteger)dataSetIndex highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}

@end
