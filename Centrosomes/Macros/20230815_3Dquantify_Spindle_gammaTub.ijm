
   dir = getDirectory("Choose a Directory");
   outdir = getDirectory("Choose_ a Directory");
   
   setBatchMode(false);
   count = 0;
   countFiles(dir);
   n = 0;
   processFiles(dir);
   
   function countFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              countFiles(""+dir+list[i]);
          else
              count++;
      }
  }

   function processFiles(dir) {
      list = getFileList(dir);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/"))
              processFiles(""+dir+list[i]);
          else {
             showProgress(n++, count);
             path = dir+list[i];
             processFile(path);
          }
      }
  }

  function processFile(path) {
       if (endsWith(path, ".zip")) {
           open(path);

		   file_naked = split(list[i], "."); 
	       file_naked_nam = file_naked[0]; 
	       file_naked_name_list = split(file_naked_nam, "-");
	       file_naked_name = file_naked_name_list[0] + "-" + file_naked_name_list[1] + "-" + file_naked_name_list[2];
	       print(file_naked_nam);

		   		run("Split Channels");

				TPX2_staining = "C4-"+file_naked_nam+".tif"; ///////////////////////////
				DNA_mask = "C5-"+file_naked_nam+".tif";
				Tubulin_mask = "C6-"+file_naked_nam+".tif";

				selectWindow(TPX2_staining);
				rename("TPX2signals");
				selectWindow(DNA_mask);
				rename("DNA_binary");
				selectWindow(Tubulin_mask);
				rename("Tubulin_binary");

				run("3D Intensity Measure", "objects=Tubulin_binary signal=TPX2signals");
				setResult("Cell_ID", 0, file_naked_name);
				saveAs("Results", outdir + file_naked_name + "_Spindle_gTub.csv"); ///////////////////////////////

				run("Clear Results");

	            run("Close All");
      }
  }