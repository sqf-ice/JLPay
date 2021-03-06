//
//  CustPayViewController.m
//  JLPay
//
//  Created by jielian on 15/5/15.
//  Copyright (c) 2015年 ShenzhenJielian. All rights reserved.
//

#import "CustPayViewController.h"

#define ImageForBrand   @"logo"                                     // 商标图片
#define NameForBrand    @"捷联通"                                    // 商标名字



@interface CustPayViewController ()
@property (nonatomic, strong) UILabel           *acountOfMoney;             // 金额显示标签栏
@property (nonatomic)         double            money;                      // 金额
@property (nonatomic, strong) NSMutableArray    *moneyArray;                // 模拟金额栈：保存历史金额
@property (assign)            BOOL              dotFlag;                    // 小数点标记
@end

@implementation CustPayViewController
@synthesize acountOfMoney               = _acountOfMoney;
@synthesize money                       = _money;
@synthesize dotFlag                     = _dotFlag;
@synthesize moneyArray                  = _moneyArray;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _acountOfMoney                      = [[UILabel alloc] initWithFrame:CGRectZero];
    _money                              = 0.0;
    _dotFlag                            = NO;
    _moneyArray                         = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:0.0], nil];
    
   
    [self addSubViews];
}

/* 金额值的 setter 方法 */
- (void)setMoney:(double)money {
    if (_money != money) {
        _money                          = money;
        _acountOfMoney.text             = [NSString stringWithFormat:@"%.02lf", _money];
    }
}

/*************************************
 * 功  能 : CustPayViewController 的子控件加载;
 *          - 图标          UIImageView + UILabel
 *          - 金额显示框     UILabel
 *          - 数字按键组     UIButtons
 *          - 其他支付按钮   UIButtons
 *          - 刷卡按钮       UIButton
 * 参  数 : 无
 * 返  回 : 无
 *************************************/
