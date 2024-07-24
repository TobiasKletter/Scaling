// THESE ARE NOT THE CORRECT PIXEL SIZES!!


run("Select None");
getDimensions(width, height, channels, slices, frames);
Stack.setXUnit("µm");
run("Properties...", "channels=1 slices=slices frames=1 pixel_width=0.106 pixel_height=0.106 voxel_depth=2");
Stack.setSlice(7);
run("mpl-viridis");
run("Enhance Contrast", "saturated=0.35");
makeRectangle(550, 300, 200, 200);