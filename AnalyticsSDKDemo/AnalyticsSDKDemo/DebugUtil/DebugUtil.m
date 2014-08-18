//
//  DebugUtils.m
//  BFServiceStation
//
//  Created by Eric on 10/16/13.
//  Copyright (c) 2013 Baofeng. All rights reserved.
//

#import "DebugUtil.h"

@interface DebugUtil()

#if kHandleException

//@property (nonatomic, assign) BOOL dismissed;
@property (nonatomic, strong) NSMutableArray *exceptionLogs;

void exceptionHandler(NSException *exception);

#endif

@end

@implementation DebugUtil

- (id)init
{
  if (self = [super init]) {
    // 异常捕捉
#if kHandleException
    
    // iOS 自带
//    NSSetUncaughtExceptionHandler(&exceptionHandler);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.exceptionLogs = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kUDBfExceptionLogs]];
    
    // C
    struct sigaction action;
    
    for (int i = 0; sys_fatal_signals[i]; ++i) {
      sigaction(sys_fatal_signals[i], NULL, &action);
      if (action.sa_handler == SIG_DFL) {
        action.sa_handler = sys_signal_process;
        sigaction(sys_fatal_signals[i], &action, NULL);
      }
    }
    
#endif
  }
  return self;
}

#pragma mark - public

+ (id)sharedDebug
{
  static DebugUtil *du = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    du = [[DebugUtil alloc] init];
  });
  return du;
}

- (void)startLog
{
  // 添加控制台Log 后期可添加文件Log等
//  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  
#if ENABLE_PONYDEBUGGER
  
  NSString *pdServerUrl = [GlobalConfig serversWithKey:@"pd_server"];
  
  if ([pdServerUrl length] > 0) {
    PDDebugger *debugger = [PDDebugger defaultInstance];
    
    // Enable Network debugging, and automatically track network traffic that comes through any classes that NSURLConnectionDelegate methods.
    [debugger enableNetworkTrafficDebugging];
    [debugger forwardAllNetworkTraffic];
    
    // Enable View Hierarchy debugging. This will swizzle UIView methods to monitor changes in the hierarchy
    // Choose a few UIView key paths to display as attributes of the dom nodes
    [debugger enableViewHierarchyDebugging];
    [debugger setDisplayedViewAttributeKeyPaths:@[@"frame", @"hidden", @"alpha", @"opaque", @"accessibilityLabel"]];
    
    // Connect to a specific host
    NSString *url = [NSString stringWithFormat:@"ws://%@:9000/device", pdServerUrl];
    [debugger connectToURL:[NSURL URLWithString:url]];
    // Or auto connect via bonjour discovery
    [debugger autoConnect];
    
    // Enable remote logging to the DevTools Console via PDLog()/PDLogObjects().
    [debugger enableRemoteLogging];
  }
#endif
  
#if LOG2FILE

  [SQTestManager showUseTimes];
  [SQTestManager rewriteAllToFile];
  
#endif
  
#if ENABLE_REVEAL
  
//  [self loadReveal];
//  
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:self];
  
#endif
}

#pragma mark - exception

#if kHandleException

static void sys_signal_process(int sig)
{
  fprintf(stderr,"  fatal err sigal = %d\n", sig);
  fflush(stderr);
  
  NSString *log = [NSString stringWithFormat:@"fatal err sigal = %d\n %@", sig, [NSThread callStackSymbols]];
  [[DebugUtil sharedDebug] LogException:log];
  
  signal(sig, SIG_DFL);
  raise(sig);
}

static const int sys_fatal_signals[] =
{
  SIGSEGV,
  SIGBUS,
  SIGFPE,
  SIGQUIT,
  SIGABRT,
  SIGILL,
  0
};

// 写入userDefault
- (void)LogException:(NSString *)log
{
  if (!_exceptionLogs) {
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.exceptionLogs = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:kUDBfExceptionLogs]];
  }
  
  [_exceptionLogs addObject:[@"> " stringByAppendingString:log]];
	if ([_exceptionLogs count] > kMaxExceptionItems) {
		[_exceptionLogs removeObjectAtIndex:0];
	}
  [[NSUserDefaults standardUserDefaults] setObject:_exceptionLogs forKey:kUDBfExceptionLogs];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSLog(@"Deubg - LogException:%@", log);
  
  // 报到数据中心
//  NSString *channel = [[TMCache sharedCache] objectForKey:kTMKeyLoggerCurrentChannel];
//  NSDictionary *msgs = @{
//                         @"ec"    : [log length] > 0 ? log : @"",
//                         @"pg"    : [channel length] > 0 ? channel : @"",
//                         @"at"    : [NSString getCurrentDateTime:nil],
//                         };
//  
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    [[DataManager defaultManager] loggerWithType:kBFLoggerTypeError msgs:msgs];
//  });
}

void exceptionHandler(NSException *exception)
{
#if kUseGoogleStackTrace
	
  extern NSString *GTMStackTraceFromException(NSException *e);
  NSString *log = [NSString stringWithFormat:@"%@\n\nStack trace:\n%@)", exception, GTMStackTraceFromException(exception)];
  [[DebugUtil sharedDebug] LogException:log];
  
#else
  
	NSString *log = [NSString stringWithFormat:@"%@\n\nStack trace:\n%@", exception, exception.callStackSymbols];
  [[DebugUtil sharedDebug] LogException:log];
  
#endif
}

#endif

//#pragma mark - Reveal
//
//#import <dlfcn.h>
//
//- (void)loadReveal
//{
//  NSString *revealLibName = @"libReveal";
//  NSString *revealLibExtension = @"dylib";
//  NSString *dyLibPath = [[NSBundle mainBundle] pathForResource:revealLibName ofType:revealLibExtension];
//  NSLog(@"Loading dynamic library: %@", dyLibPath);
//  
//  void *revealLib = NULL;
//  revealLib = dlopen([dyLibPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
//  
//  if (revealLib == NULL) {
//    char *error = dlerror();
//    NSLog(@"dlopen error: %s", error);
//    NSString *message = [NSString stringWithFormat:@"%@.%@ failed to load with error: %s", revealLibName, revealLibExtension, error];
//    [[[UIAlertView alloc] initWithTitle:@"Reveal library could not be loaded" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//  }
//}

@end
