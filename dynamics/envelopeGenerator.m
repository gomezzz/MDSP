classdef envelopeGenerator
    %This class provides functionality for creating envelopes
    properties
        samplingRate;       %Sampling rate of corresponding signal, used to compute length in samples
        lengthInS;          %Envelope length in seconds
        lengthInSamples;    %Envelope length in samples
        attack;             %Attack in seconds
        decay;              %decay in seconds
        sustain;            %sustain in seconds
        release;            %release in seconds
        amp;                %Overall amplitude. Should be between 0 and 1
        env;                %Computed envelope
        smoothness;         %Smoothness of the desired envelope. Should be between 0 and 1
    end
    methods
        function obj = envelopeGenerator(samplingRate,a,d,s,r,amp,smoothness)
            %Init everything
            obj.samplingRate = samplingRate;
            obj.lengthInS = a + d + r;
            obj.lengthInSamples = round(obj.lengthInS * samplingRate);
            obj.attack = a;
            obj.decay = d;
            obj.sustain = s;
            obj.release = r;
            obj.amp = amp;
            obj.smoothness = smoothness;
            obj.env = obj.getEnvelope();
        end

        function env = getEnvelope(obj)
            %Computes the envelope by interpolation. Either linearly or using splines
            env = zeros(1,obj.lengthInSamples);
            targetIntervall = 0 : 1.0 / obj.lengthInSamples : 1.0- 1.0 / obj.lengthInSamples;
            ad = obj.attack+obj.decay;
            adr = obj.attack+obj.decay+obj.release;

            env = ((1-obj.smoothness) * interp1([0 obj.attack ad adr], [0 obj.amp obj.sustain 0], targetIntervall, 'linear') ...
                  + (obj.smoothness * interp1([0 obj.attack ad adr], [0 obj.amp obj.sustain 0], targetIntervall, 'spline')));

            envMax = max(abs(env));

            env = env / envMax;
            env = max(env,0.0);
        end
    end
end
