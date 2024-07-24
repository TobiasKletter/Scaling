root = "D:/Tob/20200807/20200809-114236/Ilastik_old_project" + "/";
rawDir = root + "Ilastik_Input" + "/";
probDir = root + "Ilastik_probabilities" + "/";
outDir = root + "Ilastik_measurements" + "/";
project = "D:/Tob/20191011_mitotic_cell_volu_imported.ilp";

scaleDistance = 3.7565;	
outputtype = "Probabilities"; 
threshold = 0.50
sigma = 2.0

print("Classifier file: "+project);

fileList = getFileList(rawDir);

setBatchMode(false);
for (i = 0; i < fileList.length; i++) {
	fileName = rawDir + fileList[i];
	classifierArgs = "projectfilename=" + project + " inputImage=" + fileName + " pixelclassificationtype=" + outputtype; 
	
	open(fileName);
	fileNameWOext = File.nameWithoutExtension;
	rename("Raws");
	print("Processing next: " + fileNameWOext);
	run("Run Pixel Classification Prediction", classifierArgs);
	rename("Probs");
	run("Duplicate...", "duplicate channels=1");
	save(probDir + fileNameWOext + "_Probability_mask.tif");
	number_of_slices = nSlices;	
	run("Gaussian Blur 3D...", "x=sigma y=sigma z=sigma");
	setThreshold(0.5000, 1);
	run("Convert to Mask", "method=Default background=Default black");
	rename("Stack binary");
	run("Z Project...", "projection=[Max Intensity]");
	rename("Max binary");
	getHistogram(values, counts, 2);
	number_white_pixels = counts[1];
	print("White pixels after thresholding: " + number_white_pixels);
	if(number_white_pixels > 0) {
		selectWindow("Stack binary");
		run("Connected Components Labeling", "connectivity=6 type=[16 bits]");
		run("Keep Largest Region");
		run("Set Scale...", "distance=scaleDistance known=1 pixel=1 unit=micron");
		run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=number_of_slices frames=1 display=Color");
		run("8-bit");
		rename("Binary");
		bitdepth = bitDepth(); 
		if(bitdepth == 8) {
			run("Merge Channels...", "c4=Raws c5=Binary create keep");
			run("Make Montage...", "columns=10 rows=2 scale=0.50 increment=5");
			run("Enhance Contrast", "saturated=0.35");
			run("RGB Color");
			save(probDir + fileNameWOext+ "_probability_montage.png");
			}
		else {
			print("Incorrect bitdepth for merging");
		}
		selectWindow("Binary");
		run("Analyze Regions 3D", "volume surface_area sphericity surface_area_method=[Crofton (13 dirs.)] euler_connectivity=C26");
		Table.rename(Table.title, "Results");
		setResult("Name", 0, fileList[i]);
		updateResults();
		saveAs("Results", outDir + fileNameWOext+ "_results_probabilities.csv");
		}
	else{
		print("Nothing above threshold");
	}
	run("Close All");
	print("Finished analysis of " + fileList[i]); 
}
setBatchMode(false);
print("Finished analysis.")
