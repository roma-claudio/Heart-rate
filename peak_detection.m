case 'ECG' % electrocardiogram
            ecgmother = 'db6';
            hrvmother = 'db1';
            lenchunk = 8; % seconds
            overlap = 6;  % seconds
            display = 0;
            displaybpm = 0;
            normalization = 0;

            fs = 1000; % 1kHz
            feature = 1; % extract feature or use raw data
            disp('Processing ECG signal...');

            tmpmin = inf;
            tmpmax = -inf;
            tmpdata = [];
            bpm = [];
            d = [];
            levHRV = 0;

            for s = numSubjects
                data = dlmread(strcat(folder, s{1}, '.csv'), ';', 1);
                tmpdata = data(:,3); % get ECG
                lenFrame = lenchunk*fs;
                overlapLen = overlap*fs;

                endidx = lenFrame:(lenFrame-overlapLen):length(tmpdata);
                startidx = endidx - (lenFrame - 1);
                numChunks = length(startidx);

                % Normalization
                if (normalization == 0)
                  tmpdata_new = tmpdata;
                else
                  Y_base = mean(tmpdata);
                  if (normalization == 1)
                    m = max(abs(tmpdata - Y_base));
                    tmpdata_new = (tmpdata - Y_base) / m;
                  elseif (normalization == 2)
                    tmpdata_new = (tmpdata - Y_base) / std(tmpdata);
                  elseif (normalization == 3) % minmax
                      tmpdata_new = (tmpdata-min(tmpdata) / max(tmpdata)- min(tmpdata));
                  end
                end

                if displaybpm
                    fbpm = figure;
                end

                % Split signal
                for curC = 1:numChunks

                    Y_norm = tmpdata_new(startidx(curC) : endidx(curC));

                    lev = wmaxlev(size(Y_norm, 1), ecgmother);
                    if display
                        fecg =
figure('units','normalized','outerposition',[0 0 1 1]);
                        subplot(3,1,1);
                        plot(Y_norm);
                        hold on;
                    end

                    % Denoise signal
                    [thr,sorh,keepapp] = ddencmp('den','wv',Y_norm);
                    Y_norm = wdencmp('gbl',Y_norm,ecgmother,lev,thr,sorh,keepapp);

                    if display
                        plot(Y_norm);
                        hold on;
                    end

                    % Detrend signal
                    m = mean(Y_norm);
                    fd = fdesign.highpass('N,Fc',1000,1/fs); %cut freq normalized to fs
                    H = design(fd);
                    Y_norm = filtfilt(H.Numerator,1,Y_norm);
                    Y_norm = Y_norm-mean(Y_norm);
                    recY = Y_norm + m;
                    %recY = recY.^2;
                    if display
                        plot(recY);
                        hold off;
                        drawnow;
                        xlim([0 length(Y_norm)]);
                        legend('original ECG', 'denoised ECG','detrended ECG');
                    end

                    % Extract HRV
                    [~,locs] = findpeaks(recY,'MinPeakProminence',0.07,...
                        'MinPeakDistance',round(fs/2));

                    if (length(locs) > 2)
                        HRV = locs(2:end) - locs(1:end-1);

                        dur = length(recY) * 1/fs;
                        bpm = [bpm length(locs)/dur*60];

                        if display
                            subplot(3,1,2);
                            findpeaks(recY,'MinPeakProminence',0.07,...
                                'MinPeakDistance',round(fs/2))
                            subplot(3,1,3);
                            plot(locs(2:end), HRV, 'o-');
                            title([num2str(curC) '/' num2str(numChunks-3) ' - ' num2str(bpm(curC)) ' BPM']);
                            xlim([0 length(Y_norm)]);
                            pause;
                            close(fecg);
                        end

                        if displaybpm
                            figure(fbpm)
                            plot(bpm, '-x');
                            title('BPM');
                            xlim([1 numChunks-3]);
                            ylim([50 150]);
                            drawnow;
                        end