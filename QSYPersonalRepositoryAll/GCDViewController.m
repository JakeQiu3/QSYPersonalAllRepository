//
//  GCDViewController.m
//  QSYPersonalRepositoryAll
//
//  Created by 邱少依 on 16/5/11.
//  Copyright © 2016年 QSY. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 3种多线程方式：NSThread GCD NSOperation & NSOperationQueue
    //    [self testThread];
    //    [self testOperation];
    [self testGCD];
#warning 少 线程同步就是为了防止多个线程抢夺同一份代码造成的数据安全问题。
    //    [self lockThread];//同步加锁
    // Do any additional setup after loading the view.
}

- (void)lockThread {
    //    方法1
    @synchronized (self) {
        //防止被抢夺的代码块
    }
    //    方法2
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //防止被抢夺的代码块
    });
    //GCD：多个线程都要执行某段代码添加到同一个串行队列
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(globalQueue, ^{
        NSInteger ticket = 20.f;
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"%ld - %@",(long)ticket, [NSThread currentThread]);
        --ticket;
        NSLog(@"打印下票数GCD ：%ld",(long)ticket);
    });
    
    //NSOperation & Queue： 新的并行队列，在新的线程中执行block
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        NSInteger ticket = 30.f;
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"%ld - %@",(long)ticket, [NSThread currentThread]);
        --ticket;
        NSLog(@"打印下票数Operation ：%ld",(long)ticket);
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;//设置最大并发数
    [queue addOperation:blockOperation];
    [blockOperation waitUntilFinished];
    
}

- (void)testThread {
    //    该常用消息
    [NSThread currentThread];
    [NSThread mainThread];
    [[NSThread currentThread] setName:@"当前线程的名字"];
    [NSThread sleepForTimeInterval:0.5];
    //   不常用:创建和启动
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:nil];
    [thread start];
    //或
    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:nil];
    //    //取消线程
    //    - (void)cancel;
    //
    //    //启动线程
    //    - (void)start;
    //
    //    //判断某个线程的状态的属性
    //    @property (readonly, getter=isExecuting) BOOL executing;
    //    @property (readonly, getter=isFinished) BOOL finished;
    //    @property (readonly, getter=isCancelled) BOOL cancelled;
    //
    //    //设置和获取线程名字
    //    -(void)setName:(NSString *)n;
    //    -(NSString *)name;
    //
    //    //获取当前线程信息
    //    + (NSThread *)currentThread;
    //
    //    //获取主线程信息
    //    + (NSThread *)mainThread;
    //
    //    //使当前线程暂停一段时间，或者暂停到某个时刻
    //    + (void)sleepForTimeInterval:(NSTimeInterval)time;
    //    + (void)sleepUntilDate:(NSDate *)date;
}
- (void)run:(id)x {
    NSLog(@"我要跑了");
}

- (void)testOperation {
    //  NSOperation 和 NSOperationQueue 分别对应 GCD 的 任务 和 队列 .
    //    将要执行的任务封装到一个 NSOperation 对象中。
    //    将此任务添加到一个 NSOperationQueue 对象中。
    //    NSOperation 只是一个抽象类，所以不能封装任务,必须用它子类
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    // 不安全，已被swift遗弃： NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run:) object:nil];
    //     [invocationOperation start];
    //   当前主队列的 当前主线程中执行
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"当前blockOperation 1 的线程%@", [NSThread currentThread]);
    }];
    
    for (NSInteger i = 0; i<5; i++) {
        [blockOperation1 addExecutionBlock:^{
            NSLog(@"第%ld次：%@", (long)i, [NSThread currentThread]);
        }];
    }
    // 情况1：若直接    [blockOperation start];  ——>Operation 中的任务  并发执行，它会 在当前main线程和其它的多个线程执行
    [blockOperation1 start];
    
    // 结果：   当前blockOperation的线程<NSThread: 0x7a163f40>{number = 1, name = main}
    //    2016-06-14 11:15:01.113 QSYPersonalRepositoryAll[1806:418680] 第3次：<NSThread: 0x7a163f40>{number = 1, name = main}
    //    2016-06-14 11:15:01.113 QSYPersonalRepositoryAll[1806:418680] 第4次：<NSThread: 0x7a163f40>{number = 1, name = main}
    //    2016-06-14 11:15:01.113 QSYPersonalRepositoryAll[1806:419075] 第2次：<NSThread: 0x7a273160>{number = 4, name = (null)}
    //    2016-06-14 11:15:01.113 QSYPersonalRepositoryAll[1806:419082] 第0次：<NSThread: 0x7a2741e0>{number = 2, name = (null)}
    //    2016-06-14 11:15:01.113 QSYPersonalRepositoryAll[1806:419095] 第1次：<NSThread: 0x78e68be0>{number = 3, name = (null)}
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"当前blockOperation2  的线程%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:2.0];
        NSLog(@"当前blockOperation3  的线程%@", [NSThread currentThread]);
    }];
    NSBlockOperation *blockOperation4 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:3.0];
        NSLog(@"当前blockOperation4  的线程%@", [NSThread currentThread]);
    }];
    
    //  设置依赖
    
    [blockOperation3 addDependency:blockOperation2];//任务3依赖任务2
    [blockOperation4 addDependency:blockOperation3];//任务4依赖任务3
    
    // 情况2：若直接 添加到并行队列中，可以省去start方法；同时由于不在主队列中执行，不会占用main线程。
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperations:@[blockOperation2,blockOperation3,blockOperation4] waitUntilFinished:NO];
    //    或
    //    [operationQueue addOperation:blockOperation2];
    //    [operationQueue addOperation:blockOperation3];
    //    [operationQueue addOperation:blockOperation4];
    
    //   NSOperation 常用方法
    //    //    BOOL executing; //判断任务是否正在执行
    //
    //    BOOL finished; //判断任务是否完成
    //
    //    void (^completionBlock)(void); //用来设置完成后需要执行的操作
    //
    //    - (void)cancel; //取消任务
    //
    //    - (void)waitUntilFinished; //阻塞当前线程直到此任务执行完毕
    ////  NSOperationQueue 常用方法
    //    NSUInteger operationCount; //获取队列的任务数
    //
    //    - (void)cancelAllOperations; //取消队列中所有的任务
    //
    //    - (void)waitUntilAllOperationsAreFinished; //阻塞当前线程直到此队列中的所有任务执行完毕
    //
    //    [queue setSuspended:YES]; // 暂停queue
    //
    //    [queue setSuspended:NO]; // 继续queue
    
}

