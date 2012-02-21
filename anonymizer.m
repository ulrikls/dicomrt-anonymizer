%% ANONYMIZER
%
% Anonymizes DICOM-RT files while keeping the contour structeres connected
% to the individual slices in which they occur.
%
% Developed by Ulrik L. Stephansen & Jens T. Olesen
%
%%


% Generate new Instance ID's for the dicom series

values.StudyInstanceUID = dicomuid;
values.SeriesInstanceUID = dicomuid;

% Locate all dicom files

d = dir('*.dcm');

% Load the radiotherapy planning structure

rtplanning = dicominfo('rtss.dcm');

% Load all dicom files in the directory and extract SOP id's

for p = 1:numel(d)
 
 currentInfo = dicominfo(d(p).name);
 currentSOPClassUID = currentInfo.SOPClassUID;
 currentSOPInstanceUID = currentInfo.SOPInstanceUID;
 
 % Create new filename for anonymized dicom files
 
 [~, name,~] = fileparts(d(p).name);
 newName = sprintf('anon.%s.dcm', name);
 
 % Anonymize dicom data using built-in matlab function
 
 dicomanon(d(p).name, newName,'update', values)
 
 % Retrieve the new SOP id's
 
 updatedInfo = dicominfo(newName);
 updatedSOPClassUID = updatedInfo.SOPClassUID;
 updatedSOPInstanceUID = updatedInfo.SOPInstanceUID;
 
 % Replace the old SOP id's in the planning structure with the new SOP id's
 
 rtplanning = searchstruct(rtplanning, currentSOPClassUID, updatedSOPClassUID);
 rtplanning = searchstruct(rtplanning, currentSOPInstanceUID, updatedSOPInstanceUID);
  
end

% Save planning structure to dicom file

dicomwrite(dicomread('rtss.dcm'),'anon.rtss.dcm',rtplanning,'CreateMode', 'copy')