# Import the necessary Java classes
import sys

from java.io import File
from ij import IJ
from ij import WindowManager
from ij import ImagePlus
from ij import ImageStack

import ij.plugin.FolderOpener as FolderOpener
import fiji.plugin.trackmate.TrackMate as TrackMate
import fiji.plugin.trackmate.Settings as Settings
import fiji.plugin.trackmate.Model as Model
import fiji.plugin.trackmate.SelectionModel as SelectionModel
import fiji.plugin.trackmate.Logger as Logger
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
import fiji.plugin.trackmate.detection.LogDetectorFactory as LogDetectorFactory
import fiji.plugin.trackmate.detection.ThresholdDetectorFactory as ThresholdDetectorFactory
import fiji.plugin.trackmate.tracking.jaqaman.SparseLAPTrackerFactory as SparseLAPTrackerFactory

import fiji.plugin.trackmate.visualization.hyperstack.HyperStackDisplayer as HyperStackDisplayer
import fiji.plugin.trackmate.features.FeatureFilter as FeatureFilter
import fiji.plugin.trackmate.features.FeatureAnalyzer as FeatureAnalyzer

import os
import fiji.plugin.trackmate.action.ExportAllSpotsStatsAction as ExportAllSpotsStatsAction
from fiji.plugin.trackmate.action import TrackBranchAnalysis
from fiji.plugin.trackmate.graph import GraphUtils
from fiji.plugin.trackmate import SelectionModel
import fiji.plugin.trackmate.io.TmXmlReader as TmXmlReader
import fiji.plugin.trackmate.action.ExportTracksToXML as ExportTracksToXML
import fiji.plugin.trackmate.io.TmXmlWriter as TmXmlWriter
import fiji.plugin.trackmate.features.ModelFeatureUpdater as ModelFeatureUpdater
import fiji.plugin.trackmate.features.SpotFeatureCalculator as SpotFeatureCalculator
import fiji.plugin.trackmate.util.TMUtils as TMUtils
import fiji.plugin.trackmate.gui.displaysettings.DisplaySettingsIO as DisplaySettingsIO
import fiji.plugin.trackmate.gui.displaysettings.DisplaySettings as DisplaySettings
from fiji.plugin.trackmate.visualization.table import TrackTableView
import fiji.plugin.trackmate.visualization.table.AllSpotsTableView as AllSpotsTableView
import fiji.plugin.trackmate.visualization.table.TrackTableView

# Load your image

for a in range(1, 7):
	sample = str(a)
	folder= '\\' + sample + '\\Processed'
	
	#Data file folder location e.g. 'G:\\AST-TB\\Data\\1\\Processed'
	
	for filename in os.listdir(folder):   
		print filename  
		subfolder_name = folder + '\\' + filename
		
		output_name = '\\' + sample + '\\' + filename + '_' #Data file folder location e.g. 'G:\\AST-TB\\Signal\\1\\'
		print(output_name)
		
		# Get currently selected image
		#imp = WindowManager.getCurrentImage()
		#imp = IJ.openImage('http://fiji.sc/samples/FakeTracks.tif')
		imp = FolderOpener.open(subfolder_name);
		dims = imp.getDimensions();
		imp.setDimensions( dims[ 2 ], dims[ 4 ], dims[ 3 ] );
		#imp.show()
		
		# Create the TrackMate model and settings
		model = Model()
		settings = Settings(imp)
		
		# Configure the detector - here, we use the LogDetector for simplicity,
		# but you should replace it with the thresholding detector of your choice
		# and set its parameters.
		settings.detectorFactory = ThresholdDetectorFactory()
		settings.detectorSettings = {
		    'TARGET_CHANNEL' : 1,
		    'SIMPLIFY_CONTOURS' : True,
		    'INTENSITY_THRESHOLD' : 1200.0, # 2700 for TB
		}
		
		# Configure spot filters - Classical filter on radiu below the input value
		filter1 = FeatureFilter('RADIUS', 12.25, False) # 14.80 for TB
		settings.addSpotFilter(filter1)
		
		# Configure tracker
		settings.trackerFactory = SparseLAPTrackerFactory()
		settings.trackerSettings = settings.trackerFactory.getDefaultSettings()
		settings.trackerSettings['LINKING_MAX_DISTANCE'] = 4.0
		settings.trackerSettings['LINKING_FEATURE_PENALTIES'] = {}
		#gap closing
		settings.trackerSettings['ALLOW_GAP_CLOSING'] = True
		settings.trackerSettings['GAP_CLOSING_MAX_DISTANCE'] = 4.0
		settings.trackerSettings['MAX_FRAME_GAP'] = 50
		settings.trackerSettings['GAP_CLOSING_FEATURE_PENALTIES'] = {}
		settings.trackerSettings['ALLOW_TRACK_SPLITTING'] = False
		settings.trackerSettings['ALLOW_TRACK_MERGING'] = False
		
		# Add ALL the feature analyzers known to TrackMate
		settings.addAllAnalyzers()
		
		## Configure tracker filter
		filter2 = FeatureFilter('NUMBER_SPOTS', 20.18, True)
		settings.addTrackFilter(filter2)
		
		# Instantiate plugin
		
		trackmate = TrackMate(model,settings)
		
		# Process
		
		ok = trackmate.checkInput()
		if not ok:
			sys.exit(str(trackmate.getErrorMessage()))
		
		ok = trackmate.process()
		if not ok:
			sys.exit(str(trackmate.getErrorMessage()))
		
		# Create default SelectionModel and DisplaySettings
		sm = SelectionModel(trackmate.getModel())
		ds = DisplaySettings()
		
		# Create a File object from the string path
		outputSpotsFile = File(output_name + 'Spots in tracks statistics.csv')
		outputTracksFile = File(output_name + 'Tracks statistics.csv')
		outputAllSpotsFile = output_name + 'All Spots statistics.csv'
		
		# Save spot and track statistics
		trackTableView = TrackTableView(trackmate.getModel(), sm, ds)
		trackTableView.getSpotTable().exportToCsv(outputSpotsFile)
		trackTableView.getTrackTable().exportToCsv(outputTracksFile)
		
		# Save all spots table
		spotsTableView = AllSpotsTableView(trackmate.getModel(), sm, ds)
		spotsTableView.exportToCsv(outputAllSpotsFile)