#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

#include <imgui.h>

@interface MainRenderer : NSObject<MTKViewDelegate>
{
    @public
        MTKView*            m_view;
        id<MTLDevice>       m_device;
        id<MTLCommandQueue> m_commandQueue;
}

@end

@implementation MainRenderer

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{
    
}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    @autoreleasepool
    {
        id<MTLCommandBuffer> commandBuffer = [m_commandQueue commandBuffer];      
        id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor: [m_view currentRenderPassDescriptor]];

        ImGui::Render();
        ImGui_ImplMetal_RenderDrawData( ImGui::GetDrawData(), commandBuffer, commandEncoder);
        
        [commandEncoder endEncoding];
        [commandBuffer presentDrawable: [m_view currentDrawable]];
        [commandBuffer commit];
    }
}

@end

MainRenderer* CreateMainRenderer()
{
    MainRenderer* renderer = [MainRenderer new];

    CGRect contentRect = CGRectMake( 0, 0, 800, 600 );

    renderer->m_device       = MTLCreateSystemDefaultDevice();
    renderer->m_view         = [[MTKView alloc] initWithFrame: contentRect device: renderer->m_device];
    renderer->m_commandQueue = [renderer->m_device newCommandQueue];

    [renderer->m_view setDelegate: renderer];
    [renderer->m_view setNeedsDisplay: false];
    [renderer->m_view setPaused: true];
    [renderer->m_view setClearColor: MTLClearColorMake( 0.5, 0.5, 0.5, 1.0)];
    
    return renderer;
}

void Render( MainRenderer* renderer )
{
    [renderer->m_view draw];
}
