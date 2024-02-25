#include <AppKit/AppKit.h>

#define IMGUI_DEFINE_MATH_OPERATORS
#include "CNC_ImGui.h"
#include "CNC_Window.mm"
#include "CNC_Renderer.mm"

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
    ImGui_ImplOSX_Init(renderer->m_view);
    
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

            // Start the Dear ImGui frame
            ImGui_ImplMetal_NewFrame( [renderer->m_view currentRenderPassDescriptor] );
            ImGui_ImplOSX_NewFrame( renderer->m_view );
            ImGui::NewFrame();

            ImGuiIO& io = ImGui::GetIO();
            io.DisplaySize.x = renderer->m_view.bounds.size.width;
            io.DisplaySize.y = renderer->m_view.bounds.size.height;

            CGFloat framebufferScale = renderer->m_view.window.screen.backingScaleFactor ?: NSScreen.mainScreen.backingScaleFactor;
            io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);

            static bool show_demo_window = true;
            ImGui::ShowDemoWindow( &show_demo_window );

            // render the app here
            Render( renderer );
        }
    }

    return 0;
}