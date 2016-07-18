// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGExternalFile.m instead.

#import "_KGExternalFile.h"

@implementation KGExternalFileID
@end

@implementation _KGExternalFile

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ExternalFile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ExternalFile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ExternalFile" inManagedObjectContext:moc_];
}

- (KGExternalFileID*)objectID {
	return (KGExternalFileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic link;

@end

@implementation KGExternalFileAttributes 
+ (NSString *)link {
	return @"link";
}
@end

