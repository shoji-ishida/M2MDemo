//
//  AppDelegate.m
//  M2MDemo
//
//  Created by ishida on 2014/10/13.
//  Copyright (c) 2014年 ishida. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSComboBox *Appliance;
@property (weak) IBOutlet NSComboBox *Message;
@property NSArray *plist;

@property (strong, nonatomic) CBPeripheralManager *manager;
@property (nonatomic) CBPeripheralManager *peripheral;
@property (nonatomic) MBCBeaconAdvertisementData *beaconData;
@end

@implementation AppDelegate

NSUUID *proximityUUID;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSString* path = [[NSBundle mainBundle] pathForResource:@"ApplianceList" ofType:@"plist"];
    self.plist = [NSArray arrayWithContentsOfFile:path];
    //NSLog(@"%@", plist);
    
    proximityUUID = [[NSUUID alloc]    initWithUUIDString:@"7B5FA67D-5B28-422A-A028-9C537ACCDE0B"];
    
    NSEnumerator *enumerator =[self.plist objectEnumerator];
    id obj;
    while(obj =[enumerator nextObject]){
        NSDictionary *dict = (NSDictionary*)obj;
        NSString *name = [dict objectForKey:(@"name")];
        [self.Appliance insertItemWithObjectValue:name atIndex:[self.Appliance numberOfItems]];
    }
    [self.Appliance setDelegate:self];
    [self.Appliance selectItemAtIndex:(0)];
    [self setMsg:(self.plist)];
    
    // CBPeripheralManagerを初期化
    self.manager = [[CBPeripheralManager alloc]initWithDelegate:self
                                                          queue:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    [self setMsg:(self.plist)];
}

- (IBAction)pushSend:(id)sender {
    NSInteger major = self.Appliance.indexOfSelectedItem;
    NSInteger minor = self.Message.indexOfSelectedItem;
    
    NSLog(@"Sending Beacon %@, %ld, %ld", proximityUUID, (long)major, (long)minor);
    [self setAdvertisementData];
    
    [self startAdvertise];
}

-(void)setMsg:(NSArray *)plist {
    NSInteger id = self.Appliance.indexOfSelectedItem;
    NSDictionary *dict = (NSDictionary*)[plist objectAtIndex:(id)];
    NSArray *array = [dict objectForKey:@"msgs"];
    [self.Message removeAllItems];
    [self.Message addItemsWithObjectValues:(array)];
    [self.Message selectItemAtIndex:(0)];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    // Bluetoothがオンのときにアドバタイズする
    self.peripheral = peripheral;
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        
        NSLog(@"Good to advertise");
        //[self startAdvertise];
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    NSLog(@"peripheralManagerDidStartAdvertising");
    [NSThread sleepForTimeInterval:1.0];
    [self stopAdvertise];
}

-(void) setAdvertisementData {
    // アドバタイズ用のデータを作成
    self.beaconData
    = [[MBCBeaconAdvertisementData alloc] initWithProximityUUID:proximityUUID
                                                          major:self.Appliance.indexOfSelectedItem
                                                          minor:self.Message.indexOfSelectedItem
                                                  measuredPower:-59];
}
-(void) startAdvertise {
    if (!self.manager.isAdvertising && self.peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheral startAdvertising:self.beaconData.beaconAdvertisement];
    }
}

-(void)stopAdvertise {
    if (self.manager.isAdvertising && self.peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheral stopAdvertising];
    }
}

@end