- (void)testGCD {
    //    任务(block代码块) 和 队列（存放任务的组）以及 线程（任务执行的通道）
    //  任务有两种执行方式： 同步（sync）执行 和 异步（async）执行，他们之间的区别2点： 是否会创建新的线程和阻塞当前线程。
    //    同步（sync） 操作，它会阻塞当前线程 + 等待 Block中的任务执行完毕，然后当前线程才会继续往下运行。
    //    异步（async）操作，当前线程会直接往下执行，它不会阻塞当前线程。
    //    线程 （Thread） ：任务执行的通道。
#warning 少 同步异步主宰着线程数，而不是队列。
    
    //    队列有2种：串行队列 和 并行队列。
    //    串行队列 ：放到串行队列里的任务，把任务从队列中，FIFO（先进先出） 地取出来一个执行一个，然后再取下一个，这样一个一个的执行。
    
    //    并行队列 ：放到并行队列的任务，GCD 也会 FIFO的取出来，但不同的是，它取出来一个就会放到别的线程，然后再取出来一个又放到另一个的线程。这样由于取的动作很快，忽略不计，看起来，所有的任务都是一起执行的。不过需要注意，GCD 会根据系统资源控制并行的数量，所以如果任务很多，它并不会让所有任务同时执行。
    
    //    常见的串行队列和创建：主队列->用于刷新UI
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_queue_t queue1 = dispatch_queue_create("test1Queue", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("test2Queue", DISPATCH_QUEUE_SERIAL);
    //    常见的并行队列和创建
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t queue3 = dispatch_queue_create("test3Queue", DISPATCH_QUEUE_CONCURRENT);
    // 任务来了：同步任务
    NSLog(@"之前 - %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
    //  block还是当前的线程，被加到dispatch_get_main_queue这个串行队列中，根据FIFO原则，dispatch_sync 先进入主队列，Block任务后进入主队列，应该先出去，但dispatch_sync要想先出去，必须得block任务执行完才行，也就是必须得block 执行完出去才能执行，这就违背的串行队列的FIFO原则；造成主线程堵塞，死锁而无法继续跳出block 继续向下执行。
            NSLog(@"sync - 刷新UI的线程 : %@",[NSThread currentThread]);
        });
    NSLog(@"之后 - %@", [NSThread currentThread]);
    //    答案：
    //    只会打印第一句：之前 - <NSThread: 0x7fb3a9e16470>{number = 1, name = main} ，然后主线程就卡死了，你可以在界面上放一个按钮，你就会发现点不了了。
    
    //    异步任务：
    //    开始是主队列的当前的主线程执行，async 在serialQueue中的new线程中执行。
    dispatch_queue_t serialQueue = dispatch_queue_create("qsyTest", DISPATCH_QUEUE_SERIAL);
    NSLog(@"之前 - %@", [NSThread currentThread]);
    dispatch_async(serialQueue, ^{
        NSLog(@"sync之前 - %@", [NSThread currentThread]);
        //  会造成线程死锁。。。
        dispatch_sync(serialQueue, ^{
            NSLog(@"sync - %@", [NSThread currentThread]);
        });
        NSLog(@"sync之后 - %@", [NSThread currentThread]);
    });
    NSLog(@"之后 - %@", [NSThread currentThread]);
    //    答案：
    //    2015-07-30 02:06:51.058 test[33329:8793087] 之前 - <NSThread: 0x7fe32050dbb0>{number = 1, name = main}
    //    2015-07-30 02:06:51.059 test[33329:8793356] sync之前 - <NSThread: 0x7fe32062e9f0>{number = 2, name = (null)}
    //    2015-07-30 02:06:51.059 test[33329:8793087] 之后 - <NSThread: 0x7fe32050dbb0>{number = 1, name = main}
    
    //   队列组可以将很多队列添加到一个组里:当这个组里所有的任务都执行完了，队列组会通过一个方法通知我们
    dispatch_group_t group1 = dispatch_group_create();
    dispatch_queue_t globalQueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(group1, globalQueue1, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group1, globalQueue1, ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group1, globalQueue1, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    
    //上述操作都完成后，会自动通知
    dispatch_group_notify(group1, globalQueue1, ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
    NSLog(@"====");
    //  结果： 2015-07-28 03:40:34.277 test[12540:3319271] group-03 - <NSThread: 0x7f9772536f00>{number = 3, name = (null)}
    //
    //    2015-07-28 03:40:34.277 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.277 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.277 test[12540:3319271] group-03 - <NSThread: 0x7f9772536f00>{number = 3, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319271] group-03 - <NSThread: 0x7f9772536f00>{number = 3, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319271] group-03 - <NSThread: 0x7f9772536f00>{number = 3, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.277 test[12540:3319273] group-01 - <NSThread: 0x7f977272e8d0>{number = 2, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319271] group-03 - <NSThread: 0x7f9772536f00>{number = 3, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319273] group-01 - <NSThread: 0x7f977272e8d0>{number = 2, name = (null)}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.278 test[12540:3319273] group-01 - <NSThread: 0x7f977272e8d0>{number = 2, name = (null)}
    //
    //    2015-07-28 03:40:34.279 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.279 test[12540:3319146] group-02 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
    //
    //    2015-07-28 03:40:34.279 test[12540:3319146] 完成 - <NSThread: 0x7f977240ba60>{number = 1, name = main}
#warning 少 2点注意事项
//    dispatch_barrier_async 和自定义的DISPATCH_QUEUE_CONCURRENT queue 搭配使用，执行顺序去执行
    dispatch_queue_t barrierQueue =  dispatch_queue_create("barrierQueue", DISPATCH_QUEUE_CONCURRENT);
    //    当传入的 queue 是通过 DISPATCH_QUEUE_CONCURRENT 参数自己创建的 queue 时（如果是非自定义get获取的队列），这个方法会阻塞这个 queue. 直到这个 queue 中排在它前面的任务都执行完成后才会开始执行自己，自己执行完毕后，再取消阻塞，使这个 queue 中排在它后面的任务继续执行。dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)不行。
    NSLog(@"查看barrier_async前的线程%@",[NSThread currentThread]);
    dispatch_barrier_async(barrierQueue, ^{
        //       执行并不确定
        NSLog(@"看看async是不是能阻塞队列：%@",[NSThread currentThread]);
    });
    NSLog(@"查看barrier_async后的线程%@",[NSThread currentThread]);
    
#warning 少  dispatch_barrier_sync 和 dispatch_sync 在 并行队列 能实现任务的按顺序一步步执行。
    dispatch_barrier_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"看看barrier_sync是不是能阻塞队列：%@",[NSThread currentThread]);
    });
    NSLog(@"查看barrier_sync后的线程%@",[NSThread currentThread]);
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSLog(@"看看sync是不是能阻塞队列：%@",[NSThread currentThread]);
    });
    NSLog(@"查看sync后的线程%@",[NSThread currentThread]);
    
    
# warning 少 延迟加载 1 和 2
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //  要加载的数据 要执行串行队列的任务
    });
    
    // 在当前主线程中执行： NSRunLoop *mainRunLoop = [NSRunLoop mainRunLoop];会造成阻塞线程，滑动table和计时器操作，不可能同时响应。
    //     [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(run:) userInfo:@{@"a":@1} repeats:NO];
    
    //   不在mainRunLoop中执行，不影响其他的runLoop
    //    控制NSRunLoop里面线程的执行和休眠，在有事情做的时候使当前NSRunLoop控制的线程工作，没有事情做让当前NSRunLoop的控制的线程休眠。
    NSTimer *timer2 = [NSTimer timerWithTimeInterval:.3f target:self selector:@selector(run:) userInfo:@{@"a":@1} repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
    
#warning 少 dispatch source 的作用是负责监听事件
    // 资源队列
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW,1 * NSEC_PER_SEC, 0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"监听函数：%lu",dispatch_source_get_data(timer));
    });
    dispatch_resume(timer);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSInteger i = 0;
        dispatch_source_merge_data(timer,i);
    });
}

//创建别忘, 释放timer
- (void)dealloc {
    NSTimer *timer ;
    [timer invalidate];
    timer = nil;
}

@end
