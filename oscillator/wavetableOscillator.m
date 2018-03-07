classdef wavetableOscillator
    %This class implements a simple wavetable synthesizer featuring two oscillators, envelopes and filters
    properties
        wvTb1;  %wavetable 1
        wvTb2;  %wavetable 2
        wv1Env; %amplitude envelope 1
        wv2Env; %amplitude envelope 2
        phaseEnv1;  %phase envelope 1
        phaseEnv2;  %phase envelope 2
        ftr1Cut;    %Lowpass filter 1 cutoff
        ftr1Res;    %Lowpass filter 1 resonance
        ftr2Cut;    %Lowpass filter 2 cutoff
        ftr2Res;    %Lowpass filter 2 resonance
        tbSize = 64;    %Wavetable size
        samplingRate = 44100;   %sampling rate
        interpSteps = 15;       %you can set a wavetable using less than tbSize points, this is used in the interpolation then
        vol1 = 1;               %gain for osc 1
        vol2 = 0;               %gain for osc 2
        amp = 1.0;              %Overall amplitude gain
    end
    methods
        function obj = wavetableOscillator(env1,env2,tbSize, samplingRate,tb1,tb2,vol1,vol2,phaseEnv1,phaseEnv2,ftr1Cut,ftr1Res,ftr2Cut,ftr2Res,interpSteps)
          %initializes the synth. there are default values for everything but the envleoipes
          if nargin > 2
              obj.tbSize = tbSize;
          end
          if nargin > 3
            obj.samplingRate = samplingRate;
          end

          if nargin > 4
              obj.wvTb1 = tb1;
          else
              obj.wvTb1(1:obj.tbSize) = sin(2*pi*(0:1/obj.tbSize:1-1/obj.tbSize));
          end

          if nargin > 5
              obj.wvTb2 = tb2;
          else
              obj.wvTb2(1:obj.tbSize) = 0.6366 * asin(sin(2*pi*(0:1/obj.tbSize:1-1/obj.tbSize)));
          end

          if nargin > 6
              obj.vol1 = vol1;
          end

          if nargin > 7
              obj.vol2 = vol2;
          end

          %Set Envelopes
          obj.wv1Env = env1;
          obj.wv2Env = env2;
          obj.phaseEnv1 = phaseEnv1;
          obj.phaseEnv2 = phaseEnv2;

          if nargin > 10
              obj.ftr1Cut = ftr1Cut;
              obj.ftr1Res = ftr1Res;
              obj.ftr2Cut = ftr2Cut;
              obj.ftr2Res = ftr2Res;
          end

          obj.interpSteps = interpSteps;
        end

        function obj = setTableUsingSpline(obj,tb1,tb2,smoothness1,smoothness2)
            %Computes smooth wavetables from the discrete signal tb1 and tb2. 

            targetIntervall = 0 : 1.0 / obj.tbSize : 1.0- 1.0 / obj.tbSize; %normalie

            if length(tb1) ~= obj.interpSteps || length(tb2) ~= obj.interpSteps
                error('Use a table length of obj.interpSteps plox')
            else
                obj.wvTb1 = ((1-smoothness1) * interp1(0 : 1 / (obj.interpSteps-1) : 1,tb1,targetIntervall,'linear')) ...
                              + (smoothness1 * interp1(0 : 1 / (obj.interpSteps-1) : 1,tb1,targetIntervall,'spline'));
                obj.wvTb2 = ((1-smoothness2) * interp1(0 : 1 / (obj.interpSteps-1) : 1,tb2,targetIntervall,'linear')) ...
                              + (smoothness2 * interp1(0 : 1 / (obj.interpSteps-1) : 1,tb2,targetIntervall,'spline'));

                obj.wvTb1 = obj.wvTb1 / max(abs(obj.wvTb1));
                obj.wvTb2 = obj.wvTb2 / max(abs(obj.wvTb2));
            end
        end

        function sig = getSound(obj,freq,lengthInS)
            %Generate sound at frequency freq of length lengthInS seconds

            lengthInSamples = round(lengthInS * obj.samplingRate);                  %desired output length
            sig = zeros(1,lengthInSamples);                                         %resulting signal
            sig1 = zeros(1,lengthInSamples);                                        %resulting signal Table1
            sig2 = zeros(1,lengthInSamples);                                        %resulting signal Table2
            vol1 = zeros(1,lengthInSamples);
            vol2 = zeros(1,lengthInSamples);
            cycleLength = 1.0 / freq;                                               %duration of one period
            timesteps(1:obj.tbSize) = 0 : 1.0 / obj.tbSize : 1.0- 1.0 / obj.tbSize; %timesteps in the table
            dt = 1.0 / obj.samplingRate;                                            %timestep
            t(1:lengthInSamples) = 0 : dt : lengthInS -  dt;

            tInCycleTimeFrame(:) = mod(t(:),cycleLength) ./ cycleLength;


            %If desired length is longer than the envelope, we cut

            shorterLength = min(length(tInCycleTimeFrame),length(obj.phaseEnv1.env));
            tInCycleTimeFrameWithPhase1(1:shorterLength) = mod(tInCycleTimeFrame(1:shorterLength) + obj.phaseEnv1.env(1:shorterLength),1);
            shorterLength = min(length(tInCycleTimeFrame),length(obj.phaseEnv2.env));
            tInCycleTimeFrameWithPhase2(1:shorterLength) = mod(tInCycleTimeFrame(1:shorterLength) + obj.phaseEnv2.env(1:shorterLength),1);

            %%%% Release the kraken!

            %generator signal
            wv1 = interp1(timesteps,obj.wvTb1,tInCycleTimeFrame,'spline');
            wv2 = interp1(timesteps,obj.wvTb2,tInCycleTimeFrame,'spline');
    
            envLength1 =  min(lengthInSamples,length(obj.wv1Env.env));
            envLength2 =  min(lengthInSamples,length(obj.wv2Env.env));

            % apply ennvelope
            vol1(1:envLength1) = obj.vol1 * obj.wv1Env.env(1:envLength1);
            vol2(1:envLength2) = obj.vol2 * obj.wv2Env.env(1:envLength2);

            sig1 = vol1 .* wv1;
            sig2 = vol2 .* wv2;

            %apply lowpass
            sig1 = lowpass(sig1,obj.samplingRate,obj.ftr1Cut,obj.ftr1Res,4);
            sig2 = lowpass(sig2,obj.samplingRate,obj.ftr2Cut,obj.ftr2Res,4);

            %aply overall gain
            sig = obj.amp * (sig1 + sig2);
        end
    end
end
