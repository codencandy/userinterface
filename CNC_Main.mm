#include <AppKit/AppKit.h>

#define IMGUI_DEFINE_MATH_OPERATORS
#include <imgui.h>
#include <imgui_impl_metal.h>
#include <imgui_impl_osx.h>

#include "CNC_Window.mm"
#include "CNC_Renderer.mm"

void CustomizeUi();

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
    
    // Setup Renderer backend
    ImGui_ImplMetal_Init(renderer->m_device);
    ImGui_ImplOSX_Init(renderer->m_view);

    ImGuiIO& io = ImGui::GetIO(); (void)io;
    io.DisplaySize.x = renderer->m_view.bounds.size.width;
    io.DisplaySize.y = renderer->m_view.bounds.size.height;

    CGFloat framebufferScale = renderer->m_view.window.screen.backingScaleFactor ?: NSScreen.mainScreen.backingScaleFactor;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);

    CustomizeUi();
    
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

            static bool show_demo_window = true;
            if( show_demo_window )
            {
                ImGui::ShowDemoWindow( &show_demo_window );
            }
            else
            {
                if( io.KeysDown[ImGuiKey_F1] )
                {
                    show_demo_window = true;
                }
            }

            // render the app here
            Render( renderer );
        }
    }

    ImGui_ImplMetal_Shutdown();
    ImGui_ImplOSX_Shutdown();
    ImGui::DestroyContext( NULL );

    return 0;
}

