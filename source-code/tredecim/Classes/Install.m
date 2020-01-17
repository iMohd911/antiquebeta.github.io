#import "Install.h"

@implementation Install
@synthesize iconImageView;
@synthesize textLabel, progressView;
-(id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        iconImageView = [[NSClassFromString(@"SBIconImageView") alloc] init];
        [iconImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:iconImageView];

        [self addConstraintToItem:self attribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeTop multiplier:1 constant:-12];
        [self addConstraintToItem:self attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeLeading multiplier:1 constant:-16];
        [self addConstraintToItem:self attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:12];
        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual toItem:iconImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];


        textLabel = [[UILabel alloc] init];
        [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [textLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium]];
        [self addSubview:textLabel];

        [self addConstraintToItem:self attribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraintToItem:iconImageView attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:textLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-12];


        progressView = [[NSClassFromString(@"MPDownloadProgressView") alloc] init];
        [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:progressView];

        [self addConstraintToItem:self attribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual toItem:progressView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        [self addConstraintToItem:self attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:progressView attribute:NSLayoutAttributeTrailing multiplier:1 constant:16];
        [self addConstraintToItem:progressView attribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:29];
        [self addConstraintToItem:progressView attribute:NSLayoutAttributeHeight relation:NSLayoutRelationEqual toItem:progressView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    } return self;
}


-(void) installApplicationWithProgress:(double)progress {
    [progressView setDownloadProgress:progress];
}


-(void) layoutSubviews {
    [super layoutSubviews];

    [textLabel setTextColor:[UIColor whiteColor]];
    [progressView setOuterRingColor:[UIColor __halfTransparentWhiteColor]];
    [self createMaskForView:self cornerRadius:18];
    [self createMaskForView:iconImageView cornerRadius:10.0];

    if(![blurView isDescendantOfView:self]) {
        [self createBlurView];
    }
}


-(void) createMaskForView:(UIView *)view cornerRadius:(CGFloat)radius {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    [mask setPath:[path CGPath]];
    [view.layer setMask:mask];
}


-(void) createBlurView {
    blurView = [NSClassFromString(@"MTMaterialView") materialViewWithRecipe:2 configuration:1];
    [blurView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:blurView];
    [self sendSubviewToBack:blurView];

    [self addConstraintToItem:self attribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeLeading relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self addConstraintToItem:self attribute:NSLayoutAttributeTrailing relation:NSLayoutRelationEqual toItem:blurView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
}



-(void) addConstraintToItem:(UIView *)firstItem attribute:(NSLayoutAttribute)firstAttribute relation:(NSLayoutRelation)relation toItem:(UIView *)secondItem attribute:(NSLayoutAttribute)secondAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstItem attribute:firstAttribute relatedBy:relation toItem:secondItem attribute:secondAttribute multiplier:multiplier constant:constant]];
}
@end