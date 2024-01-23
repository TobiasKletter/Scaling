root = "/Volumes/TOB_WD2/Microscopy/20230721_Centrosome_Cenp-j" + "/";
rawDir = root + "Crop_CVcrop" + "/";
binaryDir = root + "Binary_CentrosomesPericentrin" + "/";
montageDir = root + "Binary_CentrosomesPericentrin_Montages" + "/";
outDir = root + "Pericentrin_Volumes" + "/";
intensityDir = root + "3D_Intensity_Pericentrin" + "/";

fileList = getFileList(rawDir);

run("Close All");
setBatchMode(true);
for (i = 0; i < fileList.length; i++) 
	{

	fileName = rawDir + fileList[i];
	file_naked = split(fileList[i], ".");
	file_naked_name = file_naked[0];
	
	open(fileName);
	print("Opening: " + fileName);

	run("Split Channels");
	selectWindow("C3-" + fileList[i]); 
	run("Grays");
	rename("C3_raw");
	run("Duplicate...", "duplicate channels=1");
	
	rename("C3_raw_copy");
	run("Duplicate...", "duplicate channels=1");
	setAutoThreshold("MaxEntropy dark no-reset stack");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=MaxEntropy background=Dark black");
	
	run("Morphological Filters (3D)", "operation=Opening element=Ball x-radius=1 y-radius=1 z-radius=1");
	rename("C3_mask");
	run("3D Intensity Measure", "objects=C3_mask signal=C3_raw");
	setResult("Cell_ID", 0, file_naked_name);
	saveAs("Results", intensityDir + file_naked_name + "_Pole_Pericentrin.csv");
	run("Clear Results");

	selectWindow("C3_mask");
	run("Duplicate...", "duplicate channels=1");
	rename("MontageMask");
	run("Cyan");
	run("Morphological Filters (3D)", "operation=Dilation element=Cube x-radius=1 y-radius=1 z-radius=1");
	rename("MontageMaskDilation");
	
	imageCalculator("Subtract create stack", "MontageMaskDilation","MontageMask");
	rename("MaskOutline");
	run("16-bit");

	selectWindow("C3_raw_copy");
	run("Invert", "stack");
	run("Merge Channels...", "c4=C3_raw_copy c5=MaskOutline create keep");
	Stack.setChannel(1);
	run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(2);
	run("Brightness/Contrast...");
	run("Enhance Contrast", "saturated=0.35");
	run("RGB Color", "slices keep");
	run("Make Montage...", "columns=10 rows=10 scale=1 increment=1");
	save(montageDir + file_naked_name + "_segmentation_montage.png");

	selectWindow("C3_mask");
	run("Analyze Regions 3D", "volume surface_area sphericity surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
	Table.rename(Table.title, "Results");
	setResult("Cell_ID", 0, file_naked_name);
	updateResults();
	saveAs("Results", outDir + file_naked_name + "_centrosomePericentrin_volume.csv");

	selectWindow("C3_mask");
	saveAs("Tiff", binaryDir + fileList[i]);
	
	run("Close All");
	print("Finished analysis of " + fileList[i]);

	run("Clear Results");
	}

print("Finished analysis.")