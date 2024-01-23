root = "/Volumes/TOB_WD2/Microscopy/20231025_TPX2" + "/";
rawDir = root + "Crop" + "/";
binaryDir = root + "Binary_Cell" + "/";

outDir = root + "Total_Cell_TPX2" + "/";

fileList = getFileList(binaryDir);

run("Close All");
setBatchMode(true);
for (i = 0; i < fileList.length; i++) 
	{
	
	
	fileName = binaryDir + fileList[i];
	file_naked = split(fileList[i], ".");
	file_naked_name = file_naked[0];
	file_naked_name = substring(file_naked_name, 5);

	raw_path = rawDir + file_naked_name + ".tif";
	
	open(fileName);
	print("Opening: " + fileName);

	rename("Binary");
	//run("8-bit");

	print("Opening Raw path: " + raw_path);
	open(raw_path);
	run("Duplicate...", "duplicate channels=3"); /////////////////////////
	rename("Raws");
	
	run("3D Intensity Measure", "objects=Binary signal=Raws");
	setResult("Cell_ID", 0, file_naked_name);
	updateResults();
	
	saveAs("Results", outDir + file_naked_name + "_TPX2_total.csv");
	run("Clear Results");
	run("Close All");
	print("Finished analysis of " + fileList[i]);
	}

print("Finished analysis.")