root = "/Volumes/TOB_WD2/Microscopy/20231025_ODT_M_2i/N2B27" + "/";
rawDir = root + "Epi_Crops" + "/"; 
maxDir = root + "Epi_Crops_Max" + "/"; //averages
binaryDir = root + "Epi_Binary" + "/";
montageDir = root + "Epi_Binary_Montages" + "/";
outDir = root + "Spindle_Areas" + "/";


fileList = getFileList(rawDir);
run("Clear Results");
run("Close All");

//setBatchMode(true);
for (i = 0; i < fileList.length; i++) 
	{
	inputPath = rawDir + fileList[i];
	//file_naked = split(fileList[i], "MMStack");
	//file_naked_name = file_naked[0];
	//file_naked_name = substring(file_naked_name, 5);

	fileName = substring(fileList[i], 0, lengthOf(fileList[i])-4);
	
	
	open(inputPath);
	print("Opening: " + inputPath);

	rename("Raws");
	//run("Z Project...", "projection=[Max Intensity]");
	run("Z Project...", "projection=[Average Intensity]");

	makeRectangle(50, 50, 100, 100);
	run("Duplicate...", " ");
	
	save(maxDir + fileName + ".tif");
	rename("Max");

	run("Duplicate...", " ");
	run("Median...", "radius=4");
	
	//setAutoThreshold("Otsu dark");
	//setAutoThreshold("MaxEntropy dark");
	setAutoThreshold("Minimum dark");
	
	setOption("BlackBackground", false);
	run("Convert to Mask");
	save(binaryDir + fileName + "_binary.tif");
	rename("Binary");

	run("Analyze Regions", "area");
	saveAs("Results", outDir + fileName + "_SpindleArea.csv");
	run("Clear Results");
	close(fileName + "_SpindleArea.csv");
	
	selectWindow("Binary");
	run("Duplicate...", "duplicate channels=1");
	rename("MontageMask");
	run("Cyan");
	run("Morphological Filters", "operation=Dilation element=Square radius=1");
	rename("MontageMaskDilation");
	
	imageCalculator("Subtract", "MontageMaskDilation","MontageMask");
	rename("MaskOutline");
	run("16-bit");
	
	
	run("Merge Channels...", "c4=Max c5=MaskOutline create keep");
	run("Enhance Contrast", "saturated=0.35");
	run("RGB Color");
	save(montageDir + fileName + "_segmentation_montage.png");
	
	run("Clear Results");
	run("Close All");
	print("Finished analysis of " + fileList[i]);
	}
//setBatchMode(false);
print("Finished analysis.")