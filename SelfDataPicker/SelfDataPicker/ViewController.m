//
//  ViewController.m
//  SelfDataPicker
//
//  Created by 陈威 on 16/9/7.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "ViewController.h"
#import "DatePickerView.h"
#import "CWDatePickerView.h"
#import "NSDate+Extension.h"
#import "Define.h"
@interface ViewController ()<DeliveryDateDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ChooseTimeBtn;
@property (weak, nonatomic) IBOutlet UITextField *StartTimeTf;
@property (weak, nonatomic) IBOutlet UITextField *EndTimeTf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *nowdate = [NSDate date];
    self.StartTimeTf.text = [[nowdate beginOfDay] stringWithFormat:DATEFORM];
    self.EndTimeTf.text = [nowdate stringWithFormat:DATEFORM];
}

- (IBAction)ChooseTimeBuuttonClick:(UIButton *)sender {

    CWDatePickerView *cwdateView = [[CWDatePickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    cwdateView.delegate = self;
    cwdateView.starttimestr = self.StartTimeTf.text;
    cwdateView.endtimestr = self.EndTimeTf.text;
    [self.view addSubview:cwdateView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)DeliverystartDate:(NSDate *)startdate theendDate:(NSDate *)enddate
{
    self.StartTimeTf.text = [startdate stringWithFormat:DATEFORM];
    self.EndTimeTf.text = [enddate stringWithFormat:DATEFORM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
