#include <AppKit/AppKit.h>

@interface MainWindowDelegate : NSObject<NSWindowDelegate>
{
    @public
        bool* m_running;
}

- (instancetype)initWithBool:(bool*)running;

@end

@implementation MainWindowDelegate

- (instancetype)initWithBool:(bool*)running
{
    self = [super init];
    m_running = running;
    return self;
}

- (BOOL)windowShouldClose:(NSWindow*)sender 
{ 
    *m_running = false;
    return true;
}

@end

@interface MainWindow : NSWindow
@end

@implementation MainWindow

- (BOOL)windowCanBecomeKey  { return true; }
- (BOOL)windowCanBecomeMain { return true; }

@end

MainWindow* CreateMainWindow( bool* running )
{
    NSRect contentRect = NSMakeRect( 0, 0, 800, 600);
    MainWindowDelegate* delegate = [[MainWindowDelegate alloc] initWithBool:running];
    MainWindow*         window   = [[MainWindow alloc] initWithContentRect: contentRect
                                                                 styleMask: NSWindowStyleMaskClosable | NSWindowStyleMaskTitled 
                                                                   backing: NSBackingStoreBuffered 
                                                                     defer: false];

    [window setTitle: @"userinterface by cnc"];
    [window makeKeyAndOrderFront: NULL ];
    [window setDelegate: delegate];

    return window;
}