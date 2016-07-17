//
//  HighLevelViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/23.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "HighLevelViewController.h"
#import <objc/runtime.h>
#import "UserCopy.h"
#import "NewExecutorBlock.h"
#import "NSObject+RunAtDeallocBlock.h"

#pragma mark 0. 属性-> 是桥，右侧连着工程师要赋予的 定值，左侧连着该类的变量。参数-> 定值。在.m中，该值是由工程师给定的。属性常作为参数。
#pragma mark 1. 样式声明
@class UIView;

typedef NS_ENUM(NSInteger, CLSex) {
    CLSexMan,
    CLSexWoman
};

#pragma mark 2.分类和延展 ：延展（extension）本质是可添加：私有成员变量和方法
//@interface ViewController ()
//
//@end
// 分类：仅仅是某类方法（不是成员变量）的拓展或重写（不建议，会覆盖掉）。要想重写可以继承。 本质：功能化。
//@interface ViewController (categoryName)//分类名
//
//@end
////声明
//@interface ViewController : UIViewController
//
//@end
// 实现分类的方法
//@implementation ViewController (categoryName)//分类名
//
//
//@end
//实现某类的方法
//@implementation ViewController
//
//@end

#pragma mark 3.驼峰命名法 和 下划线命名法，2者不要混着用
//举例：kEnumMatchNum  _AGENAME

@interface HighLevelViewController ()
{
    NSSet *set;
}
@property (nonatomic, readwrite, assign) NSInteger age;
@property (nonatomic, readonly, assign) CGFloat height;
@property (nonatomic, readonly, assign) CLSex sex;
@property (nonatomic, copy) NSString *testName;
@property (nonatomic, assign) NSInteger speed;//速度
@property (nonatomic, weak) NSObject *object;


#pragma mark 4.内存管理属性 的错误操作
@property (nonatomic, copy) NSMutableArray *mutableArray;
- (void)logIn;
//- (void)doLogIn;//命名不规范 do
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name age:(CGFloat)age;
- (BOOL)openFile:(NSString *)fullPath withApplication:(NSString *)appName andDeactivate:(BOOL)flag;
//- (int)runModalForDirectory:(NSString *)path andFile:(NSString *)name andTypes:(NSArray *)fileTypes;//命名不规范 使用and/with连接参数

@end
#pragma mark 5.OC中尽量避免C的基本数据类型使用
//int -> NSInteger;
//unsigned -> NSUInteger;
//float -> CGFloat;
//动画时间 ->NSTimeInterval

#pragma mark 6.业务逻辑不写在M层
// 业务逻辑都不应当写在 Model 里：MVC 应在 C，MVVM 应在 VM。避免写在M中。
@implementation HighLevelViewController

#pragma mark 16.
//@synthesize height = _height;  //默认生成的变量
@synthesize height = _______height;
// @dynamic告诉编译器：属性的 setter 与 getter 方法由用户自己实现，不自动生成.实现动态绑定。
@dynamic age;
#pragma mark 7. 发送Message ：通用性方法和衍生方法
// designated 初始化方法：通用性方法
- (instancetype)initWithName:(NSString *)name age:(CGFloat)age {
    self = [super init];
    if (self) {
        //        self.name = name;
        //        self.age = age;
    }
    return self;
}

