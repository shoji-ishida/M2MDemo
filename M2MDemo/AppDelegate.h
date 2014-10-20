//
//  AppDelegate.h
//  M2MDemo
//
//  Created by ishida on 2014/10/13.
//  Copyright (c) 2014年 ishida. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>
#import <IOBluetooth/IOBluetooth.h>

#import "MBCBeaconAdvertisementData.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSComboBoxDelegate, CBPeripheralManagerDelegate>


@end

