@interface SafeSet : NSObject {
    NSMutableSet *set;
    dispatch_queue_t queue;
}
@end

@implementation SafeSet

- (id)init {
    self = [super init];
    set = [NSMutableSet new];
    queue = dispatch_queue_create("Safe Set", NULL);
    return self;
}

- (void)add:(id)val {
    dispatch_async(queue, ^{
        [set addObject:val];
    });
}

- (void)remove:(id)val {
    dispatch_async(queue, ^{
        [set removeObject:val];
    });
}

- (BOOL)contains:(id)val {
    __block BOOL result;
    dispatch_sync(queue, ^{
        result = [set containsObject:val];
    });
    return result;
}

- (NSSet *)toNSSet {
    return [set copy];
}

- (NSUInteger)count {
    return set.count;
}

- (void)removeAllObjects {
    [set removeAllObjects];
}

@end