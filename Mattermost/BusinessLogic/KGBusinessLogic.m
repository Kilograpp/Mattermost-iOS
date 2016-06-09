//
//  KGBusinessLogic.m
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"
#import <MagicalRecord/MagicalRecord.h>
#import <RKObjectManager.h>
#import <RestKit/RestKit.h>
#import "KGConstants.h"
#import "RKResponseDescriptor+Runtime.h"
#import "RKRequestDescriptor+Runtime.h"
#import "KGPreferences.h"
#import "KGObjectManager.h"

@interface KGBusinessLogic ()

@property (assign) BOOL shouldReloadDefaultManager;
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
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [self setupManagedObjectStore];
        [self setupMagicalRecord];
        [self subscribeForNotifications];
        [self subscribeForServerBaseUrlChanges];

    }
    
    return self;
}
- (void)dealloc {
    [self unsubscribeFromNotifications];
    [self unsubscribeFromServerBaseUrlChanges];
}

- (KGObjectManager *)defaultObjectManager {
    if (!_defaultObjectManager || _shouldReloadDefaultManager) {
        NSURL *serverBaseUrl = [NSURL URLWithString:[[KGPreferences sharedInstance] serverBaseUrl]];
        NSURL *apiBaseUrl = [serverBaseUrl URLByAppendingPathComponent:@"api/v3"];
        KGObjectManager *manager = [KGObjectManager managerWithBaseURL:apiBaseUrl];
        [manager setManagedObjectStore:self.managedObjectStore];

        [manager.HTTPClient setDefaultHeader:KGXRequestedWithHeader value:@"XMLHttpRequest"];
        [manager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
        [manager.HTTPClient setDefaultHeader:KGContentTypeHeader value:RKMIMETypeJSON];
        [manager.HTTPClient setDefaultHeader:KGAcceptLanguageHeader value:[self currentLocale]];
        manager.requestSerializationMIMEType = RKMIMETypeJSON;
        
        [manager addResponseDescriptorsFromArray:[RKResponseDescriptor findAllDescriptors]];
        [manager addRequestDescriptorsFromArray:[RKRequestDescriptor findAllDescriptors]];

        _defaultObjectManager = manager;
        _shouldReloadDefaultManager = NO;
    }
    
    return _defaultObjectManager;
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
    }
}

#pragma mark - Background

- (void)applicationDidEnterBackground {
    UIBackgroundTaskIdentifier taskId = [self beginBackgroundTask];

    [self savePreferences];

    [self endBackgroundTaskWithId:taskId];
}

- (void)savePreferences {
    [[KGPreferences sharedInstance] save];
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


@end
