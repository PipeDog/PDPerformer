//
//  ViewController.m
//  PDPerformer
//
//  Created by liang on 2019/3/5.
//  Copyright © 2019 PipeDog. All rights reserved.
//

#import "ViewController.h"
#import "PDperformer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
    [self test1];
    [self test2];
    [self test3];
}

- (void)test {
    for (NSInteger i = 0; i < 10; i ++) {
        [PDPerformer perform:^{
            NSLog(@"i = %zd", i);
        } forKey:NSStringFromSelector(_cmd) limits:3 inSeconds:1];
    }
}

- (void)test1 {
    for (NSInteger i = 0; i < 10; i ++) {
        sleep(1);
        
        [PDPerformer perform:^{
            NSLog(@">>> i = %zd", i);
        } forKey:NSStringFromSelector(_cmd) limits:3 inSeconds:5];
    }
}

- (void)test2 {
    NSLog(@"----- test2 -----");
    for (NSInteger i = 0; i < 10; i ++) {
        [PDPerformer performTailHandler:^{
            NSLog(@"=== i = %zd", i);
        } forKey:NSStringFromSelector(_cmd) inSeconds:2];
    }
}

- (void)test3 {
    NSLog(@"----- test3 -----");

    for (NSInteger i = 0; i < 10; i ++) {
        sleep(0.5);
        
        [PDPerformer performTailHandler:^{
            NSLog(@"**** i = %zd", i);
        } forKey:NSStringFromSelector(_cmd) inSeconds:10];
    }
}

@end