// secondary 初始化方法:常常调用 designated方法，衍生方法
- (instancetype)initWithName:(NSString *)name {
    
    self = [super init];
    if (self) {
        //    self.name = name;
        //        或
        //    常常调用 designated方法 [self initWithName:name age:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.age = 1;//@dynamic age后，不再自动生成setter 和getter 方法，所以运行会报错
    
    //  改错题： NSMutableArray *newArray = [[NSMutableArray alloc] initWithObjects:@"3",@"6",@"9", nil];
    //        self.mutableArray = newArray;// copy后已经为不可变数组，故不能作为可变数组来处理
    //        [self.mutableArray removeObjectAtIndex:1];
    //  改成： _mutableArray = newArray;
    //    [_mutableArray removeObjectAtIndex:1];
    
#pragma mark 8. copy 凡是copy产生的都是不可变的，mutableCopy产生的都是可变的。
    UserCopy *user1 = [[UserCopy alloc]initWithName:@"张嘎" age:15];
    UserCopy *user2 = [user1 copy];// copyWithZone方法中，我们得到了一个新的user1副本，拷贝了一份user1，不可变。
    //  UserCopy *user2 = user1;//user2也指向user1这块内存
#pragma mark 9. @property 的本质： = ivar +getter +setter ;
    //    OBJC_IVAR_$类名$属性名称 ：该属性的“偏移量” (offset)，这个偏移量是“硬编码” (hardcode)，表示该变量距离存放对象的内存区域的起始地址有多远。
    //    setter 与 getter 方法对应的实现函数
    //    ivar_list ：成员变量列表 -> _name
    //    method_list ：方法列表-> setter 与 getter 方法对应的实现函数->在偏移量的起始位置开始存和取值，期间设计类型强转。
    //    prop_list ：属性列表
    
#pragma mark 10.category 分类添加属性，需要操作runtime。
    //    category 使用 @property 也是只会生成 setter 和 getter 方法的声明,如果我们真的需要给 category 增加属性的实现,需要借助于运行时的两个函数
    //    objc_setAssociatedObject(<#id object#>, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
    //    objc_getAssociatedObject(<#id object#>, <#const void *key#>)
    
#pragma mark 11. assign和weak 变量的自动置nil的runtime底层实现？
    self.object = [[NSObject alloc] init]; //模拟object 的weak 方法
    //   assign：基本数据类型，简单的赋值，weak：对象类型，非拥有关系，内存释放时，指针自动置为nil。
    //     runtime 对注册的类布局，对类中的weak对象新建一个hash 表，weak 指向的对象内存地址作为 key，通过key找到该weak的内存对象，该内存dealloc 后，就会把该地址置为nil。 调用：objc_storeWeak(&a, a)函数 objc_storeWeak(&user1, user1);
#pragma mark 12. NSObject对象的 runtime的 dealloc实现
    
    NSObject *foo = [[NSObject alloc] init];
    [foo qsy_runAtDealloc:^{
        NSLog(@"我就测试释放不说话foo");
    }];
    
#pragma mark 13.kvo 实现原理？
    // 观察者。间接。观察某个对象的属性变化。
    //    如下代码：某self 拥有属性 @property (nonatomic, strong) NSDate *now;
    //    [self addObserver:self forKeyPath:@"now" options:NSKeyValueObservingOptionNew context:nil];
    //    NSLog(@"1");
    
    //    [self willChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
    //    NSLog(@"2");
    //    [self didChangeValueForKey:@"now"]; // “手动触发self.now的KVO”，必写。
    //    NSLog(@"4");
    //    - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //        NSLog(@"3");
    //    }
    //    执行时：按照 1234 执行
    
#pragma mark 14. 改错题： @property (copy) NSMutableArray *array;
    //    1.默认是原子性的，性能差。
    //    2.copy内存管理关键字，结果是：复制了一个新的不可变数组。这样按照可变数组执行操作时会出现崩溃
    
#pragma mark 15. setter方法内部，一般不做if判断
    // 逻辑判断才用if
    //    - (void)setSpeed:(NSInteger )speed {
    //        if (_speed < 0) {
    //            _speed = 0;
    //        }
    //
    //        if (_speed>300) {
    //            _speed = 300;
    //        }
    //        _speed = speed;
    //    }
    
#pragma mark 16. 非集合对象的 和 集合类对象的copy、mutableCopy
    //    非集合对象和集合对象：唯有不可变的copy才是 浅拷贝；其他都是深拷贝。copy的都是不可变，mutableCopy都是可变的
    //    集合对象 ：单层深拷贝，array 集合内部的元素仍然是指针拷贝
    
#pragma mark 17 objc中向一个对象发送消息[obj foo]和objc_msgSend()函数之间有什么关系？
    //  等同的关系 。
    //  clang作用： Objective-C的源码改写成C++语言 。[objc foo]; 动态转为-> objc_msgSend()，objc_msgSend()的动作执行： 首先在 该Class 中的缓存查找 IMP （没缓存则初始化缓存），如果没找到，则向父类的 Class 查找。如果一直查找到根类仍旧没有实现，则用_objc_msgForward函数指针代替 IMP 。最后，执行这个 IMP 。
    // 原理： objc是动态语言，每个方法在运行时会被动态转为消息发送，即：objc_msgSend(receiver, selector)。
    
#pragma mark 18 什么时候会报unrecognized selector的异常？
    //   方法执行的4个runtime 顺序：
    //  0.objc在向一个对象发送消息时，runtime库会根据对象的isa指针找到该对象实际所属的类，然后在该类中的方法列表以及其父类方法列表中寻找方法运行
    //  1. 0未遂，Method resolution。 objc运行时会调用+resolveInstanceMethod:或者 +resolveClassMethod: 若
    //  2.Fast forwarding : -forwardingTargetForSelector:把这个消息转发给其他对象的机会。
    //  3.Normal forwarding: -methodSignatureForSelector:消息获得函数的参数和返回值类型。如果-methodSignatureForSelector:返回nil，Runtime则会发出-doesNotRecognizeSelector:消息，程序这时也就挂掉 unrecognized selector的异常;    如果返回了一个函数签名，Runtime就会创建一个NSInvocation对象并发送-forwardInvocation:消息给目标对象。
    
#pragma mark 19 一个objc对象如何进行内存布局？（考虑有父类的情况）
    //    每一个对象内部都有一个isa指针: 该指针指向他的类对象. 类对象的元类 存放着本对象的对象方法列表，成员变量列表和属性列表,方便找到该对象上的方法和属性。一层一层的父类往上找，一直到NSObject对象，isa指针指向自身。
#pragma mark 20  super 本质是一个编译器标示符，和 self 是指向的同一个消息接受者
    //   objc_msgSend(receiver, selector)。无论self、super 的receiver都是本类；
    //  两个的不同点在于：super 会告诉编译器，调用 class 这个方法时，要去父类的方法，而不是本类里的;self 是先从本类找，再去父类中找。
    
#pragma mark 21. runtime如何通过selector找到对应的IMP地址？（分别考虑类方法和实例方法）
    //    每个对象都有isa指针，指向元类，该类中存放着该对象的所有的方法列表，属性列表和变量列表。selector本质：方法名。通过该方法名找到对应的对象的方法名。
#pragma mark 22. 我们的程序中有许多个ViewController，我想在对项目改动最小的情况下，在当每个Controller执行完ViewDidLoad以后就在控制台把自己的名字打印出来，方便我去做调试或者了解项目结构？
    //    参见第203到221
    
#pragma mark 22. 使用runtime Associate方法关联的对象，需要在主对象dealloc的时候释放么？
    static char overViewKey;
    NSArray *array = [[NSArray alloc] initWithObjects:@"one",@"two",@"three", nil];
    NSString *str = [[NSString alloc] initWithFormat:@"%@",@"four"];
    objc_setAssociatedObject(array, &overViewKey, str, OBJC_ASSOCIATION_RETAIN);
    //    当array 被释放时str才会被释放掉。
#pragma mark 23. 对象的内存销毁执行顺序表
    //    [objc release];
    //    [objc dealloc];
    //    [NSObject dealloc];
    //    object_dispose():解除associate关联，解除__weak 引用，调用free()
    
#pragma mark 24.   objc中的类方法和实例方法有什么本质区别：
    //    类方法只能由类对象来调用，实例方法必须由实例对象来调用； 类方法中的self 是类对象，实例方法中的self 是实例对象；
#pragma mark 25._objc_msgForward函数是做什么的，直接调用它将会发生什么？
//    本质是:IMP类型。 用作消息转发：当一个消息被调用但该消息没被IMP时,会代替IMP指针来实现方法。
//    直接调用_objc_msgForward，将跳过查找 IMP 的过程，直接触发“消息转发”.说白了，就是 告诉编译器这个对象里找不到这个方法的实现
#pragma mark 26. 能否向编译后得到的类中增加实例变量？能否向运行时创建的类中添加实例变量？为什么？
//  编译后  objc_iva_list 和 instance_size已经确定
//  运行时 class_addIvar() 可执行。
    
#pragma mark 27. runloop和线程有什么关系,runloop 的mode作用？
//    runloop 运行循环：交互时wake，无交互时rest；
//    每个线程都有对应的runloop对象，子线程的runloop默认是不工作的；
//   在main()函数 中 main thread 的runloop默认是启动；其他线程来说，runloop对象是没有启动的，若需要更多的线程交互则可以手动配置和启动。
//   NSRunLoop *currentRun =  [NSRunLoop currentRunLoop];
    
    //   mode：运行循环runloop中的不同模式下优先级状态
//    NSDefaultRunLoopMode（kCFRunLoopDefaultMode）：默认，空闲状态
//    UITrackingRunLoopMode：ScrollView滑动时
//    UIInitializationRunLoopMode：启动时
//    NSRunLoopCommonModes（kCFRunLoopCommonModes）
    NSTimer *timer1 = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(woqu) userInfo:nil repeats:YES];//默认添加到NSDefaultRunLoopMode：主runloop的mode
//    iOS公开提供2种： NSDefaultRunLoopMode 和 NSRunLoopCommonModes。 runloop只能运行在一种mode中，若切换mode ，当前的runloop需要停止，启动新mode的runloop。ScrollView滚动过程种从默认的NSDefaultRunLoopMode，因为在NSDefaultRunLoopMode下会影响滚动效果，故需要切换到UITrackingRunLoopMode。上述timer会被添加到NSDefaultRunLoopMode的main thread 的主runloop中，但scrollview滚动会切换到UITrackingRunLoopMode的主循环的状态，会造成NSDefaultRunLoopMode下的timer停止。
//    解决办法
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:2.0f target:self selector:@selector(woqu) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
#pragma mark 28. 猜想runloop内部是如何实现的?
//    function loop() {
//        initialize();
//        do {
//            var message = get_next_message();
//            process_message(message);
//        }while (message = !quit ) {
//            
//        }
//    }
#pragma mark 29. 不手动指定autoreleasepool的前提下，一个autorealese对象在什么时刻释放？（比如在一个vc的viewDidLoad中创建）
//    1. 手动释放：手动创建的autoreleasepool，当前作用域autoreleasepool大括号结束时释放
//    2.系统自动释放：autorelease对象出了作用域之后，会被添加到最近一次创建的autoreleasepool中，并会在当前的 runloop 迭代结束时释放。 运行循环结束时，倾倒autoreleasepool 中所有的对象发送release，autoreleasepool 再被销毁。
//    3.什么时间会创建自动释放池？runloop 检测到事件并启动后，就会创建自动释放池。
#pragma mark 30. 苹果是如何实现autoreleasepool的？
//    队列数组以栈的形式。实现3个方法：
//    objc_autoreleasepoolPush;
//    objc_autoreleasepoolPop;
//    objc_autorelease;
#pragma mark 31. 使用block时什么情况会发生引用循环，如何解决？
//    某对象强引用了block，block 强引用了某对象，造成循环引用。
//    解决： 某对象进行__block 或者__weak 修饰  ； 将该对象或者block = nil；
#pragma mark 32. 在block内如何修改block外部变量？
//    block不允许修改外部变量的值,在block中访问的外部变量是copy过去到堆区的.
//    外部变量的值指得是 栈  中指针的内存地址。
//    __block  关键字修饰作用： 对象由栈区指针的内存地址变成堆区指针的内存地址。看下面的例子：
//   一句话： 栈区是红灯区，堆区才是绿灯区。

    [self testInt];
    [self testStr];
    
#pragma mark 33. 如何用GCD同步若干个异步调用？
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group, queue, ^{
        //任务1
    });
    dispatch_group_async(group, queue, ^{
        //任务2
    });
    dispatch_group_async(group, queue, ^{
        //任务3
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        上述任务都执行完后，主线程执行同步执行
    });
    
    
