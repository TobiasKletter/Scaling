root = "/Volumes/TOB_WD2/Microscopy/20230831_ODT_M_Osmosis_6633/Ctrl" + "/";
rawDir = root + "ODT_Crops" + "/";
binaryDir = root + "Binary_Cell" + "/";
montageDir = root + "Binary_Cell_Montages" + "/";
outDir = root + "Cell_Volumes" + "/";
outDir2 = root + "3D_Intensity" + "/";
fileList = getFileList(binaryDir);
run("Clear Results");
run("Close All");

setBatchMode(true);
for (i = 0; i < fileList.length; i++) 
	{
	fileName = binaryDir + fileList[i];
	file_naked = split(fileList[i], ".");
	file_naked_name = file_naked[0];

	open(fileName);
	print("Opening: " + fileName);

	rename("Binary");

	run("Duplicate...", "duplicate channels=1");
	rename("MontageMask");
	run("Cyan");
	run("Morphological Filters (3D)", "operation=Dilation element=Cube x-radius=1 y-radius=1 z-radius=1");
	rename("MontageMaskDilation");
	
	imageCalculator("Subtract create stack", "MontageMaskDilation","MontageMask");
	rename("MaskOutline");
	run("16-bit");
	
	raw_path = rawDir + file_naked_name + ".tif";
	print("Opening Raw path: " + raw_path);
	open(raw_path);
	rename("Raws");
	
	run("Merge Channels...", "c4=Raws c5=MaskOutline create keep");
	run("Make Montage...", "columns=10 rows=2 scale=0.75 increment=5");
	run("Enhance Contrast", "saturated=0.35");
	run("RGB Color");
	save(montageDir + file_naked_name + "_segmentation_montage.png");

	selectWindow("Binary");
	run("16-bit");
	run("3D Intensity Measure", "objects=Binary signal=Raws");
	setResult("Cell_ID", 0, file_naked_name);
	updateResults();
	saveAs("Results", outDir2 + file_naked_name + "_3D_intensities.csv");
	run("Clear Results");

	selectWindow("Binary");
	run("Analyze Regions 3D", "volume surface_area sphericity surface_area_method=[Crofton (13 dirs.)] euler_connectivity=6");
	Table.rename(Table.title, "Results");
	setResult("Cell_ID", 0, file_naked_name);
	updateResults();
	saveAs("Results", outDir + file_naked_name + "_cell_volume.csv");
	
	run("Clear Results");
	run("Close All");
	print("Finished analysis of " + fileList[i]);
	}
print("Finished analysis.")