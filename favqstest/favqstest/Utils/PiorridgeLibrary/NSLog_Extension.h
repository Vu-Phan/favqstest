//
//  NSLog+Extension.h
//  PiorridgeLibrary
//
//  Created by Vu Phan on 22/12/2020.
//

/*
 https://gist.github.com/marzapower/4716120
 A simple way to make your Xcode console logs more readable. SLog stands for "Short Log", DLog for "Debug Log" and ALog for "Always Log". Automagically, all the NSLog calls will be redirected to the new SLog. SLog just replaces NSLog and removes all the log noise (complete timestamp, app name, memory addresses, etc.). DLog and ALog will also prep…
 */

#define LOG_DEBUG

#define __PREPEND_DATE(format)  ([NSString stringWithFormat:@"[%@] %@", [[[NSDate new] description] componentsSeparatedByString:@" "][1], [@"%@" stringByAppendingString:format]])
#define SLog(args,...) do { [[NSFileHandle fileHandleWithStandardOutput] writeData:[[NSString stringWithFormat:__PREPEND_DATE(args), @"", ##__VA_ARGS__] dataUsingEncoding: NSUTF8StringEncoding]]; [[NSFileHandle fileHandleWithStandardOutput] writeData: [@"\n" dataUsingEncoding: NSUTF8StringEncoding]]; } while(0);

#ifdef LOG_DEBUG
#define NSLog SLog
#endif

//	// ALog always displays output regardless of the DEBUG setting
//#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//
//	// DLog displays current method and line where the log call starts. Won't log when non in LOG_DEBUG mode
//#ifdef LOG_DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//#else
//#   define DLog(...)
//#endif
