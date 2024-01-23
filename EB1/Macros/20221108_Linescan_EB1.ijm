inPath = "/Volumes/TOB_WD2/Microscopy/20230728_EB1/Sum_EB1/Correct";
outPath = "/Volumes/TOB_WD2/Microscopy/20230728_EB1/Lines_EB1_Half";

fileList = getFileList(inPath);

for (i = 0; i < fileList.length; i++) 
	{
	fileName = inPath + "/" +  fileList[i];
	print("Opening Raw file: " + fileName);
	open(fileName);

	title_withoutext = File.nameWithoutExtension;

	run("In [+]");
	run("In [+]");
	run("In [+]");
	
	print("Waiting for user input");
	Wait_title = "Draw the line";
	msg = "Use the line tool to draw a line (width = 15 for 100x or 10 for 60x)";
	waitForUser(Wait_title, msg);

	selectWindow(fileList[i]);
	run("Clear Results");

	profile = getProfile();
	for (j=0; j<profile.length; j++)
  		setResult("Value", j, profile[j]);
	updateResults();

	saveAs("Measurements", outPath + "/" + title_withoutext + "_EB1profile.txt");
	run("Close All");
	}
