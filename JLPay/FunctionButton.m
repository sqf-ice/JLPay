//
//  FunctionButton.m
//  JLPay
//
//  Created by jielian on 15/5/18.
//  Copyright (c) 2015年 ShenzhenJielian. All rights reserved.
//

#import "FunctionButton.h"

@interface FunctionButton()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end


@implementation FunctionButton
@synthesize nameLabel = _nameLabel;
@synthesize imageView = _imageView;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // imageView 在上
        self.imageView              = [[UIImageView alloc] initWithFrame:CGRectZero];
        // label 在下
        self.nameLabel              = [[UILabel alloc] initWithFrame:CGRectZero];
        // 边界线
        self.layer.borderColor      = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        self.layer.borderWidth      = 0.3;
    }
    return self;
}

- (void) setImageViewWith: (NSString*)imageName {
    self.imageView.image            = [UIImage imageNamed:imageName];
}
- (void) setLabelNameWith: (NSString*)labelName {
    self.nameLabel.text             = labelName;
}


/*************************************
 * 功  能 : 重载 layoutSubviews: 重新组织 subViews 的 frame;
 * 参  数 : 无
 * 返  回 : 无
 *************************************/
- (void)layoutSubviews {
    CGFloat  imageViewWidth         = self.bounds.size.width / 3.0;
    CGFloat  imageViewHeight        = self.bounds.size.height / 2.0 / 6.0 * 5.0;
    CGFloat  labelWidth             = self.bounds.size.width;
    CGFloat  labelHeight            = self.bounds.size.height / 12.0;
    
    CGFloat  x_imageView            = (self.bounds.size.width - imageViewWidth)/2.0;
    CGFloat  y_imageView            = (self.bounds.size.height - imageViewHeight - labelHeight) / 5.0 * 3.0;
    
    CGFloat  x_label                = 0;
    CGFloat  y_label                = y_imageView + imageViewHeight;
    
    
    
    self.imageView.frame            = CGRectMake(x_imageView, y_imageView, imageViewWidth, imageViewWidth);
    [self addSubview:self.imageView];
    
    self.nameLabel.frame            = CGRectMake(x_label, y_label, labelWidth, labelHeight);
    self.nameLabel.font             = [UIFont systemFontOfSize:12];
    self.nameLabel.textAlignment    = NSTextAlignmentCenter;
    [self addSubview:self.nameLabel];
}

@end
