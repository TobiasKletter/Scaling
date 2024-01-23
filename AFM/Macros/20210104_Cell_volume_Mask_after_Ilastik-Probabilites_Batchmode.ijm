root = "/Volumes/TOB_WD2/Image_Analysis/Cell_volumes/20200807/20200807-174159" + "/";
rawDir = "/Volumes/TOB_WD2/Microscopy/20200807/20200809-114236/HighZoom_tif/Stack/Isotropic_tubulin" + "/";
dataDir = root + "Isotropic_tubulin_probs/20200809_Isotropic_tubulin_probs" + "/";
binaryDir = root + "Isotropic_binaries" + "/";
outDir = root + "Measurements" + "/";
fileList = getFileList(dataDir);
	
sigma = 2.0;
threshold = 0.40;
dilation = 4;

run("Close All");

setBatchMode(true);

for (i = 0; i < fileList.length; i++) 
	{
	
	
	fileName = dataDir + fileList[i];
	file_naked = split(fileList[i], ".");
	file_naked_name = file_naked[0];
	file_naked_name = split(file_naked_name, "_");
	file_naked_name = file_naked_name[0] + "_" + file_naked_name[1];
	

	open(fileName);
	print("Opening: " + fileName);
	print("Raw cell id: " + file_naked_name);
	rename("Probs");
	number_of_slices = nSlices;	
	run("Gaussian Blur 3D...", "x=sigma y=sigma z=sigma");
	setThreshold(threshold, 1);
	run("Convert to Mask", "method=Default background=Default black");
	run("Morphological Filters (3D)", "operation=Opening element=Cube x-radius=dilation y-radius=dilation z-radius=dilation");
	rename("Mask");
	run("Z Project...", "projection=[Max Intensity]");
	getStatistics(area, mean, min, max, std, histogram);
	if (max == 255) {
		selectWindow("Mask");
		run("Connected Components Labeling", "connectivity=6 type=[16 bits]");
		run("Keep Largest Region");
		run("Fill Holes (Binary/Gray)");
		run("Properties...", "channels=1 slices=96 frames=1 pixel_width=0.25 pixel_height=0.25 voxel_depth=0.25 frame=[NaN sec]");
		run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=number_of_slices frames=1 display=Color");
		run("8-bit");
		rename("Binary");
		run("Analyze Regions 3D", "volume surface_area sphericity surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
		Table.rename(Table.title, "Results");
		setResult("Cell_ID", 0, file_naked_name);
		setResult("Threshold", 0, threshold);
		setResult("Morph Radius", 0, dilation);
		updateResults();
		saveAs("Results", outDir + file_naked_name + "_results_probabilities.csv");
		raw_path = rawDir + file_naked_name + ".tif";
		print("Opening Raw path: " + raw_path);
		open(raw_path);
		rename("Raws");
		
		run("Merge Channels...", "c4=Raws c5=Binary create keep");
		saveAs("tiff", binaryDir + file_naked_name + "_binary.tif");
	} else {
		run("Close All");
		print("No objects detected");
	}

	run("Close All");
	print("Finished analysis of " + fileList[i]);
	}
print("Finished analysis.")