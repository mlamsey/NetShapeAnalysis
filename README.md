# NetShapeAnalysis README
Software tools for analyzing scans of additively manufactured parts written in MATLAB by the UTK ARC Laboratory Research Team

## Basic How-To: Surface Comparison
**Note: This only applies to surface comparisons, not cross sections**

### Import and Setup
**Exporting a Surface Comparison from GOM Inspect**
1. Create your surface comparison (usually on actual)
1. File > Export > Geometry > ASCII
1. Click on the surface comparison in the explorer on the left side of the application
1. In the Parameters tab, select "Deviation X/Y/Z" and "Total Deviation"

**Importing a Surface Comparison**
1. Obtain the absolute file path to a surface (i.e. `C:\Users\you\Documents\scan.asc`)
1. Instantiate a GOMScan using the GOMScan constructor: `g = GOMScan(absolute_file_path);`

**Contents of a GOMScan**
- `data` - the scan data, contained in a GOMScanData object
- `file_path` - the file path you used

**Contents of a GOMScanData**
- `x`, `y`, `z` - the position points along the surface
- `dx`, `dy`, `dz` - the vector components of the deviation vector in the XYZ directions
- `dev` - the magnitude of the deviation (sign indicates over/underfill)

### Analysis
**Cleaning  up the GOMScan**
Sometimes you need to do things to the GOMScan, like switch axes or remove bad data points, you can use ScanMethods. ScanMethods also provides functions for generating data windows, such as `GetScanDataSubsetInRange();`. See that file for a list of functions.

**Surface Roughness Metrics**
The raw calculations for the surface roughness metrics are contained in `SurfaceRoughnessCalculations.m`. If desired, these metrics can be queried using strings with `AnalysisMethods.QueryMetric();`. AnalysisMethods also provides layer-wise calculation wrappers. `PlotTools.m` contains useful plotting tools.

### Example
```
g = GOMScan('C:\Users\you\Documents\scan.asc');
ScanMethods.SwitchScanDataAxes(g.data,'y','z'); % switch y, z axes
rz_per_layer = AnalysisMethods.GetMetricForEachLayer(g,'Rz',2.31); % get a 1xn vector of metric values
plot(rz_per_layer);
```

### Notes:
Some scripts are also contained in this repository which handle more exploratory / complicated analysis. For example, `GKNInvarLA100Analysis3.m` and `GKNInvarLA100Analysis4.m` deal with different metrics and window sizes for the LA100 build.

## Basic How-To: Cross Section

### Export from GOM Inspect
1. Create your cross section
1. File > Export > Geometry > ASCII
1. Select the cross section from the explorer
1. In the Parameters tab, click "Write Normals"

### Import
1. Obtain the absolute file path to a surface (i.e. `C:\Users\you\Documents\scan.asc`)
1. Import using `cs = GOMCrossSection(file_path);`
1. You can also import a set of cross sections (saved as a cell array of GOMCrossSections) using `FileTools.ImportCrossSectionSetFromDirectory(directory_path);`

### Analysis
The class CrossSectionAnalysisMethods contains analysis methods for GOMCrossSections, and CrossSectionMethods contains manipulation methods for GOMCrossSections (i.e. switching axes). These methods have versions that work for individual cross sections as well as sets of cross sections.
```
cs_set = FileTools.ImportCrossSectionSetFromDirectory(dir_path);

% Manipulate one cross section:
cs_1 = cs_set{1};
cs_1 = CrossSectionMethods.SwitchCrossSectionParameters(cs_1,'y','z'); % switches y and z position axes
cs_1 = CrossSectionMethods.SwitchCrossSectionParameters(cs_1,'n_y','n_z'); % switches normal vector components as well
cs_1_wall_height = CrossSectionAnalysisMethods.GetWallHeight(cs_1,'z');

% Manipulate entire set:
cs_set = CrossSectionMethods.SwitchCrossSectionSetParameters(cs_set,'y','z');
set_wall_heights = CrossSectionAnalysisMethods.GetWallHeightForSet(cs_set,'z');
plot(set_wall_heights);
```