#pragma mark 34. dispatch_barrier_async的作用是什么？
//    dispatch_barrier_async 函数会等待追加到Concurrent Dispatch Queue并行队列中的操作全部执行完,再执行 dispatch_barrier_async内部中的追加的block处理
    dispatch_queue_t conQueue = dispatch_queue_create("testBarrier", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(conQueue, ^{
        NSLog(@"111我要运行dispatch_barrier_async了");
    });
    dispatch_barrier_async(conQueue, ^{
         NSLog(@"222我要运行dispatch_barrier_async了");
    });
    dispatch_barrier_async(conQueue, ^{
        NSLog(@"333我要运行dispatch_barrier_async了");
    });
    
#pragma mark 35. 如何手动触发一个value的KVO或者KVO的底层实现 ？和KVC的区别
//    self 观察 self的属性 或者 实例变量；KVC通过key间接访问属性
    [self addObserver:self forKeyPath:@"set" options:NSKeyValueObservingOptionNew context:nil];
     NSLog(@"1");
    [self willChangeValueForKey:@"set"];
    NSLog(@"2");
    [self didChangeValueForKey:@"set"];
    NSLog(@"4");
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    NSLog(@"3");
}
- (void)testInt {
        __block int a = 2;
        NSLog(@"定义前：%p", &a);         //栈区 0xbff2aef8
        void (^foo)(void)= ^(){
            a = 3;
         NSLog(@"block内部：%p", &a);    //堆区 0x796aacd0
        };
        NSLog(@"定义后：%p", &a);         //堆区 0x796aacd0
        foo();
    
}

