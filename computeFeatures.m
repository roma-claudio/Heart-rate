function features = computeFeatures(img, typeFeat)


[nrows,ncols, ~] = size(img);

switch typeFeat
    case 'gray'
        imgG = double(rgb2gray(img));
        features = reshape(imgG,nrows*ncols,1);
    case 'gray+XY'
        imgG = double(rgb2gray(img));
        gray = reshape(imgG,nrows*ncols,1);
        [Cgrid, Rgrid] = getXY(nrows, ncols);
        features = normFeat([gray, Cgrid, Rgrid]);
        
    case 'RGB'
        colors = double( img );
        features = reshape(colors,nrows*ncols,3);
        
    case 'RGB+XY' 
        colors = reshape(double( img ),nrows*ncols,3);
        [Cgrid, Rgrid] = getXY(nrows, ncols);
        features = normFeat([colors,  Cgrid,  Rgrid]);
        
    case 'Lab'
        cform = makecform('srgb2lab');
        lab_img = applycform(img,cform);
        colors =  double(lab_img(:,:,2:3));
        features = reshape(colors,nrows*ncols,2);
        
    case 'Lab+XY'
        cform = makecform('srgb2lab');
        lab_img = applycform(img,cform);
        colors = reshape(double(lab_img(:,:,2:3)), nrows*ncols,2);
        
        [Cgrid, Rgrid] = getXY(nrows, ncols);
        features = normFeat([colors,  Cgrid,  Rgrid]);
end
 
end

function [Cgrid, Rgrid] = getXY(nrows, ncols)
ROWS = 1:nrows;
COLS = 1:ncols;
[Cgrid, Rgrid] = meshgrid(COLS, ROWS);
Cgrid = reshape(Cgrid,nrows*ncols,1);
Rgrid = reshape(Rgrid,nrows*ncols,1);
end


function featN = normFeat ( feat)
featN = (feat - repmat(mean(feat), size(feat,1),1)) ./ (repmat(std(feat), size(feat,1),1)+eps);
end

