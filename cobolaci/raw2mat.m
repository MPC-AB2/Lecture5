function [im] = raw2mat(path)

fileID = fopen(path);

tline = fgetl(fileID);
i=0;
mhd = cell(1,1);
while ischar(tline)
    i = i+1;
    mhd{i} = tline;
    if contains(tline,'DimSize')
       tmp = regexprep(tline, 'DimSize = ','');
       imSize = str2num(tmp);
    end
    tline = fgetl(fileID);
end
fclose(fileID);

im = zeros((imSize),'uint16');
fileID = fopen(regexprep(path,'mhd','raw'));
tmp = fread(fileID,imSize(1)*imSize(2),'uint16=>uint16');
im(:) = tmp;
im = permute(im,[2 1]);
fclose(fileID)
end