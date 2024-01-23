   dir = getDirectory("Choose a Directory");
   outdir = getDirectory("Choose_ a Directory");
   
   setBatchMode(true);
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
		   run("Arrange Channels...", "new=12567"); //CHECK (= 4 Imaging channels)
		   //run("Arrange Channels...", "new=12456"); //CHECK (= 3 Imaging channels)
		   file_naked = split(list[i], ".");
	       file_naked_name = file_naked[0];

		   getDimensions(width, height, channels, slices, frames);

		   columnsAdjust = slices / 10;
	
		   run("Make Montage...", "columns=columnsAdjust rows=10 scale=1");
		   rename("Montage");
		   Stack.setPosition(1,1,1);
		   run("Enhance Contrast", "saturated=0.35");
		   Stack.setPosition(2,1,1);
		   run("Enhance Contrast", "saturated=0.35");
		   run("RGB Color");
           saveAs("png", outdir + file_naked_name + ".png");
           run("Close All");
      }
  }