//
//  KGBusinessLogic.m
//  Mattermost
//
//  Created by Igor Vedeneev on 06.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"
#import "KGCurrency.h"
#import <MagicalRecord/MagicalRecord.h>
#import <RestKit/RestKit.h>

static NSString *const KGAPIURL_DEV = @"https://mattermost.kilograpp.com/api/v3/";

@interface KGBusinessLogic ()

@property (strong, nonatomic, readwrite) RKObjectManager *defaultObjectManager;
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
    }
    
    return self;
}
- (RKObjectManager *)defaultObjectManager {
    if (!_defaultObjectManager) {
        NSURL *serverAddressUrl = [NSURL URLWithString:KGAPIURL_DEV];
        RKObjectManager *manager = [RKObjectManager managerWithBaseURL:serverAddressUrl];
        
        [manager setManagedObjectStore:self.managedObjectStore];
        
        [manager.HTTPClient setParameterEncoding:AFJSONParameterEncoding];
        [manager.HTTPClient setDefaultHeader:@"Content-Type" value:@"application/json"];
        [manager.HTTPClient setDefaultHeader:@"Accept-Language" value:[self currentLocale]];
        manager.requestSerializationMIMEType = RKMIMETypeJSON;
        [manager addResponseDescriptorsFromArray:[KGCurrency responseDescriptors]];
        [self configureAuthorizationHeaderForManager:manager];
        
        _defaultObjectManager = manager;
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

- (void)configureAuthorizationHeaderForDefaultManager {
    [self configureAuthorizationHeaderForManager:self.defaultObjectManager];
}

- (void)configureAuthorizationHeaderForManager:(RKObjectManager *)manager {
//    [manager.HTTPClient setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@", [KGSettings settings].token]];
}



#pragma mark - Private

- (NSString *)currentLocale {
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}


#pragma mark - DELETE

- (void)loadCurrenciesWithCompletion:(void (^)(NSArray *currencies, KGError *error))completion {
    [self.defaultObjectManager getObjectsAtPath:@"expenses/currencies" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (completion) {
            completion(mappingResult.array.copy, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, [KGError errorWithNSError:error]);
        }
    }];
}


@end
