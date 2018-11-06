%Rehg and Jones skin color mixture of Gaussian model, from
% "Statistical Color Models with Application to Skin Detection"
%function labelim = jrmogskin(colorim)
%  colorim must have 3 color planes
%     colorim(:,:,1) = red pixel values, 0 to 255
%     colorim(:,:,2) = green pix values, 0 to 255
%     colorim(:,:,3) = blue pix values,  0 to 255
%  labelim is 1 for skin pixels, 0 otherwise.
%  Robert Collins, Penn State University, 2005

function labelim = jrmogskin(colorim)

[nr,nc,nb] = size(colorim);
if (nb ~= 3)
    error('input image must be color\n');
end
redvals = double(reshape(colorim(:,:,1),nr*nc,1));
grevals = double(reshape(colorim(:,:,2),nr*nc,1));
bluvals = double(reshape(colorim(:,:,3),nr*nc,1));

%format of Mixture of Gaussian models:
%one gaussian component per row
%    rmean gmean bmean rvar gvar bvar weight
skinMOG = [...
  73.53  29.94  17.76   765.40  121.44  112.80  0.0294;
  249.71  233.94  217.49   39.94  154.44  396.05  0.0331;
  161.68  116.25  96.95   291.03  60.48  162.85  0.0654;
  186.07  136.62  114.40   274.95  64.60  198.27  0.0756;
  189.26  98.37  51.18   633.18  222.40  250.69  0.0554;
  247.00  152.20  90.84   65.23  691.53  609.92  0.0314;
  150.10  72.66  37.76   408.63  200.77  257.57  0.0454;
  206.85  171.09  156.34   530.08  155.08  572.79  0.0469;
  212.78  152.82  120.04   160.57  84.52  243.90  0.0956;
  234.87  175.43  138.94   163.80  121.57  279.22  0.0763;
  151.19  97.74  74.59   425.40  73.56  175.11  0.1100;
  120.52  77.55  59.82   330.45  70.34  151.82  0.0676;
  192.20  119.62  82.32   152.76  92.14  259.15  0.0755;
  214.29  136.08  87.24   204.90  140.17  270.19  0.0500;
  99.57  54.33  38.06   448.13  90.18  151.29  0.0667;
  238.88  203.08  176.91   178.38  156.27  404.99  0.0749];

nonskinMOG = [...
  254.37  254.41  253.82   2.77  2.81  5.46  0.0637;
  9.39  8.09  8.52   46.84  33.59  32.48  0.0516;
  96.57  96.95  91.53   280.69  156.79  436.58  0.0864;
  160.44  162.49  159.06   355.98  115.89  591.24  0.0636;
  74.98  63.23  46.33   414.84  245.95  361.27  0.0747;
  121.83  60.88  18.31   2502.24  1383.53  237.18  0.0365;
  202.18  154.88  91.04   957.42  1766.94  1582.52  0.0349;
  193.06  201.93  206.55   562.88  190.23  447.28  0.0649;
  51.88  57.14  61.55   344.11  191.77  433.40  0.0656;
  30.88  26.84  25.32   222.07  118.65  182.41  0.1189;
  44.97  85.96  131.95   651.32  840.52  963.67  0.0362;
  236.02  236.27  230.70   225.03  117.29  331.95  0.0849;
  207.86  191.20  164.12   494.04  237.69  533.52  0.0368;
  99.83  148.11  188.17   955.88  654.95  916.70  0.0389;
  135.06  131.92  123.10   350.35  130.30  388.43  0.0943;
  135.96  103.89  66.88   806.44  642.20  350.36  0.0477];


skinscores = zeros(size(redvals));
for i=1:size(skinMOG,1)
    p = skinMOG(i,:);
    tmp = ((redvals-p(1)).^2 / p(4) + (grevals-p(2)).^2 / p(5) + (bluvals-p(3)).^2 / p(6));
    tmp = p(7) * exp(- tmp / 2) / ((2 * pi)^(3/2) * sqrt(p(4)*p(5)*p(6)));
    skinscores = skinscores + tmp;
end


nonskinscores = zeros(size(redvals));
for i=1:size(nonskinMOG,1)
    p = nonskinMOG(i,:);
    tmp = ((redvals-p(1)).^2 / p(4) + (grevals-p(2)).^2 / p(5) + (bluvals-p(3)).^2 / p(6));
    tmp = p(7) * exp(- tmp / 2) / ((2 * pi)^(3/2) * sqrt(p(4)*p(5)*p(6)));
    nonskinscores = nonskinscores + tmp;
end

labelim = reshape((skinscores > nonskinscores), nr , nc);

return;