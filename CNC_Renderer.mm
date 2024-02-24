#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

@interface MainRenderer : NSObject<MTKViewDelegate>
@end

@implementation MainRenderer

- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size
{

}

- (void)drawInMTKView:(nonnull MTKView *)view
{
    
}

@end

MainRenderer* CreateMainRenderer()
{
    MainRenderer* renderer;
    return renderer;
}