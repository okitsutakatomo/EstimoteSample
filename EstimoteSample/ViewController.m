//
//  ViewController.m
//  EstimoteSample
//
//  Created by Takatomo Okitsu on 2013/12/08.
//  Copyright (c) 2013年 Takatomo Okitsu. All rights reserved.
//


#import "ViewController.h"
#import "ESTBeaconManager.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconManager* beaconManager;
@property (nonatomic, strong) ESTBeacon* selectedBeacon;
@property (nonatomic, strong) AVSpeechSynthesizer* speechSynthesizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    //特定のEstimote Beaconで固定にする。
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initRegionWithMajor:49220
                                                                     minor:58122
                                                                identifier:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    
    [self.beaconManager startMonitoringForRegion:region];
    
    [self.beaconManager requestStateForRegion:region];
    
    _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region
{
    if (state == CLRegionStateInside) {
        NSLog(@"inside now.");
    } else if (state == CLRegionStateOutside){
        NSLog(@"outside now.");
    }
}

-(void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    [self say:@"いらっしゃいませ"];

    // present local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"いらっしゃいませ";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    [self say:@"ありがとうございました"];
    
    // present local notification
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"ありがとうございました。またのお越しをお待ちしております。";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)say:(NSString*)text
{
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    [_speechSynthesizer speakUtterance:utterance];
}

@end