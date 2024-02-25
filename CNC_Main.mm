#include <AppKit/AppKit.h>
#include "CNC_Window.mm"
#include "CNC_Renderer.mm"

#include "CNC_ImGui.h"

int main()
{
    bool running = true;

    NSApplication* app = [NSApplication sharedApplication];
    [app setPresentationOptions: NSApplicationPresentationDefault];
    [app setActivationPolicy: NSApplicationActivationPolicyRegular];
    [app activateIgnoringOtherApps: true];
    [app finishLaunching];

    MainWindow*   window   = CreateMainWindow( &running );
    MainRenderer* renderer = CreateMainRenderer();

    [window setContentView: renderer->m_view];

    // IMGUI SETUP
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls
    
    // Setup Dear ImGui style
    ImGui::StyleColorsDark();

    // Setup Renderer backend
    ImGui_ImplMetal_Init(renderer->m_device);
    
    while( running )
    {
        @autoreleasepool
        {
            NSEvent* event = NULL;
            do
            {
                event = [app nextEventMatchingMask: NSEventMaskAny
                                         untilDate: NULL 
                                            inMode: NSDefaultRunLoopMode 
                                           dequeue:true];

                [app sendEvent: event];                                           
                [app updateWindows];
            }
            while( event != NULL );

            [window->m_displayLinkSignal wait];

            // render the app here
            Render( renderer );
        }
    }

    return 0;
}