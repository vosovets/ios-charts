//
//  DemoListViewController.m
//  ChartsDemo
//
//  Created by Daniel Cohen Gindi on 23/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

#import "DemoListViewController.h"
#import "LineChart1ViewController.h"
#import "LineChart2ViewController.h"
#import "BarChartViewController.h"
#import "HorizontalBarChartViewController.h"
#import "CombinedChartViewController.h"
#import "PieChartViewController.h"
#import "ScatterChartViewController.h"
#import "StackedBarChartViewController.h"
#import "NegativeStackedBarChartViewController.h"
#import "AnotherBarChartViewController.h"
#import "MultipleLinesChartViewController.h"
#import "MultipleBarChartViewController.h"
#import "CandleStickChartViewController.h"
#import "CubicLineChartViewController.h"
#import "RadarChartViewController.h"
#import "ColoredLineChartViewController.h"
#import "SinusBarChartViewController.h"
#import "BubbleChartViewController.h"

#import "GanntBarChartViewController.h"

@interface DemoListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *itemDefs;
@end

@implementation DemoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Charts Demonstration";

    self.itemDefs = @[
                      
                      @{
                          @"title": @"Gantt Bar Chart",
                          @"subtitle": @"A simple demonstration of the Gantt bar chart.",
                          @"class": GanntBarChartViewController.class
                          },
                      @{
                          @"title": @"Line Chart",
                          @"subtitle": @"A simple demonstration of the linechart.",
                          @"class": LineChart1ViewController.class
                          },
                      @{
                          @"title": @"Line Chart (Dual YAxis)",
                          @"subtitle": @"Demonstration of the linechart with dual y-axis.",
                          @"class": LineChart2ViewController.class
                          },
                      @{
                          @"title": @"Bar Chart",
                          @"subtitle": @"A simple demonstration of the bar chart.",
                          @"class": BarChartViewController.class
                          },
                      @{
                          @"title": @"Horizontal Bar Chart",
                          @"subtitle": @"A simple demonstration of the horizontal bar chart.",
                          @"class": HorizontalBarChartViewController.class
                          },
                      @{
                          @"title": @"Combined Chart",
                          @"subtitle": @"Demonstrates how to create a combined chart (bar and line in this case).",
                          @"class": CombinedChartViewController.class
                          },
                      @{
                          @"title": @"Pie Chart",
                          @"subtitle": @"A simple demonstration of the pie chart.",
                          @"class": PieChartViewController.class
                          },
                      @{
                          @"title": @"Scatter Chart",
                          @"subtitle": @"A simple demonstration of the scatter chart.",
                          @"class": ScatterChartViewController.class
                          },
                      @{
                          @"title": @"Bubble Chart",
                          @"subtitle": @"A simple demonstration of the bubble chart.",
                          @"class": BubbleChartViewController.class
                          },
                      @{
                          @"title": @"Stacked Bar Chart",
                          @"subtitle": @"A simple demonstration of a bar chart with stacked bars.",
                          @"class": StackedBarChartViewController.class
                          },
                      @{
                          @"title": @"Stacked Bar Chart Negative",
                          @"subtitle": @"A simple demonstration of stacked bars with negative and positive values.",
                          @"class": NegativeStackedBarChartViewController.class
                          },
                      @{
                          @"title": @"Another Bar Chart",
                          @"subtitle": @"Implementation of a BarChart that only shows values at the bottom.",
                          @"class": AnotherBarChartViewController.class
                          },
                      @{
                          @"title": @"Multiple Lines Chart",
                          @"subtitle": @"A line chart with multiple DataSet objects. One color per DataSet.",
                          @"class": MultipleLinesChartViewController.class
                          },
                      @{
                          @"title": @"Multiple Bars Chart",
                          @"subtitle": @"A bar chart with multiple DataSet objects. One multiple colors per DataSet.",
                          @"class": MultipleBarChartViewController.class
                          },
                      @{
                          @"title": @"Candle Stick Chart",
                          @"subtitle": @"Demonstrates usage of the CandleStickChart.",
                          @"class": CandleStickChartViewController.class
                          },
                      @{
                          @"title": @"Cubic Line Chart",
                          @"subtitle": @"Demonstrates cubic lines in a LineChart.",
                          @"class": CubicLineChartViewController.class
                          },
                      @{
                          @"title": @"Radar Chart",
                          @"subtitle": @"Demonstrates the use of a spider-web like (net) chart.",
                          @"class": RadarChartViewController.class
                          },
                      @{
                          @"title": @"Colored Line Chart",
                          @"subtitle": @"Shows a LineChart with different background and line color.",
                          @"class": ColoredLineChartViewController.class
                          },
                      @{
                          @"title": @"Sinus Bar Chart",
                          @"subtitle": @"A Bar Chart plotting the sinus function with 8.000 values.",
                          @"class": SinusBarChartViewController.class
                          },
                      ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemDefs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *def = self.itemDefs[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = def[@"title"];
    cell.detailTextLabel.text = def[@"subtitle"];
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *def = self.itemDefs[indexPath.row];
    
    Class vcClass = def[@"class"];
    UIViewController *vc = [[vcClass alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#warning ONLY for testing

- (void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *def = self.itemDefs[0];
        
        Class vcClass = def[@"class"];
        UIViewController *vc = [[vcClass alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];

    });
}

@end
