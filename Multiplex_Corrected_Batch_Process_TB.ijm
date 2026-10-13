for (a = 1; a <7; a++) {
	for (b = 1; b < 10; b++) {
		run("Image Sequence...", "open=[/" + a + "/Raw/" + b + "/Img.tif]"); //Data file folder location e.g. "G:/AST-TB/Data/1/Raw/1/Img.tif"
		rename("data");
		selectWindow("data");
		run("Grouped Z Project...", "projection=[Average Intensity] group=4");
		selectWindow("data");
		close();
		selectWindow("AVG_data");
		rename("data");
		selectWindow("data");
		run("Z Project...","projection=[Min Intensity]");
		imageCalculator("Subtract create 32-bit stack", "data","MIN_data");
		selectWindow("data");
		close();
		selectWindow("MIN_data");
		close();
		selectWindow("Result of data");
		rename("data");
		selectWindow("data");
		run("Z Project...", "projection=Median");
		imageCalculator("Subtract create stack", "data","MED_data");
		selectWindow("data");
		close();
		selectWindow("MED_data");
		close();
		selectWindow("Result of data");
		rename("AVG_data");
		selectWindow("AVG_data");
		run("Subtract Background...", "rolling=10 stack");
		selectWindow("AVG_data");
		rename("test_");
		selectWindow("test_" );
		run("Image Sequence... ", "select=/" + a + "/Processed/" + b + "/ dir=/" + a + "/Processed/" + b + "/ format=TIFF"); //Data file folder location e.g. "G:/AST-TB/Data/1/Processed/1/Img.TIFF"
		selectWindow("test_");
		rename("AVG_data_");
		selectWindow("AVG_data_");
		close();
		print(a,b);
	}
}