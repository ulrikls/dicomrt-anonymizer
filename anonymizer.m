
values.StudyInstanceUID = dicomuid;
values.SeriesInstanceUID = dicomuid;

d = dir('*.dcm');

rtplanning = dicominfo('rtss.dcm');

for p = 1:numel(d)
 
 currentInfo = dicominfo(d(p).name);
 currentSOPClassUID = currentInfo.SOPClassUID;
 currentSOPInstanceUID = currentInfo.SOPInstanceUID;
 
 [~, name,~] = fileparts(d(p).name);
 newName = sprintf('anon.%s.dcm', name);
 
 dicomanon(d(p).name, newName,'update', values)
 
 updatedInfo = dicominfo(newName);
 updatedSOPClassUID = updatedInfo.SOPClassUID;
 updatedSOPInstanceUID = updatedInfo.SOPInstanceUID;
 
 rtplanning = searchstruct(rtplanning, currentSOPClassUID, updatedSOPClassUID);
 rtplanning = searchstruct(rtplanning, currentSOPInstanceUID, updatedSOPInstanceUID);
  
end

dicomwrite(dicomread('rtss.dcm'),'anon.rtss.dcm',rtplanning,'CreateMode', 'copy')