- (void)testStr {
    NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
    NSLog(@"定义前 ：%p",&a); // 栈区 0xbff2aef4
    void (^guess)(void) = ^(){
        a.string = @"modify";
        NSLog(@"block内部：%p",&a);  // 仍然在栈区，copy 新的地址发生变化 0x7b940ad2
//     a = [NSMutableString stringWithString:@"seeIsModify"];
//     未经过__block,修改的就不是堆中的内容，而是栈中的内容a,故会报错。
    };
    guess();
    NSLog(@"定义后：%p",&a); // 栈区 0xbff2aef4
}

- (void)woqu {
    
}

+ (void)load {
    //  保证交换方法执行一次: 优先级最高，高于普通的执行，在window加载就加载成了。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //       获取该类的viewDidload方法，该类型是个objc_method结构体。
        Method viewDidLoad = class_getInstanceMethod(self, @selector(viewDidLoad));
       //       获取刚创建的viewDidLoaded
        Method hhh = class_getInstanceMethod(self, @selector(tianxiawo));
        //        互换2个方法的实现
        method_exchangeImplementations(viewDidLoad, hhh);
        NSLog(@"我测测什么时候发生交换 %s(第%d行数)，类名描述：%@",__PRETTY_FUNCTION__,__LINE__,NSStringFromClass([self class]));
    });
}

- (void)tianxiawo {
    //    调用自身原有的方法
    [self tianxiawo];
    NSLog(@"%@",self);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@",self);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSLog(@"类名和方法名：%s(在第%d行),类名的描述:%@",__PRETTY_FUNCTION__,__LINE__, NSStringFromClass([self class]));
    }
    return self;
}

- (void)setObject:(NSObject *)object {
    //    将self和object关联：策略是赋值ASSIGN，保留强引用RETAIN，或复制COPY。
    //    仅仅object release 后，RETAIN 和copy策略下都不会释放该内存；ASSIGN会
    objc_setAssociatedObject(self, @"objcet", object, OBJC_ASSOCIATION_ASSIGN);
    __block __typeof(object)weakObject = object;
    [object qsy_runAtDealloc:^{
        weakObject = nil;
    }];
}

- (NSObject *)object {
    return objc_getAssociatedObject(self, @"objcet");
}

@end
