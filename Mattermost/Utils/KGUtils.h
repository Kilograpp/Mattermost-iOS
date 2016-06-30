//
//  KGUtils.h
//  Envolved
//
//  Created by Dmitry Arbuzov on 28/10/15.
//  Copyright © 2015 Kilograpp. All rights reserved.
//

#ifndef KGUtils_h
#define KGUtils_h

#define STATIC_VAR_ONCE(VAR$, NULLVAL$, INITFORM$...)           \
static dispatch_once_t VAR$##_once$;                            \
static typeof(INITFORM$) VAR$ = (typeof(INITFORM$))(NULLVAL$);  \
dispatch_once (&VAR$##_once$, ^{ VAR$ = (INITFORM$); });

#define STATIC_ONCE(VAR$, INITFORM$...)  STATIC_VAR_ONCE(VAR$, 0, (INITFORM$))

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#define safetyCall(block, ...) if((block)) { block(__VA_ARGS__); }

#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT

#define KGLog(fmt, ...) NSLog(@"KGLog [%@]: %@", NSStringFromSelector(_cmd), ##__VA_ARGS__)

#endif /* KGUtils_h */
