rawDir = "/Volumes/TOB_WD2/Microscopy/20210419_RNAi/Crop_isotropic" + "/";
binaryDir = "/Volumes/TOB_WD2/Microscopy/20210419_RNAi/Binary_Cell" + "/";
outDir = "/Volumes/TOB_WD2/Microscopy/20210419_RNAi/Crop_isotropic_CVcrop" + "/";

fileList = getFileList(rawDir);
	
run("Close All");

setBatchMode(true);

for (i = 0; i < fileList.length; i++) 
	{
	
	filePath = rawDir + fileList[i];
	file_naked = split(fileList[i], "."); 
	
	file_naked_name = file_naked[0];

	C1 = "C1-" + fileList[i];
	C2 = "C2-" + fileList[i];
	C3 = "C3-" + fileList[i];
	C4 = "C4-" + fileList[i]; /////////
	
	binaryPath =  binaryDir + "CELL_" + fileList[i];
	//binaryPath =  binaryDir + fileList[i]; //check!!!
	//binaryPath =  binaryDir + file_naked_name + "_binary.tif"; //check!!!
	
	open(filePath);
	print("Opening: " + filePath);
	print("Raw cell id: " + file_naked_name);
	print("Binary path: " + binaryPath);

	run("Split Channels");
	
	if(File.exists(binaryPath)) {
		open(binaryPath);
		//run("Morphological Filters (3D)", "operation=Erosion element=Ball x-radius=4 y-radius=4 z-radius=4"); /////////////////////////////CHECK
		rename("binary");
		imageCalculator("Multiply create stack", C1,"binary");
		rename("C1_crop");
		imageCalculator("Multiply create stack", C2,"binary");
		rename("C2_crop");
		imageCalculator("Multiply create stack", C3,"binary");
		rename("C3_crop");	
		imageCalculator("Multiply create stack", C4,"binary");
		rename("C4_crop");
		
		//run("Merge Channels...", "c1=C1_crop c2=C2_crop create keep");
		//run("Merge Channels...", "c1=C1_crop c2=C2_crop c3=C3_crop create keep");
		run("Merge Channels...", "c1=C1_crop c2=C2_crop c3=C3_crop c4=C4_crop create keep");
		
		
		saveAs("tiff", outDir + fileList[i]);
	} else {
		print("No binary found.");
	}

	run("Close All");
	print("Finished analysis of " + fileList[i]);
	}
print("Finished analysis.")