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
{
    @public
        NSCondition*     m_displayLinkSignal;
        CVDisplayLinkRef m_displayLink;
}
@end

@implementation MainWindow

- (BOOL)windowCanBecomeKey  { return true; }
- (BOOL)windowCanBecomeMain { return true; }

@end

CVReturn DisplayLinkCallback( CVDisplayLinkRef displayLink, 
                              const CVTimeStamp *inNow, 
                              const CVTimeStamp *inOutputTime, 
                              CVOptionFlags flagsIn, 
                              CVOptionFlags *flagsOut, 
                              void *displayLinkContext )
{
    MainWindow* window = (MainWindow*)displayLinkContext;

    [window->m_displayLinkSignal signal];

    return kCVReturnSuccess;
}

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

    CVDisplayLinkCreateWithActiveCGDisplays( &window->m_displayLink );
    CVDisplayLinkSetOutputCallback( window->m_displayLink, &DisplayLinkCallback, (void*)window );
    CVDisplayLinkStart( window->m_displayLink );

    return window;
}