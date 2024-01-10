//
//  ViewController.m
//  CSSDKOCDemo
//
//  Created by Lee on 26/07/2022.
//

#import "ViewController.h"
#import <CrazySnake/CrazySnake.h>

@interface ViewController ()

typedef BOOL (^MyBlock)(void);

@property (nonatomic, copy) MyBlock testWaiting;
@property (nonatomic, assign) BOOL isCancelWaiting;

@end

@implementation ViewController

//@"pluck apple grace buzz oxygen else female order dragon fluid collect tuition"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [CrazyPlatform initSDKWithType:2 language:1];
    [CrazyPlatform initSDKWithGameId:1 environment:2 language:1 deviceId:@"3123"];
    
    UIButton* testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
    testBtn.backgroundColor = [UIColor greenColor];
    [testBtn setTitle:@"test action" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    
    UIButton* crazyBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 150, 50)];
    crazyBtn.backgroundColor = [UIColor greenColor];
    [crazyBtn setTitle:@"Crazy Token" forState:UIControlStateNormal];
//    [crazyBtn addTarget:self action:@selector(blanceOfCrazyToken) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:crazyBtn];
    
    UIButton* sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 150, 50)];
    sendBtn.backgroundColor = [UIColor greenColor];
    [sendBtn setTitle:@"Send Token" forState:UIControlStateNormal];
//    [sendBtn addTarget:self action:@selector(sendCrazyToken) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    UIButton* testBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 500, 150, 50)];
    testBtn1.backgroundColor = [UIColor greenColor];
    [testBtn1 setTitle:@"Cancel waiting" forState:UIControlStateNormal];
//    [testBtn1 addTarget:self action:@selector(clickCancelWaiting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn1];
    
}

-(void)testMethod{
    NSLog(@"click testMethod");
    
    [CrazyPlatform startSyncMethods:@"crazy_methods_type_to_import_wallet"];

//    [self createWallet];
//    [self approve];
//    [self getBoxInfo];
//    [self buyEgg];
//    [self openEgg];
//    [self openContract];
//    [self getInfo];
//    [self markCrayBuy];
//    [self tokenStake];
//    [self tokenStakeReward];
//    [self tokenWithdraw];
//    [self marketStartSell];
//    [self buyNft];
//    [self getSwapRate];
//    [self estimateGasSwap];
//    [self swapToken];
//    [self nftStaking];
//    [self nftStakingClaim];
//    [self signTest];
//    [self snakeIncubate];
//    [self snakeBattle];
}

@end
