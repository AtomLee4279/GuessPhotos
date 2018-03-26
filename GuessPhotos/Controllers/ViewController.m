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
//1.设置界面上部分图片信息
        self.index++;
        AppModel* appModel = self.questions[_index];
        [self.btnPhoto setImage:[UIImage imageNamed:appModel.icon] forState:(UIControlStateNormal)];
        self.page.text = [NSString stringWithFormat:@"%d/%ld",self.index+1,self.questions.count];
        self.answer.text = appModel.answer;
    btn.enabled = (self.index!=self.questions.count-1);

//2.设置界面下部分答案等信息
    NSUInteger answerLenth = appModel.answer.length;
    UIView* answerView = [self.view viewWithTag:1001];//此处尚不理解为何：原本将tag值设为1，结果得不到想要的子view。将tag设为1001后可以拿到
    for(UIButton* btn in answerView.subviews)
    {
        [btn removeFromSuperview];
    }
    CGFloat answerW = answerView.frame.size.height;
    CGFloat answerH = answerW;
    CGFloat answerY = 0;
    CGFloat answerSpacemargin = 10;
    CGFloat answerLeftMargin = (answerView.frame.size.width - answerW*answerLenth-answerSpacemargin*(answerLenth-1))*0.5;
    for (int i=0; i<answerLenth; i++) {
        //创建按钮
        UIButton *answerBtn = [[UIButton alloc] init];
        //设置frame
        answerBtn.frame = CGRectMake(answerLeftMargin+(answerSpacemargin+answerW)*i, answerY, answerW, answerH);
        [answerBtn setBackgroundColor:[UIColor redColor]];
        [answerView addSubview:answerBtn];
        
    }
    
    //3.设置待选项按钮
    NSUInteger optionsCount = appModel.options.count;//总的option个数
    CGFloat optionW = 40;
    CGFloat optionH = optionW;
    CGFloat optionSpaceMargin = 10;
    NSUInteger row = 3;//列数
    NSUInteger col = optionsCount/row;//行数
    UIView* optionsView = [self.view viewWithTag:1002];
    CGFloat optionsLeftMargin = (optionsView.frame.size.width -row*optionW-optionSpaceMargin*(row-1))*0.5;
    for(UIButton* btn in optionsView.subviews)
    {
        [btn removeFromSuperview];
    }
    for (int i=0; i<optionsCount; i++) {
        for (int j =0; j<row; j++) {
            //创建按钮
            UIButton *answerBtn = [[UIButton alloc] init];
            //设置frame
            CGFloat optionX = optionsLeftMargin+(optionSpaceMargin+optionW)*(j);
            CGFloat optionY = (optionSpaceMargin+optionH)*i;
            answerBtn.frame = CGRectMake(optionX,optionY,optionW, optionH);
            [answerBtn setBackgroundColor:[UIColor redColor]];
            [optionsView addSubview:answerBtn];
        }
        
        
        
        
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
    _cover.alpha = 0.0;
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
    //
    CGFloat headViewW = self.view.frame.size.width;
    CGFloat headViewH = headViewW;
    CGFloat headViewX = 0;
    CGFloat headViewY = (self.view.frame.size.height - headViewH)*0.5;
    //使用头尾式动画改变图片位置尺寸，和阴影的颜色深浅
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    //阴影逐渐加深
    _cover.alpha = 0.5;
    [self.btnPhoto setFrame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
    [UIView commitAnimations];
}
//点击阴影部分，阴影消失，视图恢复原状
-(void)clickShadow
{
    //图片尺寸位置恢复到原来
    CGFloat headViewW = 180;
    CGFloat headViewH = 180;
    CGFloat headViewX = 97;
    CGFloat headViewY = 160;
    /*采用头尾式动画实现阴影渐变浅直至消失
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 1.0];
    _cover.alpha = 0.0;//阴影颜色逐渐变浅 
    [self.btnPhoto setFrame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
    [UIView commitAnimations];
     //    把阴影从父视图中去除
     //    [self.cover removeFromSuperview];
     */
    //采用block动画实现阴影渐变浅直至消失
    [UIView animateWithDuration:1.0 animations:^{
        [self.btnPhoto setFrame:CGRectMake(headViewX, headViewY, headViewW, headViewH)];
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished)
        [self.cover removeFromSuperview];
    }];
    //恢复其余按钮的可交互状态
    for (UIButton *btn in self.view.subviews) {
        if (btn.tag == 1)
        {
            btn.userInteractionEnabled = YES;
        }
        
    }
}

//点击图片控制本身的放大缩小（包含阴影的逐渐显现和消失）
-(IBAction)PhotoClick
{
    //如果当前阴影不存在，说明点击之后是要做放大图片操作
    if(self.cover==nil)
    {
        [self bigPhoto:nil];//直接调用点击放大图片的方法
    }
    else//否则就是缩小图片操作
    {
        [self clickShadow];
    }
}
@end
