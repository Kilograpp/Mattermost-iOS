//
//  KGBusinessLogic.m
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"
#import "KGBusinessLogic+Session.h"
#import "KGBusinessLogic+ApplicationNotifications.h"
#import <MagicalRecord/MagicalRecord.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <RKObjectManager.h>
#import <RestKit/RestKit.h>
#import "KGConstants.h"
#import "KGBusinessLogic+Socket.h"
#import "RKResponseDescriptor+Runtime.h"
#import "RKRequestDescriptor+Runtime.h"
#import "KGPreferences.h"
#import "KGObjectManager.h"
#import "KGBusinessLogic+Channel.h"
#import "KGJsonSerialization.h"
#import "KGNotificationValues.h"
#import "KGPost.h"
#import <HexColors/HexColors.h>
#import "KGHardwareUtils.h"

@interface KGBusinessLogic ()

@property (assign) BOOL shouldReloadDefaultManager;
@property (strong, nonatomic) NSTimer* statusTimer;
@property (strong, nonatomic, readwrite) KGObjectManager *defaultObjectManager;
@property (strong, nonatomic, readwrite) RKManagedObjectStore *managedObjectStore;

@end

@interface NSManagedObjectContext ()

+ (void)MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_setDefaultContext:(NSManagedObjectContext *)moc;

@end

@implementation KGBusinessLogic

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    if (self = [super init]) {
        [AFRKNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [self setupManagedObjectStore];
        [self setupMagicalRecord];
        [self subscribeForNotifications];
        [self subscribeForServerBaseUrlChanges];
        [self runTimerForStatusUpdate];

    }
    
    return self;
}
- (void)dealloc {
    [self unsubscribeFromNotifications];
    [self unsubscribeFromServerBaseUrlChanges];
}

- (KGObjectManager *)defaultObjectManager {
    if (!_defaultObjectManager || _shouldReloadDefaultManager) {
        KGObjectManager *manager;
        NSURL *serverBaseUrl = [NSURL URLWithString:[[KGPreferences sharedInstance] serverBaseUrl]];
        NSURL *apiBaseUrl = [serverBaseUrl URLByAppendingPathComponent:@"api/v3"];
        manager = [KGObjectManager managerWithBaseURL:apiBaseUrl];
        [manager setManagedObjectStore:self.managedObjectStore];
        [manager.HTTPClient setDefaultHeader:KGXRequestedWithHeader value:@"XMLHttpRequest"];
        [manager.HTTPClient setParameterEncoding:AFRKJSONParameterEncoding];
        [manager.HTTPClient setDefaultHeader:KGContentTypeHeader value:RKMIMETypeJSON];
        [manager.HTTPClient setDefaultHeader:KGAcceptLanguageHeader value:[self currentLocale]];
        [manager.HTTPClient setReachabilityStatusChangeBlock:^(AFRKNetworkReachabilityStatus status) {
            if (status == AFRKNetworkReachabilityStatusNotReachable) {
                [self closeSocket];
                [self updateStatusForAllUsers];
            } else {
                [self openSocket];
            }
            
        }];
        
        if ([KGHardwareUtils sharedInstance].devicePerformance == KGPerformanceLow){
            [[manager operationQueue] setMaxConcurrentOperationCount:2];
        }

        manager.requestSerializationMIMEType = RKMIMETypeJSON;

        RKValueTransformer* dateTransformer = [self millisecondsSince1970ToDateValueTransformer];
        RKValueTransformer* colorTransformer = [self colorValueTransformer];
        [[RKValueTransformer defaultValueTransformer] insertValueTransformer:dateTransformer atIndex:0];
        [[RKValueTransformer defaultValueTransformer] addValueTransformer:colorTransformer];

        [RKMIMETypeSerialization registerClass:[KGJsonSerialization class] forMIMEType:RKMIMETypeJSON];
        
        [manager addResponseDescriptorsFromArray:[RKResponseDescriptor findAllDescriptors]];
        [manager addRequestDescriptorsFromArray:[RKRequestDescriptor findAllDescriptors]];

        
        NSFetchRequest* (^singleFetchRequestBlock) (NSURL* ) = ^NSFetchRequest*(NSURL* URL) {
            if (!URL) {
                return nil;
            }
            
            RKPathMatcher *userPathMatcher = [RKPathMatcher pathMatcherWithPattern:[KGPost firstPagePathPattern]];
            BOOL match = [userPathMatcher matchesPath:[URL relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
            if(match) {
                NSString* channelId = [[[URL relativePath] pathComponents] objectAtIndex:3];
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self.channel.identifier == %@", channelId];
                NSFetchRequest* fetchRequest = [KGPost MR_requestAllWithPredicate:predicate];
                [fetchRequest setIncludesSubentities:NO];
                if([[NSManagedObjectContext MR_defaultContext] countForFetchRequest:fetchRequest error:nil]  > 0) {
                    return fetchRequest;
                }
            }
            return nil;
        };
        
        [manager addFetchRequestBlock:singleFetchRequestBlock];
        _defaultObjectManager = manager;
        _shouldReloadDefaultManager = NO;
    }
    
    return _defaultObjectManager;
}

- (RKValueTransformer*)millisecondsSince1970ToDateValueTransformer
{
    return [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return [sourceClass isSubclassOfClass:[NSNumber class]] && [destinationClass isSubclassOfClass:[NSDate class]];
    } transformationBlock:^BOOL(id inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputValueClass, NSError *__autoreleasing *error) {
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSNumber class] ]), error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputValueClass, (@[ [NSDate class] ]), error);
        *outputValue = [NSDate dateWithTimeIntervalSince1970:[inputValue doubleValue] / 1000];
        return YES;
    }];
}

