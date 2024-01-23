// 60x pixel sizes .19 .19 .38
// 100x pixel sizes .115 .115 .26

run("Select None");
Stack.setXUnit("µm");
run("Properties...", "channels=1 slices=106 frames=1 pixel_width=0.19 pixel_height=0.19 voxel_depth=0.38");
run("mpl-viridis");
Stack.setSlice(53);
run("Enhance Contrast", "saturated=0.35");
makeRectangle(100, 100, 150, 150);