- (void) addSubViews {
    CGFloat numFontSize                 = 30.0;
    CGFloat statusBarHeight             = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat visibleHeight               = self.view.bounds.size.height - self.tabBarController.tabBar.bounds.size.height - statusBarHeight;
    CGFloat  bornerWith                 = 1.0;

    
    // 图标          3/8/3.3
    CGFloat littleHeight                = visibleHeight * (3.0/8.0/3.3);
    CGFloat littleHeight_2              = littleHeight * 0.8;
    CGRect  frame                       = CGRectMake((self.view.bounds.size.width - littleHeight_2*3)/2,
                                         0 + statusBarHeight + (littleHeight - littleHeight_2)/2.0,
                                         littleHeight_2*3,
                                         littleHeight_2);
    UIImageView *imageView              = [[UIImageView alloc] initWithFrame:frame];
    imageView.image                     = [UIImage imageNamed:ImageForBrand];

    [self.view addSubview:imageView];
    
    
    // 金额显示框     1/8
    CGFloat bigHeight                   = visibleHeight * 1.0/8.0;
    frame.origin.x                      = 0 + bornerWith;
    frame.origin.y                      += littleHeight + bornerWith - (littleHeight - littleHeight_2)/2.0;
    frame.size.width                    = self.view.bounds.size.width - bornerWith*2;
    frame.size.height                   = bigHeight - bornerWith * 2;
    UIView  *moneyView                  = [[UIView alloc] initWithFrame:frame];
    moneyView.backgroundColor           = [UIColor colorWithWhite:0.7 alpha:0.5];
    [self.view addSubview:moneyView];
    
    // moneyLabel
    CGRect innerFrame                   = CGRectMake(0, 0, frame.size.width - 40, frame.size.height);
    self.acountOfMoney.frame            = innerFrame;
    self.acountOfMoney.text             = [NSString stringWithFormat:@"%.02lf", self.money];
    self.acountOfMoney.textAlignment    = NSTextAlignmentRight;
    self.acountOfMoney.font             = [UIFont boldSystemFontOfSize:37];
    [moneyView addSubview:self.acountOfMoney];
    
    // moneyImageView ...............
    CGRect moneySymbolFrame             = CGRectMake(innerFrame.origin.x + innerFrame.size.width + 5.0, frame.size.height/2.0, frame.size.height/4.0/4.0 * 3.0, frame.size.height/4.0);
    UILabel *moneySymbolLabel           = [[UILabel alloc] initWithFrame:moneySymbolFrame];
    moneySymbolLabel.text               = @"￥";
    moneySymbolLabel.font               = [UIFont systemFontOfSize:15];
    [moneyView addSubview:moneySymbolLabel];
    
    // 数字按键组     4/8
    NSArray * numbers                   = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@".",@"0",@"-",nil];
    frame.origin.y                      += bigHeight - bornerWith;
    frame.size.width                    = self.view.bounds.size.width/3.0;
    frame.size.height                   = bigHeight;
    NSInteger index                     = 0;
    for (int i = 0; i<4; i++) {
        frame.origin.x                  = 0.0;
        if (i == 3) {
            frame.origin.y              -= 0.6;
        }
        for (int j = 0; j<3; j++) {
            // frame 都已经准备好，可以直接装填数字按钮组了
            id button;
            /////////// testing...
            // “撤销”按钮
            if (i == 3 && j == 2) {
                button                                          = [[DeleteButton alloc] initWithFrame:frame];
                ((DeleteButton*)button).layer.borderWidth       = 0.3;
                ((DeleteButton*)button).layer.borderColor       = [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
//                [(DeleteButton*)button  setTitle:@"delete" forState:UIControlStateNormal];
                [(DeleteButton*)button  addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
                [(DeleteButton*)button  addTarget:self action:@selector(touchUpDelete:) forControlEvents:UIControlEventTouchUpInside];
                [(DeleteButton*)button  addTarget:self action:@selector(touchUpOut:) forControlEvents:UIControlEventTouchUpOutside];
                // 给撤销按钮添加一个长按事件:将金额清零,金额栈也清0
                UILongPressGestureRecognizer *longPress         = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressButtonOfDelete:)];
                longPress.minimumPressDuration                  = 0.8;
                [(DeleteButton*)button addGestureRecognizer:longPress];
                // addSubview
                [self.view addSubview:button];
            }
            // 数字按钮
            else {
                button                                          = [[UIButton alloc] initWithFrame:frame];
                [button setTitle:[numbers objectAtIndex:index] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                ((UIButton*)button).titleLabel.font             = [UIFont boldSystemFontOfSize:numFontSize];
                ((UIButton*)button).layer.borderWidth           = 0.3;
                ((UIButton*)button).layer.borderColor           = [UIColor colorWithWhite:0.8 alpha:0.5].CGColor;
                [(UIButton*)button  addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
                [(UIButton*)button  addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
                [(UIButton*)button  addTarget:self action:@selector(touchUpOut:) forControlEvents:UIControlEventTouchUpOutside];
                [self.view addSubview:button];
            }
            /////////////////////
            
            index++;
            frame.origin.x              += frame.size.width;
        }
        frame.origin.y                  += bigHeight;
    }
    
    // 支付宝按钮   3/8/3.3
    frame.origin.x                      = 0 + bornerWith;
    frame.origin.y                      += bornerWith;
    frame.size.width                    = self.view.bounds.size.width/2.0 - bornerWith*2;
    frame.size.height                   = littleHeight - bornerWith*2;
    OtherPayButton *alipayButton        = [[OtherPayButton alloc] initWithFrame:frame];
    // 添加 action ..........................
    [alipayButton addTarget:self action:@selector(touchUpSimple:) forControlEvents:UIControlEventTouchUpInside];
    [alipayButton addTarget:self action:@selector(touchDownSimple:) forControlEvents:UIControlEventTouchDown];
    [alipayButton addTarget:self action:@selector(touchOutSimple:) forControlEvents:UIControlEventTouchUpOutside];

    [alipayButton setImageViewWithName:@"zfb"];
    [alipayButton setLabelNameWithName:@"支付宝支付"];
    [self.view addSubview:alipayButton];
    
    // 微信按钮
    frame.origin.x                      += self.view.bounds.size.width/2.0;
    OtherPayButton *weChatButton        = [[OtherPayButton alloc] initWithFrame:frame];
    // 添加 action ..........................
    [weChatButton setImageViewWithName:@"wx"];
    [weChatButton setLabelNameWithName:@"微信支付"];
    [weChatButton addTarget:self action:@selector(touchUpSimple:) forControlEvents:UIControlEventTouchUpInside];
    [weChatButton addTarget:self action:@selector(touchDownSimple:) forControlEvents:UIControlEventTouchDown];
    [weChatButton addTarget:self action:@selector(touchOutSimple:) forControlEvents:UIControlEventTouchUpOutside];

    [self.view addSubview:weChatButton];
    
    // 刷卡按钮       3/8/3.3 * 1.3
    CGFloat newBornerWith               = 2.0;
    frame.origin.x                      = 0 + newBornerWith;
    frame.origin.y                      += frame.size.height + bornerWith + newBornerWith;
    frame.size.width                    = self.view.bounds.size.width - newBornerWith*2;
    frame.size.height                   = littleHeight * 1.3 - newBornerWith*2;
    UIButton *brushButton               = [[UIButton alloc] initWithFrame:frame];
    brushButton.layer.cornerRadius      = 8.0;
    brushButton.backgroundColor         = [UIColor redColor];
    [brushButton setTitle:@"开始刷卡" forState:UIControlStateNormal];
    [brushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    brushButton.titleLabel.font         = [UIFont boldSystemFontOfSize:32];
    // 添加 action ..........................
    [brushButton addTarget:self action:@selector(beginBrush:) forControlEvents:UIControlEventTouchDown];
    [brushButton addTarget:self action:@selector(toBrush:) forControlEvents:UIControlEventTouchUpInside];
    [brushButton addTarget:self action:@selector(outBrush:) forControlEvents:UIControlEventTouchUpOutside];

    [brushButton setSelected:YES];
    [self.view addSubview:brushButton];

    
}

/*************************************
 * 功  能 : 刷卡按钮的点击动画效果;
 * 参  数 :
 *          (id)sender                发起转场动作的按钮：放大、缩小
 * 返  回 : 无
 *************************************/
- (IBAction) toBrush:(UIButton*)sender {
    sender.transform = CGAffineTransformIdentity;
    self.money += 1;
}
- (IBAction) outBrush:(UIButton*)sender {
    sender.transform = CGAffineTransformIdentity;
}
- (IBAction) beginBrush:(UIButton*)sender {
    sender.transform = CGAffineTransformMakeScale(0.99, 0.99);
}

- (IBAction) touchDown:(UIButton*)sender {
    sender.transform = CGAffineTransformMakeScale(0.99, 0.99);
    sender.backgroundColor              = [UIColor colorWithWhite:0.7 alpha:0.5];
}
- (IBAction) touchUp:(UIButton*)sender {
    sender.transform = CGAffineTransformIdentity;
    sender.backgroundColor              = [UIColor clearColor];
    // 要计算属性值：金额：money
    [self caculateMoney:sender];
}
- (IBAction) touchUpDelete:(DeleteButton*)sender {
    sender.transform = CGAffineTransformIdentity;
    sender.backgroundColor              = [UIColor clearColor];
    // 要计算属性值：金额：money
    self.money                      = [self pullMoneyStack];
    // 撤销后要注意小数位标志更新
    if ( [self moneyHasDot:self.money] && (self.dotFlag == NO) ) {
        self.dotFlag                = YES;
    } else if ( ([self moneyHasDot:self.money] == NO) && (self.dotFlag == YES) ) {
        self.dotFlag                = NO;
    }
}


- (IBAction) touchUpOut:(UIButton*)sender {
    sender.transform = CGAffineTransformIdentity;
    sender.backgroundColor              = [UIColor clearColor];
}

- (IBAction) touchDownSimple:(UIButton*)sender {
    sender.transform                    = CGAffineTransformMakeScale(0.97, 0.97);
}
- (IBAction) touchUpSimple:(UIButton*)sender {
    sender.transform                    = CGAffineTransformIdentity;
}
- (IBAction) touchOutSimple:(UIButton*)sender {
    sender.transform                    = CGAffineTransformIdentity;
}


/*************************************
 * 功  能 : 将当前金额值推入金额栈;
 *************************************/
- (void) pushMoneyStack {
    NSInteger index                     = 0;
    if (self.moneyArray.count != 0){
        index                           = self.moneyArray.count -  1;
        NSNumber *numMoney = [self.moneyArray objectAtIndex:index];
        if (self.money != numMoney.doubleValue){
            [self.moneyArray addObject:[NSNumber numberWithDouble:self.money]];
        }
    }
    else {
        [self.moneyArray addObject:[NSNumber numberWithDouble:self.money]];
    }
}
/*************************************
 * 功  能 : 将金额栈的最上面的金额弹出;
 *************************************/
- (CGFloat) pullMoneyStack {
    double money = 0.0;
    NSInteger index                     = 0;
    if (self.moneyArray.count != 0)
        index                           = self.moneyArray.count -  1;
    else
        return money;
    
    NSNumber *numMoney = [self.moneyArray objectAtIndex:index];
    if (numMoney != nil) {
        money                           = numMoney.doubleValue;
        [self.moneyArray  removeObject:numMoney];
    }
    return  money;
}


/*************************************
 * 功  能 : 撤销按钮的长按事件;清除所有金额；
 * 参  数 :
 * 返  回 :
 *************************************/
- (IBAction)longPressButtonOfDelete:(UILongPressGestureRecognizer*)sender {
    self.money                          = 0.0;
    self.dotFlag                        = NO;
    [self.moneyArray removeAllObjects];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        sender.view.transform               = CGAffineTransformIdentity;
        sender.view.backgroundColor         = [UIColor clearColor];
    }

}

/*************************************
 * 功  能 : 判断金额是否带有小数点;
 * 参  数 :
 *          (CGFloat)money         指定金额
 * 返  回 : 
 *          BOOL
 *************************************/
- (BOOL) moneyHasDot: (CGFloat)money {
    BOOL flag                           = NO;
    
    if (   (NSInteger)(money * 100.0) % 10 != 0 ||
           (NSInteger)(money * 100.0) % 100 != 0
       ) {
        flag                            = YES;
    }
    
    return flag;
}


/*************************************
 * 功  能 : 将按钮的对应的数字或小数点计算到money属性中;
 * 参  数 :
 *          (UIButton*)sender         被点击的按钮
 * 返  回 : 无
 *************************************/
- (void) caculateMoney: (UIButton*)button {
    NSString *numberStr                 = button.titleLabel.text;
    double   temp                      = 0.0;
    
    // 计算当前按键值前要保存旧的金额值到栈里面: pushMoneyStack
    // 撤销按钮
    if ([numberStr isEqualToString:@"delete"]) {
//    if ([button.imageView.image]) {
        self.money                      = [self pullMoneyStack];
        // 撤销后要注意小数位标志更新
        if ( [self moneyHasDot:self.money] && (self.dotFlag == NO) ) {
            self.dotFlag                = YES;
        } else if ( ([self moneyHasDot:self.money] == NO) && (self.dotFlag == YES) ) {
            self.dotFlag                = NO;
        }
    }
    // 小数点按钮
    else if ([numberStr isEqualToString:@"."]) {
        [self pushMoneyStack];
        
        // 如果小数点标志不为yes，则置为yes
        if (!self.dotFlag)
            self.dotFlag                = YES;
    }
    // 纯数字按钮
    else if ( ([numberStr intValue] >= 0) && ([numberStr intValue] <= 9) ){
        [self pushMoneyStack];

        // 如果有小数位,判断是否到了最后一位
        if (self.dotFlag) {
            // 如果*100后除10还有余数说明到了第二位小数了
            if ( (NSInteger)(self.money * 100)%10 != 0  ) {
                // 当前的点击数不要添加了
                NSLog(@"小数位已满，不能再被添加了。。。。。。。。。\n。。。。。。。");
                NSLog(@"\n<<<<<<<<< money=[%lf], \n money*100 =[%d], \n money * 100.00/10 =[%d] >",
                      self.money,
                      (NSInteger)(self.money * 100.00),
                      (NSInteger)(self.money * 100.00)%10 );
                
            }
            // 只有一位小数
            else if ((NSInteger)(self.money * 100.00)%100 != 0) {
                temp                    = (double)[numberStr doubleValue]/100.0;
                NSLog(@"-==========-temp num [%lf], money [%lf]-===========-", temp, self.money);
                self.money              += temp;
                NSLog(@"-==========-temp num [%lf], money [%lf]-===========-", temp, self.money);

            }
            // 小数点还没位数,添加到第一位小数
            else {
                temp                    = (double)[numberStr doubleValue]/10.0;
                NSLog(@"--------temp num [%lf], money [%lf]--------", temp, self.money);
                self.money              += temp;
                NSLog(@"-==========-temp num [%lf], money [%lf]-===========-", temp, self.money);

            }
        }
        // 如果没有小数位,直接追加
        else {
            temp                        = self.money * 10.0;
            self.money                  = temp + [numberStr doubleValue];
        }
    }
}





#pragma mark - Navigation
/*************************************
 * 功  能 : 刷卡界面转场协议方法;
 * 参  数 :
 *          (UIStoryboardSegue *)segue  转场句柄
 *          (id)sender                  发起转场动作的控件
 * 返  回 :
 *          NSInteger                 section 的个数
 *************************************/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