- (RKValueTransformer*)colorValueTransformer {
    return [RKBlockValueTransformer valueTransformerWithValidationBlock:^BOOL(__unsafe_unretained Class sourceClass, __unsafe_unretained Class destinationClass) {
        return [sourceClass isSubclassOfClass:[NSString class]] && [destinationClass isSubclassOfClass:[UIColor class]];
    } transformationBlock:^BOOL(NSString* inputValue, __autoreleasing id *outputValue, __unsafe_unretained Class outputClass, NSError *__autoreleasing *error) {
        RKValueTransformerTestInputValueIsKindOfClass(inputValue, (@[ [NSString class] ]), error);
        RKValueTransformerTestOutputValueClassIsSubclassOfClass(outputClass, (@[ [UIColor class] ]), error);
        *outputValue = [UIColor hx_colorWithHexRGBAString:[inputValue hx_hexStringTransformFromThreeCharacters]];
        return YES;
    }];
}


#pragma mark - Configuration

- (void)setupManagedObjectStore {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    self.managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    NSError *error = nil;
    
    if (![self.managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error]) {
        NSLog(@"Failed to add Persistent Store: %@", [error localizedDescription]);
    }
    
    [self.managedObjectStore createManagedObjectContexts];
}

- (void)setupMagicalRecord {
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:self.managedObjectStore.persistentStoreCoordinator];
    [NSManagedObjectContext MR_setRootSavingContext:self.managedObjectStore.persistentStoreManagedObjectContext];
    [NSManagedObjectContext MR_setDefaultContext:self.managedObjectStore.mainQueueManagedObjectContext];
}


#pragma mark - Private

- (NSString *)currentLocale {
    return [[NSLocale preferredLanguages] firstObject];
}


#pragma mark - Notifications & Observers

- (void)unsubscribeFromNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)subscribeForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationDidEnterBackground)
                                                 name: UIApplicationDidEnterBackgroundNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationDidBecomeActive)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleRemoteNotificationOpeningWithPayload:)
                                                 name: KGNotificationDidReceiveRemoteNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleLaunchingWithOptionsNotification:)
                                                 name: KGNotificationDidFinishLaunching
                                               object: nil];
}

- (void)subscribeForServerBaseUrlChanges {
    [[KGPreferences sharedInstance] addObserver:self
                                     forKeyPath:@"serverBaseUrl"
                                        options:NSKeyValueObservingOptionOld
                                        context:nil];
}

- (void)unsubscribeFromServerBaseUrlChanges {
    [[KGPreferences sharedInstance] removeObserver:self forKeyPath:@"serverBaseUrl"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"serverBaseUrl"]) {
        self.shouldReloadDefaultManager = YES;
        [self savePreferences];
    }
}

#pragma mark - Application States

- (void)applicationDidBecomeActive {
    [self openSocket];
    [self runTimerForStatusUpdate];
    [self updateChannelsState];
    [self clearPushNotificationsBadgeNumber];
}

- (void)applicationDidEnterBackground {
    UIBackgroundTaskIdentifier taskId = [self beginBackgroundTask];

    [self saveDefaultContextToPersistentStore];
    [self savePreferences];
    [self stopStatusTimer];
    [self closeSocket];

    [self endBackgroundTaskWithId:taskId];
}

- (void)savePreferences {
    [[KGPreferences sharedInstance] save];
}

- (void)saveDefaultContextToPersistentStore {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (UIBackgroundTaskIdentifier)beginBackgroundTask {
    return [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(void) {
        // Uh-oh - we took too long. Stop task.
    }];
}


- (void)endBackgroundTaskWithId:(UIBackgroundTaskIdentifier) taskId {
    if (taskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
    }
}

- (void)clearPushNotificationsBadgeNumber {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - Status Timer

- (void)runTimerForStatusUpdate {
    if (!self.statusTimer) {
        //[self updateStatusForAllUsers];
        self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:7
                                                            target:self
                                                          selector:@selector(updateStatusForAllUsers)
                                                          userInfo:nil
                                                           repeats:YES];
    }



}

- (void)stopStatusTimer {
    [self.statusTimer invalidate];
    self.statusTimer = nil;
}

@end