void CustomizeUi()
{
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;     // Enable Keyboard Controls
    io.Fonts->AddFontFromFileTTF( "res/blender_book.ttf", 15 );

    // Setup Dear ImGui style
    ImGui::StyleColorsDark();
    ImGuiStyle& myStyle = ImGui::GetStyle();
    
    // padding & spacing
    myStyle.WindowPadding     = ImVec2( 12.0f, 12.0f );
    myStyle.FramePadding      = ImVec2( 12.0f, 8.0f );
    myStyle.ItemSpacing       = ImVec2( 12.0f, 12.0f );
    myStyle.ItemInnerSpacing  = ImVec2( 4.0f, 4.0f );
    myStyle.IndentSpacing     = 21.0f;

    // borders
    myStyle.FrameBorderSize         = 0.0f;
    myStyle.WindowBorderSize        = 0.0f;
    myStyle.SeparatorTextBorderSize = 1.0f;

    // rounding
    myStyle.WindowRounding    = 6.0f;
    myStyle.FrameRounding     = 3.0f;
    myStyle.ScrollbarRounding = 9.0f;
    myStyle.GrabRounding      = 2.0f;

    ImVec4* colors = ImGui::GetStyle().Colors;
    colors[ImGuiCol_Text]                   = ImVec4(1.00f, 1.00f, 1.00f, 1.00f);
    colors[ImGuiCol_Text]                   = ImVec4(1.00f, 1.00f, 1.00f, 1.00f);
    colors[ImGuiCol_Text]                   = ImVec4(1.00f, 1.00f, 1.00f, 1.00f);
    colors[ImGuiCol_TextDisabled]           = ImVec4(0.50f, 0.50f, 0.50f, 1.00f);
    colors[ImGuiCol_WindowBg]               = ImVec4(0.13f, 0.13f, 0.13f, 0.70f);
    colors[ImGuiCol_ChildBg]                = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    colors[ImGuiCol_PopupBg]                = ImVec4(0.08f, 0.08f, 0.08f, 0.94f);
    colors[ImGuiCol_Border]                 = ImVec4(0.35f, 0.79f, 0.81f, 0.50f);
    colors[ImGuiCol_BorderShadow]           = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    colors[ImGuiCol_FrameBg]                = ImVec4(0.09f, 0.10f, 0.11f, 0.54f);
    colors[ImGuiCol_FrameBgHovered]         = ImVec4(0.17f, 0.18f, 0.20f, 0.40f);
    colors[ImGuiCol_FrameBgActive]          = ImVec4(0.45f, 0.45f, 0.45f, 0.67f);
    colors[ImGuiCol_TitleBg]                = ImVec4(0.04f, 0.04f, 0.04f, 1.00f);
    colors[ImGuiCol_TitleBgActive]          = ImVec4(0.09f, 0.10f, 0.11f, 1.00f);
    colors[ImGuiCol_TitleBgCollapsed]       = ImVec4(0.00f, 0.00f, 0.00f, 0.51f);
    colors[ImGuiCol_MenuBarBg]              = ImVec4(0.14f, 0.14f, 0.14f, 1.00f);
    colors[ImGuiCol_ScrollbarBg]            = ImVec4(0.02f, 0.02f, 0.02f, 0.53f);
    colors[ImGuiCol_ScrollbarGrab]          = ImVec4(0.31f, 0.31f, 0.31f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabHovered]   = ImVec4(0.41f, 0.41f, 0.41f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabActive]    = ImVec4(0.51f, 0.51f, 0.51f, 1.00f);
    colors[ImGuiCol_CheckMark]              = ImVec4(0.23f, 0.82f, 0.72f, 1.00f);
    colors[ImGuiCol_SliderGrab]             = ImVec4(0.88f, 0.77f, 0.24f, 1.00f);
    colors[ImGuiCol_SliderGrabActive]       = ImVec4(0.88f, 0.77f, 0.24f, 1.00f);
    colors[ImGuiCol_Button]                 = ImVec4(0.08f, 0.09f, 0.08f, 0.40f);
    colors[ImGuiCol_ButtonHovered]          = ImVec4(0.49f, 0.49f, 0.49f, 1.00f);
    colors[ImGuiCol_ButtonActive]           = ImVec4(0.27f, 0.28f, 0.30f, 1.00f);
    colors[ImGuiCol_Header]                 = ImVec4(0.26f, 0.59f, 0.98f, 0.31f);
    colors[ImGuiCol_HeaderHovered]          = ImVec4(0.26f, 0.59f, 0.98f, 0.80f);
    colors[ImGuiCol_HeaderActive]           = ImVec4(0.26f, 0.59f, 0.98f, 1.00f);
    colors[ImGuiCol_Separator]              = ImVec4(0.43f, 0.43f, 0.50f, 0.50f);
    colors[ImGuiCol_SeparatorHovered]       = ImVec4(0.10f, 0.40f, 0.75f, 0.78f);
    colors[ImGuiCol_SeparatorActive]        = ImVec4(0.10f, 0.40f, 0.75f, 1.00f);
    colors[ImGuiCol_ResizeGrip]             = ImVec4(0.26f, 0.59f, 0.98f, 0.20f);
    colors[ImGuiCol_ResizeGripHovered]      = ImVec4(0.26f, 0.59f, 0.98f, 0.67f);
    colors[ImGuiCol_ResizeGripActive]       = ImVec4(0.26f, 0.59f, 0.98f, 0.95f);
    colors[ImGuiCol_Tab]                    = ImVec4(0.23f, 0.28f, 0.35f, 0.86f);
    colors[ImGuiCol_TabHovered]             = ImVec4(0.41f, 0.44f, 0.47f, 0.80f);
    colors[ImGuiCol_TabActive]              = ImVec4(0.39f, 0.45f, 0.52f, 1.00f);
    colors[ImGuiCol_TabUnfocused]           = ImVec4(0.07f, 0.10f, 0.15f, 0.97f);
    colors[ImGuiCol_TabUnfocusedActive]     = ImVec4(0.14f, 0.26f, 0.42f, 1.00f);
    colors[ImGuiCol_PlotLines]              = ImVec4(0.61f, 0.61f, 0.61f, 1.00f);
    colors[ImGuiCol_PlotLinesHovered]       = ImVec4(1.00f, 0.43f, 0.35f, 1.00f);
    colors[ImGuiCol_PlotHistogram]          = ImVec4(0.90f, 0.70f, 0.00f, 1.00f);
    colors[ImGuiCol_PlotHistogramHovered]   = ImVec4(1.00f, 0.60f, 0.00f, 1.00f);
    colors[ImGuiCol_TableHeaderBg]          = ImVec4(0.19f, 0.19f, 0.20f, 1.00f);
    colors[ImGuiCol_TableBorderStrong]      = ImVec4(0.31f, 0.31f, 0.35f, 1.00f);
    colors[ImGuiCol_TableBorderLight]       = ImVec4(0.23f, 0.23f, 0.25f, 1.00f);
    colors[ImGuiCol_TableRowBg]             = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    colors[ImGuiCol_TableRowBgAlt]          = ImVec4(1.00f, 1.00f, 1.00f, 0.06f);
    colors[ImGuiCol_TextSelectedBg]         = ImVec4(0.26f, 0.59f, 0.98f, 0.35f);
    colors[ImGuiCol_DragDropTarget]         = ImVec4(1.00f, 1.00f, 0.00f, 0.90f);
    colors[ImGuiCol_NavHighlight]           = ImVec4(0.26f, 0.59f, 0.98f, 1.00f);
    colors[ImGuiCol_NavWindowingHighlight]  = ImVec4(1.00f, 1.00f, 1.00f, 0.70f);
    colors[ImGuiCol_NavWindowingDimBg]      = ImVec4(0.80f, 0.80f, 0.80f, 0.20f);
    colors[ImGuiCol_ModalWindowDimBg]       = ImVec4(0.80f, 0.80f, 0.80f, 0.35f);
}