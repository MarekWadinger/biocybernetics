function [time, glycemia, insulin] = importfile(filename, dataLines)
%IMPORTFILE2 Import data from a text file
%  [TIME, GLYCEMIA, INSULIN] = IMPORTFILE2(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the data as column
%  vectors.
%
%  [TIME, GLYCEMIA, INSULIN] = IMPORTFILE2(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  [time, glycemia, insulin] = importfile("Dat_IVGTT_AP.csv", [1, Inf]);


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["time", "glycemy", "insulin"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable(filename, opts);

%% Convert to output type
time = tbl.time;
glycemia = tbl.glycemy;
insulin = tbl.insulin;
end