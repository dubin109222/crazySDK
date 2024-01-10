//
//  OCTestViewController.m
//  CSSDKOCDemo
//
//  Created by Lee on 23/02/2023.
//

#import "OCTestViewController.h"
#import <CrazySnake/CrazySnake.h>

@interface OCTestViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OCTestViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [CrazyPlatform initSDKWithGameId:1 environment:0 language:10 deviceId:@"123"];
    //    [CrazyPlatform initSDKWithType:2 language:2];
    [CrazyPlatform adjustTrackCommonEvent:@"myctzo" ];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [CrazyPlatform toHomeController];
}

-(void)testMethod{
    NSLog(@"click testMethod");
//        CS_WalletController* vc = [[CS_WalletController alloc] init];
////    UIViewController* vc1 = [[UIViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [CrazyPlatform toCS_WalletController];
}

-(void)blanceOfCrazyToken{
    [CrazyPlatform toImportWalletController];
}

-(void)sendCrazyToken{
    [CrazyPlatform toCreateWalletController];
}

-(void)clickCancelWaiting{
    [CrazyPlatform toNFTLabController];
}

#pragma mark -tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"我的钱包-V%@",[CrazyPlatform getSDKVersion]];
            break;
            
        case 1:
            cell.textLabel.text = @"NFT Lab";
            break;
            
        case 2:
            cell.textLabel.text = @"My NFT";
            break;
            
        case 3:
            cell.textLabel.text = @"NFT质押";
            break;
            
        case 4:
            cell.textLabel.text = @"兑换";
            break;
        case 5:
            cell.textLabel.text = @"单币质押";
            break;
        case 6:
            cell.textLabel.text = @"首页";
            break;
        case 7:
            cell.textLabel.text = @"客服";
            break;
        case 8:
            cell.textLabel.text = @"转账列表";
            break;
        case 9:
            cell.textLabel.text = @"创建账号";
            break;
        case 10:
            cell.textLabel.text = @"登陆";
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            
            [CrazyPlatform startSyncMethods:@"crazy_methods_type_to_import_wallet"];
            break;
        case 1:
            [CrazyPlatform toNFTLabController];
            break;
        case 2:
            [CrazyPlatform toMineNFTController];
            break;
        case 3:
            [CrazyPlatform toNFTStakeController];
            break;
        case 4:
            [CrazyPlatform toSwapController];
            break;
        case 5:
            [CrazyPlatform toStakeController];
            break;
        case 7:
            [CrazyPlatform toFeedbackController];
        case 9:
            
            [CrazyPlatform startAsyncMethods:@"crazy_methods_type_direct_create_wallet" para:nil response:^(CrazyBaseResponse * _Nonnull response) {
                
            }];
            
            break;
        case 10:
            [CrazyPlatform toLoginController];
            break;
        default:
            [CrazyPlatform toHomeController];
//            [SnakeWallet signWithPrivateKey:@"3bdc561a28c1d6d5bfe84b3538d6b15b1e9bcdd7ab7b79d6b7891da4c236dbe2" content:@"hUVMpJ6tf5NjEGC7R8TkuZAx2HmQWcS1" response:^(CSResultRespon * _Nonnull resp) {
//                    NSLog(@"message: %@",resp.message);
//                    NSLog(@"result: %@",resp.data);
//            }];
            break;
    }
}
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
