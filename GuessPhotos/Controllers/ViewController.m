//
//  ViewController.m
//  GuessPhotos
//
//  Created by 李一贤 on 2018/3/21.
//  Copyright © 2018年 李一贤. All rights reserved.
//

#import "ViewController.h"
#import "AppModel.h"
@interface ViewController ()
- (IBAction)nextQuestion:(UIButton*)btn;
- (IBAction)bigPhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnTips;
@property (weak, nonatomic) IBOutlet UIButton *btnHelp;
@property (weak, nonatomic) IBOutlet UIButton *btnCount;
@property(assign,nonatomic)int index;
@property(nonatomic,strong)NSArray* questions;
@property (weak, nonatomic) IBOutlet UILabel *page;
@property (weak, nonatomic) IBOutlet UILabel *answer;
@property(weak,nonatomic)UIButton* cover;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = -1;
    [self nextQuestion:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

//懒加载
-(NSArray*)questions

{
    if(_questions ==nil)
    {
        NSString* path = [[NSBundle mainBundle]pathForResource:@"questions.plist" ofType:nil];
        NSArray* dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray* tmpArray = [NSMutableArray array];
        for(NSDictionary*dict in dictArray)
        {
            AppModel* appmodel = [AppModel appModelWithDict:dict];
            [tmpArray addObject:appmodel];
        }
        _questions = tmpArray;
    }
    return _questions;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextQuestion:(UIButton*)btn {
    if(_index!=2)
    {
        self.index++;
//        NSString* index = [NSString stringWithFormat:@"%d",self.index];
        AppModel* appModel = self.questions[_index];
        [self.btnPhoto setImage:[UIImage imageNamed:appModel.icon] forState:(UIControlStateNormal)];
        self.page.text = [NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count];
        self.answer.text = appModel.answer;
    }
    else
    {
        btn.enabled = NO;
    }
    
    
}
//点击按钮，放大图片
- (IBAction)bigPhoto:(id)sender
{
    //1.添加阴影(用于盖住图片)
    UIButton* btn = [[UIButton alloc]initWithFrame:self.view.bounds];
    self.cover = btn;
    [_cover setBackgroundColor:[UIColor blackColor]];
    [_cover addTarget:self action:@selector(clickShadow) forControlEvents:(UIControlEventTouchUpInside)];
    //设置背景色透明度使之呈现阴影效果
    _cover.alpha = 0.5;
    //2.添加进父视图，并调整层级位置
    [self.view addSubview:_cover];
//    [self.view sendSubviewToBack:cover];//此方法会把view层级一直往父层级放，直到UIView层。所以在这里不适用种这方法
//    [self.view bringSubviewToFront:self.btnPhoto];//下面可二选一方法
    [self.view insertSubview:_cover belowSubview:self.btnPhoto];
    //获取特定tag值的控件，设置其不可交互
    for (UIButton *btn in self.view.subviews) {
        
        if (btn.tag == 1)
            
        {
            btn.userInteractionEnabled = NO;
        }
        
    }
    CGFloat headViewW = (self.view.frame.size.width)*0.6;
    CGFloat headViewH = (self.view.frame.size.height)*0.5;
    CGFloat headViewX = (self.view.frame.size.width - headViewW)*0.5;
    CGFloat headViewY = (self.view.frame.size.height - headViewH)*0.5;
    [self.btnPhoto setFrame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];

}

-(void)clickShadow
{
    //把阴影从父视图中去除
    [self.cover removeFromSuperview];
    //恢复其余按钮的可交互状态
    for (UIButton *btn in self.view.subviews) {
        
        if (btn.tag == 1)
            
        {
            btn.userInteractionEnabled = YES;
        }
        
    }
    //图片尺寸位置恢复到原来
    CGFloat headViewW = 180;
    CGFloat headViewH = 180;
    CGFloat headViewX = 97;
    CGFloat headViewY = 160;
    [self.btnPhoto setFrame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
}
@end
