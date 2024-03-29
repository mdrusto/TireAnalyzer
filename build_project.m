% Build script to be run by github-actions

% Version number: change this to generate a new release
version = "1.3.1";

appFile = "source/TireAnalyzer.mlapp";

installerName = "TireAnalyzer_Install_v" + strrep(version, ".", "_");

fileList = [fullfile("source", {dir("source\*.m").name}), fullfile("source", "Utility", {dir("source\Utility\*.m").name}), fullfile("source", "Test sections", {dir("source\Test sections\*.m").name}), fullfile("source", "Data separation", {dir("source\Data separation\*.m").name}), fullfile("tire_data", {dir("tire_data\*.mat").name})];

buildResults = compiler.build.standaloneApplication(appFile, ...
    'ExecutableName', installerName, ...
    'AdditionalFiles', fileList);

compiler.package.installer(buildResults, ...
    'ApplicationName', 'Tire Analyzer', ...
    'InstallerName', installerName, ...
    'OutputDir', 'app', ...
    'RuntimeDelivery', 'web', ...
    'Version', version);