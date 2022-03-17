function [] = mat2rawMASK(im,path,name)
mkdir(path);
imSize = size(im);
imDim = ndims(im);
c = filesep;
mhd = cell(13,1);
mhd{1} = 'ObjectType = Image';
mhd{2} = ['NDims = ' num2str(ndims(im))];
mhd{4} = ['ElementType = MET_USHORT'];
mhd{5} = 'CompressedData = False';
    if imDim == 2
    mhd{3} = ['DimSize = ' num2str(imSize(2)) ' ' num2str(imSize(1))];
    mhd{6} = 'ElementSpacing = 1 1';
    mhd{7} = 'TransformMatrix = 1 0 0 1';
    mhd{8} = 'Offset = 0 0';
    mhd{9} = 'CenterOfRotation = 0 0';
    elseif imDim == 3
    mhd{3} = ['DimSize = ' num2str(imSize(1)) ' ' num2str(imSize(2)) ' ' num2str(imSize(3))];
    mhd{6} = 'ElementSpacing = 1 1 1';
    mhd{7} = 'TransformMatrix = 1 0 0 0 0 1 0 0 0 1';
    mhd{8} = 'Offset = 0 0 0';
    mhd{9} = 'CenterOfRotation = 0 0 0';
    end
    
mhd{10} = 'BinaryData = True';
mhd{11} = 'BinaryDataByteOrderMSB = False'; 
mhd{12} = 'AnatomicalOrientation = RAI';


mhd{13} = ['ElementDataFile = ' name '.raw'];

fileID = fopen([path c name '.mhd'],'w+');
for i = 1:length(mhd)
    fprintf(fileID,'%s\n',mhd{i});
end
fclose(fileID);
%% RAW

im = im2double(im);
im = uint16(im.*2.^15);
im = permute(im,[2 1]); %prehodenie dimenzii

fileID = fopen([path c name '.raw'],'w+');
fwrite(fileID,im(:),'uint16');
fclose(fileID);
end